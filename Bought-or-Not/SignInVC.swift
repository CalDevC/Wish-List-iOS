//
//  ViewController.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 3/17/22.
//

import UIKit
import Firebase

class SignInVC: UIViewController {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!

    var userLists: [String] = ["New List"]
    var userListIds: [String] = ["0"]
    
    @IBAction func signInBtnPressed(_ sender: Any) {
        //
        //TODO: validation checking for all textfield inputs
        //
        guard let password = passwordInput.text else{
            //TODO: No password error
            return
        }
        
        guard let email = emailInput.text else{
            //TODO: No email error
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let err = error{
                print(err.localizedDescription)
                //TODO: Inform user of sign in error
                return
            }

            self.performSegue(withIdentifier: Constants.segues.signinToHome, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

