//
//  ViewController.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 3/17/22.
//

import UIKit
import Firebase

class SignInVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    

    var userLists: [String] = ["New List"]
    var userListIds: [String] = ["0"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailInput.delegate = self
        passwordInput.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        signInButton.isEnabled = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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
        
        signInButton.isEnabled = false
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let err = error{
                print(err.localizedDescription)
                //TODO: Inform user of sign in error
                self.signInButton.isEnabled = true
                return
            }
            
            self.performSegue(withIdentifier: Constants.segues.signinToHome, sender: self)
        }
    }
}

