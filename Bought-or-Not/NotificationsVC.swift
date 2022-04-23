//
//  NotificationsVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 4/22/22.
//

import UIKit
import Firebase

class NotificationsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var notifications: [Notification] = []
    let db = Firestore.firestore()
    let currentUID: String = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Add the custom cell to the table view
        let nib = UINib(nibName: "NotificationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NotificationCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        notifications = []
        fetchNotifications(forUID: currentUID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.notificationLabel.text = notifications[indexPath.row].message
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notif = notifications[indexPath.row]
        if(notif.message.contains("has requested to be your friend!")){
            //Go to accept friend request screen
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if(segue.identifier == Constants.segues.notifToProfile){
            guard let profileVC = segue.destination as? ProfileVC else {
                return
            }
            guard let indexPath = sender as? IndexPath else {
                return
            }
            
            let notif = notifications[indexPath.row]
            profileVC.user = notif.sender
            profileVC.currentUser = User(uid: self.currentUID, fullName: "", username: "")
            profileVC.numBtns = 2
            profileVC.actions = ["Accept", "Decline"]
        }
    }
    
    func fetchNotifications(forUID userUID: String){
        let userDataDocRef = db.collection("users").document(userUID)
        userDataDocRef.getDocument { (doc, error) in
            if let err = error{
                //TODO: Notify user of error
                print(err)
            }

            if let document = doc, document.exists {

                let docData: [String: Any] = document.data() ?? ["nil": "nil"]

                guard let notificationList: [Notification] = docData["notifications"] as? [Notification] else{
                    return
                }
                
                //For each notification
                for notification in notificationList{
                    self.notifications.append(notification)
                }
                
                self.tableView.reloadData()
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
