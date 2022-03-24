//
//  RegistrationVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 3/17/22.
//

import UIKit
import Firebase
import simd

//Added an unwrapped text value to avoid lots of unwrapping
extension UITextField {
    var unwrappedText: String {
        return self.text ?? ""
     }
}

class RegistrationVC: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var cPasswordInput: UITextField!
    @IBOutlet weak var acitivtyIndicator: UIActivityIndicatorView!
    
    var emptyField: Bool = false
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        acitivtyIndicator.hidesWhenStopped = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func registerBtnPressed(_ sender: Any){
        acitivtyIndicator.startAnimating()
        let requiredTextfields = [passwordInput, emailInput, usernameInput,
                        nameInput, cPasswordInput]
        
        let password = passwordInput.unwrappedText, cPassword = cPasswordInput.unwrappedText,
            email = emailInput.unwrappedText, username = usernameInput.unwrappedText,
            name = nameInput.unwrappedText, phoneNumber = phoneNumberInput.unwrappedText
        
        //Check if any textfields are empty
        for input in requiredTextfields{
            guard let input = input else{
                acitivtyIndicator.stopAnimating()
                return
            }
            
            if(input.unwrappedText == ""){
                launchAlert(title: "Error", message: "Some required fields were left empty.", btnText: "Ok")
                checkForEmptyText(textfield: input)
                emptyField = true
            }
        }
        
        //Don't attempt account creation with an empty field
        if(emptyField){
            acitivtyIndicator.stopAnimating()
            return
        }
    
        //Check that passwords match
        if(password != cPassword){
            errorOnTextfield(textfield: passwordInput)
            errorOnTextfield(textfield: cPasswordInput)
            self.launchAlert(title: "Error",
                             message: "Passwords do not match.",
                             btnText: "Ok")
            acitivtyIndicator.stopAnimating()
            return
        }
        
        //Check that passowrds are strong enough
        let result = isStrongPassword(password: password)
        if(!result.result){
            errorOnTextfield(textfield: passwordInput)
            errorOnTextfield(textfield: cPasswordInput)
            launchAlert(title: "Error",
                        message: result.message,
                        btnText: "Ok")
        }
        
        //Check that username is not taken
        let takenUsernamesDocRef = db.collection("users").document("takenUsernames")
        takenUsernamesDocRef.getDocument { (doc, error) in
            if let document = doc, document.exists {
                
                //Get the list of taken usernames
                let takenUsernames: [String: String] = document.data() as! [String: String]
                
                //For each taken username check if it is equal to the provided username
                for pair in takenUsernames{
                    print("\(pair.value) - \(username == pair.value)")
                    if(username == pair.value){
                        self.launchAlert(title: "Error",
                                         message: "username not available.",
                                         btnText: "Ok")
                        self.acitivtyIndicator.stopAnimating()
                        return
                    }
                }
                
                //Create the new user
                self.createNewUser(username: username, email: email,
                                   password: password, name: name,
                                   phoneNumber: phoneNumber, docRef: takenUsernamesDocRef)
            } else {
                print("Document does not exist")
                self.launchAlert(title: "Error",
                                 message: "Our servers are undergoing maintenance, please try again later.",
                                 btnText: "Ok")
                self.acitivtyIndicator.stopAnimating()
                return
            }
        }
    }
    
    
    //When a required textfield finishes being edited
    @IBAction func textEditingDidEnd(_ sender: UITextField) {
        emptyField = false
        clearErrorOnTextfield(textfield: sender)
        checkForEmptyText(textfield: sender)
    }
    
    //Add a red border to the textfield
    func errorOnTextfield(textfield: UITextField){
        textfield.layer.borderWidth = 1.0
        textfield.layer.borderColor = UIColor.red.cgColor
    }
    
    //Remove any red border from the textfield
    func clearErrorOnTextfield(textfield: UITextField){
        textfield.layer.borderWidth = 0.0
    }
    
    //Mark the textfield as errored if its content is empty
    func checkForEmptyText(textfield: UITextField?){
        guard let input = textfield else{
            return
        }
        
        if(input.unwrappedText == ""){
            errorOnTextfield(textfield: input)
            emptyField = true
        }
    }
    
    //Launch an alert to notify the user of something
    func launchAlert(title: String, message: String, btnText: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: btnText, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    //Checks for a strong password. If result is false then message will provide reasoning
    func isStrongPassword(password: String) -> (result: Bool, message: String){
        let specialChars = CharacterSet(charactersIn: "!@#$%&*")
        
        //Check if the password contains at least 1 special chracter
        if(password.rangeOfCharacter(from: specialChars) == nil){
            return (false, "Password must contain at least one special character (!, @, #, $, %, &, *).")
        }
        
        //Check that password is at least 6 characters long
        if(password.count < 6){
            return (false, "Password must be at least 6 characters long.")
        }
        
        //Return true if all checks are passed
        return (true, "")
    }
    
    func displaySignUpPendingAlert() -> UIAlertController {
            //create an alert controller
        let pending = UIAlertController(title: "Creating New User", message: nil, preferredStyle: .alert)

            //create an activity indicator
            let indicator = UIActivityIndicatorView(frame: pending.view.bounds)
            indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            //add the activity indicator as a subview of the alert controller's view
            pending.view.addSubview(indicator)
            indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
            indicator.startAnimating()

        self.present(pending, animated: true, completion: nil)

            return pending
    }
    
    //Attempt to create a new user in Firebase and add additional data
    func createNewUser(username: String, email: String, password: String,
                       name: String, phoneNumber: String, docRef: DocumentReference){
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error, let errCode = AuthErrorCode(rawValue: error!._code){
                var errMessage: String = ""
                
                print(err.localizedDescription)  //Inform developer of error
                
                //Choose an appropriate error message based on the error code
                switch(errCode){
                case .emailAlreadyInUse:
                    self.errorOnTextfield(textfield: self.emailInput)
                    errMessage = "The email '\(email)' is already associated with an account."
                    break
                case .invalidEmail:
                    self.errorOnTextfield(textfield: self.emailInput)
                    errMessage = "Please enter a valid email address."
                    break
                default:
                    errMessage = err.localizedDescription
                }
                
                //Launch the error alert with the appropriate message
                self.launchAlert(title: "Error",
                                 message: errMessage,
                                 btnText: "Ok")
                self.acitivtyIndicator.stopAnimating()
                return
            }
            
            //Add user data
            var ref: DocumentReference? = nil
            ref = self.db.collection("users").addDocument(data: [
                "username": username,
                "fullName": name,
                "phoneNumber": phoneNumber,
                "uid": authResult!.user.uid
            ]) { err in
                if let err = err {
                    //Error savng data
                    print("Error adding document: \(err)")
                    self.launchAlert(title: "Error",
                                     message: "Account created but failed to save user data.",
                                     btnText: "Ok")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            
            //Add username to the takenUsernames list
            docRef.updateData([authResult!.user.uid: username])
            
            self.acitivtyIndicator.stopAnimating()
            self.performSegue(withIdentifier: "toHome", sender: self)
        }

    }

}
