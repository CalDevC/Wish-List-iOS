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
    var numBtns: Int!
    var actions: [String]!
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Username is \(user?.username ?? "nil")")
        usernameLabel.text = user?.username
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addFriendBtn.isEnabled = true
        addFriendBtn.titleLabel?.text = actions[0]
    }
    
    @IBAction func addFriendBtnPressed(_ sender: UIButton) {
        addFriendBtn.isEnabled = false
        
        if(actions[0] == "Accept"){
            print("Accepted :)")
        } else if(actions[0] == "Send Friend Request"){
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
            let username = currentUser.username
            let fullName = currentUser.fullName
            userToNotifyDocRef.updateData(
                ["notifications":
                    FieldValue.arrayUnion(
                        [[
                            "message": "\(username) (\(fullName)) has sent you a friend request!",
                             "sender": [
                                "uid": currentUser.uid,
                                "fullName": fullName,
                                "username": username
                             ]
                        ]]
                    )
                ]
            ){ error in
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
