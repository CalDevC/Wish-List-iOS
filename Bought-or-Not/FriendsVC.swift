//
//  FriendsVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 4/21/22.
//

import UIKit
import Firebase

class FriendsVC: UIViewController {
    
    let db = Firestore.firestore()
//    var currentUID = Auth.auth().currentUser?.uid
    
    
    override func viewWillAppear(_ animated: Bool) {
//        guard let currentUID = Auth.auth().currentUser?.uid else{
//            return
//        }
//        let userDataDocRef = db.collection("users").document(currentUID)
//        userDataDocRef.getDocument { (doc, error) in
//            if let document = doc, document.exists {
//
//                //Get the list of taken usernames
//                let takenUsernames: [String: String] = document.data() as! [String: String]
//
//                //For each taken username check if it is equal to the provided username
//                for pair in takenUsernames{
//                    print("\(pair.value) - \(username == pair.value)")
//                    if(username == pair.value){
//                        Util.launchAlert(senderVC: self,
//                                         title: "Error",
//                                         message: "username not available.",
//                                         btnText: "Ok")
//                        self.acitivtyIndicator.stopAnimating()
//                        return
//                    }
//                }
//
//                //Create the new user
//                self.createNewUser(
//                    username: username, email: email,
//                    password: password, name: name,
//                    phoneNumber: phoneNumber, docRef: takenUsernamesDocRef
//                )
//            } else {
//                print("Document does not exist")
//                Util.launchAlert(senderVC: self,
//                                 title: "Error",
//                                 message: "Our servers are undergoing maintenance, please try again later.",
//                                 btnText: "Ok")
//                self.acitivtyIndicator.stopAnimating()
//                return
//            }
//        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
