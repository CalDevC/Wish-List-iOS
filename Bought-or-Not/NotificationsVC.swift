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
    var notifications: [String] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Add the custom cell to the table view
        let nib = UINib(nibName: "NotificationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NotificationCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let currentUID = Auth.auth().currentUser?.uid else{
            return
        }
        
        notifications = []
        fetchNotifications(forUID: currentUID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        
        cell.notificationLabel.text = notifications[indexPath.row]
        
        return cell
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

                guard let notificationList: [String] = docData["notifications"] as? [String] else{
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
