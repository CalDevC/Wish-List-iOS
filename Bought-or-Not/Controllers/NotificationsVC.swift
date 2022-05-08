//
//  NotificationsVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 4/22/22.
//

import UIKit
import Firebase
import SwiftUI

class NotificationsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var notifications: [Notification] = []
    let db = Firestore.firestore()
    var currentUser: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        
        let tabBar = tabBarController as! TabBarVC
        currentUser = tabBar.currentUser
        
        //Add the custom cell to the table view
        let nib = UINib(nibName: "NotificationCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NotificationCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.navigationItem.title = Constants.viewNames.notifications
        self.tabBarController?.navigationItem.rightBarButtonItem = nil
        notifications = []
        activityIndicator.startAnimating()
        tableView.reloadData()
        fetchNotifications(forUID: currentUser.uid)
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
        print("Clicked " + notif.message)
        if(notif.message.contains("has requested to be your friend!")){
            //Go to accept friend request screen
            performSegue(withIdentifier: Constants.segues.notifToProfile, sender: indexPath)
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
            profileVC.numBtns = 2
            profileVC.actions = ["Accept", "Decline"]
        }
    }
    
    func fetchNotifications(forUID userUID: String){
        print("Fetching notifs")
        let userDataDocRef = db.collection("users").document(userUID)
        userDataDocRef.getDocument { (doc, error) in
            if let err = error{
                //TODO: Notify user of error
                print(err)
            }

            if let document = doc, document.exists {
                print("doc exists")
                let recievedNotifs: [Any] = document.get("notifications") as? [Any] ?? []
                print(recievedNotifs)
                
                for notif in recievedNotifs{
                    let data = try? JSONSerialization.data(withJSONObject: notif)
                    let decoder = JSONDecoder()
                    
                    do{
                        self.notifications.append(try decoder.decode(Notification.self, from: data!))
                    } catch{
                        print(error)
                    }
                }
                
                if(self.notifications.isEmpty){
                    self.notifications.append(Notification(
                        message: "Nothing new here 🙌",
                        sender: User(uid: "", fullName: "",username: "")
                    ))
                }
                
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
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
