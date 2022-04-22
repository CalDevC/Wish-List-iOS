//
//  profileVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 4/22/22.
//

import UIKit
import Firebase

class ProfileVC: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addFriendBtn: UIButton!
    
    var user: User?
    var currentUser: User?
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Username is \(user?.username ?? "nil")")
        usernameLabel.text = user?.username
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addFriendBtn.isEnabled = true
    }
    
    @IBAction func addFriendBtnPressed(_ sender: UIButton) {
        addFriendBtn.isEnabled = false
        //Add UID the signed in user's friend list
        guard let userToNotify = user else{
            addFriendBtn.isEnabled = true
            return
        }
        
        guard let currentUser = currentUser else{
            addFriendBtn.isEnabled = true
            return
        }
        
//        let userDocRef = db.collection("users").document(currentUID)
//        userDocRef.updateData([
//            "friends": FieldValue.arrayUnion([user.uid])
//        ]) { error in
//            if let error = error {
//                Util.launchAlert(
//                    senderVC: self,
//                    title: "Error",
//                    message: "Failed to add friend, please try again later :(",
//                    btnText: "ok"
//                )
//                self.addFriendBtn.isEnabled = true
//                print("Error updating document: \(error)")
//            } else {
//                print("Document successfully updated")
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
        
        let userToNotifyDocRef = db.collection("users").document(userToNotify.uid)
        userToNotifyDocRef.updateData([
            "notifications": FieldValue.arrayUnion([
                "\(currentUser.username) (\(currentUser.fullName)) has requested to be your friend!"
            ])
        ]) { error in
            if let error = error {
                Util.launchAlert(
                    senderVC: self,
                    title: "Error",
                    message: "Failed to add friend, please try again later :(",
                    btnText: "ok"
                )
                self.addFriendBtn.isEnabled = true
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
                self.navigationController?.popViewController(animated: true)
            }
        }
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
