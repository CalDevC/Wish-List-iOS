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
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Username is \(user?.username ?? "nil")")
        usernameLabel.text = user?.username
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addFriendBtnPressed(_ sender: UIButton) {
        //Add UID the signed in user's friend list
        guard let user = user else{
            return
        }
        
        guard let currentUID = Auth.auth().currentUser?.uid else{
            return
        }
        
        let userDocRef = db.collection("users").document(currentUID)
        userDocRef.updateData([
            "friends": FieldValue.arrayUnion([user.uid])
        ]) { error in
            if let error = error {
                Util.launchAlert(
                    senderVC: self,
                    title: "Error",
                    message: "Failed to add friend, please try again later :(",
                    btnText: "ok"
                )
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
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
