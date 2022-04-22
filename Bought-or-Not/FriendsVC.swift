//
//  FriendsVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 4/21/22.
//

import UIKit
import Firebase

struct friend{
    let uid: String
    let fullName: String
    let username: String
}

class FriendsVC: UIViewController {
    
    let db = Firestore.firestore()
    var friendList: [friend] = []
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let currentUID = Auth.auth().currentUser?.uid else{
            return
        }
        
        //Populate friends list
        let userDataDocRef = db.collection("users").document(currentUID)
        userDataDocRef.getDocument { (doc, error) in
            if let err = error{
                //TODO: Notify user of error
                print(err)
            }
            
            if let document = doc, document.exists {
                
                let docData: [String: Any] = document.data() ?? ["nil": "nil"]
                
                guard let friendList: [String] = docData["friends"] as? [String] else{
                    return
                }
                
                print("Friends: ")
                //For each friend
                for friend in friendList{
                    self.addFriend(friendUID: friend)
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func addFriend(friendUID: String){
        let userDataDocRef = self.db.collection("users").document(friendUID)
        userDataDocRef.getDocument { (doc, error) in
            if let err = error{
                //TODO: Notify user of error
                print(err)
            }
            
            if let document = doc, document.exists {
                //Add friend with details
                let friendData: [String: Any] = document.data() ?? ["nil": "nil"]
                
                let friend = friend(
                    uid: friendData["uid"] as! String,
                    fullName: friendData["fullName"] as! String,
                    username: friendData["username"] as! String
                )
                
                print("FRIEND: \(friend.username)")
                
                self.friendList.append(friend)
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
