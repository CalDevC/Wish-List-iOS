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
    var imageURL: URL? = nil
    
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemCategory: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var itemLink: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        var ref: DocumentReference? = nil
        ref = self.db.collection("item").addDocument(data: [
            "listId": "wop56ReOFQxvn8tX3tiI",
            "name": itemName.text,
            "category": itemCategory.text,
            "price": itemPrice.text,
            "link": itemLink.text,
            "userId": currentUid
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
            }
        }
        
        guard let newImage = imageView.image else {
            return
        }
        uploadMedia(image: newImage, itemID: ref!.documentID) { (myURL) in
            // output download URL for image
            print(myURL)
        }
        
        // return to previous screen after save
        self.navigationController?.popViewController(animated: true)
    }
    
    let imagePicker = UIImagePickerController()
    
    @IBAction func AddPhoto(_ sender: UIButton) {
        // print("Herro!")
        
        // present(imagePicker, animated: true, completion: nil)
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
            
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! CFString
            // if mediaType == kUTTypeImage {
            imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
            print(imageURL)
                // Handle your logic here, e.g. uploading file to Cloud Storage for Firebase
            // }
        }

        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadMedia(image :UIImage, itemID: String, completion: @escaping (URL?) -> ()) {
        let storage = Storage.storage()
        // let url = "gs://bought-or-not-d8d87.appspot.com"
        let storageRef = storage.reference()
        
        let data = Data()

        // Create file name
        let fileExtension = imageURL!.pathExtension
        let fileName = "images/" + itemID + ".\(fileExtension)"
        
        print(fileName)
        
        // let imageRef = storageRef.child(fileName)

        let md = StorageMetadata()
        md.contentType = "image/\(fileExtension)"
        print(md)

        let imageRef = Storage.storage().reference().child(fileName)

        imageRef.putData(data, metadata: md) { (metadata, error) in
             if error == nil {
                 imageRef.downloadURL(completion: { (url, error) in
                     print("Done, url is \(String(describing: url))")
                 })
             } else {
                 print("error \(String(describing: error))")
             }
         }
        
        // let uploadMetadata = StorageMetadata()
        // uploadMetadata.contentType = "image/jpeg"
        
        // Upload the file to the path "images/rivers.jpg"
        /*
        let uploadTask = imageRef.putData(data, metadata: uploadMetadata) { (metadata, error) in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
            print("metadata error")
            return
          }

          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          imageRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
                // Uh-oh, an error occurred!
                print("no download URL")
                return
            }
            print(downloadURL)
          }
        }
         */
        
        // return downloadURL
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
