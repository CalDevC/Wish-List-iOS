//
//  profileVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 4/22/22.
//

import UIKit

class ProfileVC: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var addFriendBtn: UIButton!
    
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Username is \(user?.username ?? "nil")")
        usernameLabel.text = user?.username
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addFriendBtnPressed(_ sender: UIButton) {
        //Add UID the signed in user's friend list
        
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
