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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    var userLists: [String] = ["New List"]
    var userListIds: [String] = ["0"]
    var currentUser: User?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailInput.delegate = self
        passwordInput.delegate = self
        activityIndicator.hidesWhenStopped = true
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
        
        activityIndicator.startAnimating()
        signInButton.isEnabled = false
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let err = error{
                print(err.localizedDescription)
                //TODO: Inform user of sign in error
                self.signInButton.isEnabled = true
                self.activityIndicator.stopAnimating()
                return
            }
            
            guard let currentUID = authResult?.user.uid else{
                return
            }
            
            let userDataDocRef = self.db.collection("users").document(currentUID)
            userDataDocRef.getDocument { (doc, error) in
                if let err = error{
                    //TODO: Notify user of error
                    print(err)
                }
                
                if let document = doc, document.exists {
                    
                    let docData: [String: Any] = document.data() ?? ["nil": "nil"]
                    
                    guard let fullName: String = docData["fullName"] as? String,
                          let username: String = docData["username"] as? String
                    else{
                        return
                    }
                    
                    self.currentUser = User(uid: currentUID, fullName: fullName, username: username)
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: Constants.segues.signinToHome, sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let barViewControllers = segue.destination as! UITabBarController
        let destinationVC = barViewControllers.viewControllers![0] as! WishListCollectionVC
        destinationVC.currentUser = currentUser
    }
}

