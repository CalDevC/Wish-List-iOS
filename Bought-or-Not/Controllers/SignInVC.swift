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
        
        Util.clearErrorOnTextfield(textfield: passwordInput)
        Util.clearErrorOnTextfield(textfield: emailInput)
        
        if(emailInput.unwrappedText == ""){
            Util.errorOnTextfield(textfield: emailInput)
            Util.launchAlert(
                senderVC: self,
                title: "Error",
                message: "Please provide the email associated with your account",
                btnText: "Ok"
            )
            return
        }else if(passwordInput.unwrappedText == ""){
            Util.errorOnTextfield(textfield: passwordInput)
            Util.launchAlert(
                senderVC: self,
                title: "Error",
                message: "Please provide your password",
                btnText: "Ok"
            )
            return
        }
        
        activityIndicator.startAnimating()
        signInButton.isEnabled = false
        
        Auth.auth().signIn(
            withEmail: emailInput.unwrappedText,
            password: passwordInput.unwrappedText
        ) { authResult, error in
            if let err = error{
                print(err.localizedDescription)
                
                Util.launchAlert(
                    senderVC: self,
                    title: "Error",
                    message: "Invalid email or password",
                    btnText: "Ok"
                )
                
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
                    Util.launchAlert(
                        senderVC: self,
                        title: "Internal Error",
                        message: "User data could not be loaded, please try again later",
                        btnText: "Ok"
                    )
                    print(err)
                    return
                }
                
                if let document = doc, document.exists {
                    
                    let docData: [String: Any] = document.data() ?? ["nil": "nil"]
                    
                    guard let fullName: String = docData["fullName"] as? String,
                          let username: String = docData["username"] as? String
                    else{
                        Util.launchAlert(
                            senderVC: self,
                            title: "Internal Error",
                            message: "User data could not be loaded, please try again later",
                            btnText: "Ok"
                        )
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
        guard let tabBarVC = segue.destination as? TabBarVC else {
            return
        }
        
        tabBarVC.currentUser = currentUser
    }
}

