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
        guard let currentUID = Auth.auth().currentUser?.uid else{
            return
        }
        
        let userDataDocRef = db.collection("users").document(currentUID)
        userDataDocRef.getDocument { (doc, error) in
            if let document = doc, document.exists {
                
                //Get the list of taken usernames
                let docData: [String: Any] = document.data() ?? ["nil": "nil"]
//                let docData = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(docData)")
                
                guard let friendList: [String] = docData["friends"] as? [String] else{
                    return
                }

                print("Friends: ")
                //For each friend
                for entry in friendList{
                    print("FRIEND: \(entry)")
                }
            }
        }

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
