//
//  AddItemVC.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 4/21/22.
//

import UIKit
import Firebase
import FirebaseStorage
import SwiftUI

class AddItemVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let currentUid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    let imagePicker = UIImagePickerController()
    
    var listId: String?
    var imageURL: URL? = nil
    var imageLink: String = ""
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemCategory: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemLink: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func toggleValidation(validationField: UITextField) {
        if validationField.text == "" {
            // validationField.backgroundColor = UIColor.orange
            validationField.layer.borderWidth = 1.0
            validationField.layer.borderColor = UIColor.red.cgColor
            return
        }
        // validationField.backgroundColor = UIColor.white
        validationField.layer.borderWidth = 0.0
        return
    }
    
    func canOpenURL(validationField: UITextField) -> Bool {
        guard let url = NSURL(string: validationField.text!) else {
            return false
        }
        
        if !UIApplication.shared.canOpenURL(url as URL) {
            return false
        }
        
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        return predicate.evaluate(with: validationField.text)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard listId != nil else{
            print("List ID is nil")
            return
        }
        
        print(canOpenURL(validationField: self.itemLink))
        
        // validate required fields or prevent submission
        if self.itemName.text == "" ||  self.itemPrice.text == "" || self.itemLink.text == ""{
            toggleValidation(validationField: self.itemName)
            toggleValidation(validationField: self.itemPrice)
            toggleValidation(validationField: self.itemLink)
            Util.launchAlert(
                senderVC: self,
                title: "Error",
                message: "Required fields were left empty",
                btnText: "Ok"
            )
            return
        }else if canOpenURL(validationField: self.itemLink) == false {
            self.itemLink.layer.borderWidth = 1.0
            self.itemLink.layer.borderColor = UIColor.red.cgColor
            Util.launchAlert(
                senderVC: self,
                title: "Error",
                message: "Please enter a valid link",
                btnText: "Ok"
            )
            return
        }
        else {
            self.itemLink.layer.borderWidth = 0.0
        }
        
        
        print("List ID is \(listId ?? "nil")")
        
        if self.imageLink != "" {
            uploadMedia(imgName: "\(itemName.text ?? "")_\(listId!)") { (myURL) in
                
                self.db.collection("item").addDocument(data: [
                    "listId": self.listId ?? "",
                    "name": self.itemName.text ?? "",
                    "category": self.itemCategory.text ?? "",
                    "price": self.itemPrice.text ?? "",
                    "link": self.itemLink.text ?? "",
                    "userId": self.currentUid,
                    "image": self.imageLink,
                ]) { err in
                    if let err = err {
                        //Error savng data
                        print("Error adding document: \(err)")
                        Util.launchAlert(
                            senderVC: self,
                            title: "Error",
                            message: "Failed to create new item 🙁, please try again later",
                            btnText: "Ok"
                        )
                    } else {
                        // return to previous screen after save
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
        else {
            var ref: DocumentReference? = nil
            ref = self.db.collection("item").addDocument(data: [
                "listId": self.listId ?? "",
                "name": self.itemName.text ?? "",
                "category": self.itemCategory.text ?? "",
                "price": self.itemPrice.text ?? "",
                "link": self.itemLink.text ?? "",
                "userId": self.currentUid,
                "image": self.imageLink,
            ]) { err in
                if let err = err {
                    //Error savng data
                    print("Error adding document: \(err)")
                    Util.launchAlert(
                        senderVC: self,
                        title: "Error",
                        message: "Account created but failed to save user data.",
                        btnText: "Ok"
                    )
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                    // return to previous screen after save
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    @IBAction func AddPhoto(_ sender: UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL
            // imageLink = info[UIImagePickerController.InfoKey.imageURL] as? String
            // print("IMAGE LINK")
            // print(imageLink)
            print(imageURL ?? "No URL")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadMedia(imgName: String, completion: @escaping (URL?) -> ()) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        // Create a reference to the file you want to upload
        let imageRef = storageRef.child("images/\(imgName)")
        imageLink = "images/\(imgName)"
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = imageRef.putFile(from: imageURL!, metadata: nil) { metadata, error in
            guard metadata != nil else {
                // Uh-oh, an error occurred!
                return
            }
            
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                completion(downloadURL)
            }
        }
    }
    
}
