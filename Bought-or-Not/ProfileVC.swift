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
    @IBOutlet weak var actionBtn: UIButton!
    
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
        actionBtn.isEnabled = true
        actionBtn.titleLabel?.text = actions[0]
    }
    
    @IBAction func actionBtnPressed(_ sender: UIButton) {
        actionBtn.isEnabled = false
        
        if(actions[0] == "Accept"){
            print("Accepted :)")
            guard let currentUID = Auth.auth().currentUser?.uid else{
                return
            }
            
            guard let otherUID = user?.uid else{
                return
            }
            
            self.updateOtherUser(otherUID: otherUID, currentUID: currentUID)
            
        } else if(actions[0] == "Send Friend Request"){
            //Add UID the signed in user's friend list
            sendNotification()
        
    }
}
    
    func sendNotification(){
        guard let userToNotify = user else{
            actionBtn.isEnabled = true
            return
        }
        
        guard let currentUser = currentUser else{
            actionBtn.isEnabled = true
            return
        }
        
        let username = currentUser.username
        let fullName = currentUser.fullName
        db.collection("users").document(userToNotify.uid).updateData(
            ["notifications":
                FieldValue.arrayUnion(
                    [[
                        "message": "\(username) (\(fullName)) has requested to be your friend!",
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
                self.actionBtn.isEnabled = true
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    func updateCurrentUser(currentUID: String, otherUser: User){
        db.collection("users").document(currentUID).updateData([
            "friends": FieldValue.arrayUnion([otherUser.uid]),
            "notifications": FieldValue.arrayRemove(
                [[
                    "message": "\(otherUser.username) (\(otherUser.fullName)) has requested to be your friend!",
                     "sender": [
                        "uid": otherUser.uid,
                        "fullName": otherUser.fullName,
                        "username": otherUser.username
                     ]
                ]]
            )
        ]) { error in
            if let error = error {
                Util.launchAlert(
                    senderVC: self,
                    title: "Error",
                    message: "Failed to add friend, please try again later :(",
                    btnText: "ok"
                )
                self.actionBtn.isEnabled = true
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateOtherUser(otherUID: String, currentUID: String){
        let otherUserDocRef = db.collection("users").document(otherUID)
        otherUserDocRef.getDocument { (doc, error) in
            if let err = error{
                //TODO: Notify user of error
                print(err)
            }

            if let document = doc, document.exists {

                let otherUserData: [String: Any] = document.data()!
                let otherUser = User(
                    uid: otherUserData["uid"] as! String,
                    fullName: otherUserData["fullName"] as! String,
                    username: otherUserData["username"] as! String
                )
                
                self.updateCurrentUser(currentUID: currentUID, otherUser: otherUser)
            }
        }
        
        otherUserDocRef.updateData([
            "friends": FieldValue.arrayUnion([currentUID])
        ]) { error in
            if let error = error {
                Util.launchAlert(
                    senderVC: self,
                    title: "Error",
                    message: "Failed to add friend, please try again later :(",
                    btnText: "ok"
                )
                self.actionBtn.isEnabled = true
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}
