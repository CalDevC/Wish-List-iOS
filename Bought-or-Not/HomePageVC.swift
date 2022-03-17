//
//  HomePageVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 3/17/22.
//

import UIKit
import Firebase

class HomePageVC: UIViewController {
    
    @IBAction func signoutBtnPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            //SIgn out the user
            try firebaseAuth.signOut()
            
            //Go back to landing page
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            //TODO: Notify user of sign out failure
            print("Error signing out: %@", signOutError)
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
