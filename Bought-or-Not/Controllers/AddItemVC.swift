//
//  AddItemVC.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 4/21/22.
//

import UIKit
import Firebase
import FirebaseStorage

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
    
    @IBAction func saveButton(_ sender: UIButton) {
        guard listId != nil else{
            print("List ID is nil")
            return
        }
        
        print("List ID is \(listId ?? "nil")")
        
        if self.imageLink != "" {
            uploadMedia(imgName: "\(itemName.text ?? "")_\(listId!)") { (myURL) in
                // output download URL for image
                print("Got here with URL: ")
                print(myURL ?? "nil URL")
                
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
                        Util.launchAlert(senderVC: self,
                                         title: "Error",
                                         message: "Account created but failed to save user data.",
                                         btnText: "Ok")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
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
                    Util.launchAlert(senderVC: self,
                                     title: "Error",
                                     message: "Account created but failed to save user data.",
                                     btnText: "Ok")
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
