//
//  RegistrationVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 3/17/22.
//

import UIKit
import Firebase

//Know that the text is not nill because default is empty string we add an
//unwrapped text value to avoid lots of unwrapping
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
    var emptyField: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        let requiredTextfields = [passwordInput, emailInput, usernameInput,
                        nameInput, cPasswordInput]
        
        let password = passwordInput.unwrappedText, cPassword = cPasswordInput.unwrappedText,
            email = emailInput.unwrappedText, username = usernameInput.unwrappedText,
            name = nameInput.unwrappedText, phoneNumber = phoneNumberInput.unwrappedText
        
        //Check if any textfields are empty
        for input in requiredTextfields{
            guard let input = input else{
                return
            }
            
            if(input.unwrappedText == ""){
                launchAlert(title: "Error", message: "Some required fields were left empty.", btnText: "Ok")
                checkForEmptyText(textfield: input)
                emptyField = true
            }
        }
        
        if(emptyField){ return } //Don't attempt account creation with an empty field
    
        if(password != cPassword){
            errorOnTextfield(textfield: passwordInput)
            errorOnTextfield(textfield: cPasswordInput)
            self.launchAlert(title: "Error",
                             message: "Passwords do not match.",
                             btnText: "Ok")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error, let errCode = AuthErrorCode(rawValue: error!._code){
                var errMessage: String = ""
                //TODO: Inform user of account creation error
                print(err.localizedDescription)
                switch(errCode){
                case .emailAlreadyInUse:
                    errMessage = "The email '\(email)' is already associated with an account."
                    break
                case .invalidEmail:
                    errMessage = "Please enter a vlaid email address."
                    break
                default:
                    errMessage = err.localizedDescription
                }
                
                self.launchAlert(title: "Error",
                                 message: errMessage,
                                 btnText: "Ok")
                return
            }
            
            //Add user data
            //TODO: Possibly make this async?
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            ref = db.collection("users").addDocument(data: [
                "username": username,
                "fullName": name,
                "phoneNumber": phoneNumber,
                "uid": authResult!.user.uid
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                    self.launchAlert(title: "Error",
                                     message: "Account created but failed to save user data.",
                                     btnText: "Ok")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            
            self.performSegue(withIdentifier: "toHome", sender: self)
        }
    }
    
    @IBAction func textEditingDidEnd(_ sender: UITextField) {
        emptyField = false
        clearErrorOnTextfield(textfield: sender)
        checkForEmptyText(textfield: sender)
    }
    

    func errorOnTextfield(textfield: UITextField){
        textfield.layer.borderWidth = 1.0
        textfield.layer.borderColor = UIColor.red.cgColor
    }
    
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

}
