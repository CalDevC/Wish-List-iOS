//
//  RegistrationVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 3/17/22.
//

import UIKit
import Firebase

class RegistrationVC: UIViewController {

    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var phoneNumberInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var cPasswordInput: UITextField!
    
    @IBAction func registerBtnPressed(_ sender: Any) {
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
        guard let username = usernameInput.text else{
            //TODO: No username error
            return
        }
        guard let name = nameInput.text else{
            //TODO: No name error
            return
        }
        guard let phoneNumber = phoneNumberInput.text else{
            //TODO: No phoneNumber error
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let err = error{
                print(err.localizedDescription)
                //TODO: Inform user of account creation error
                return
            }
            
            //Add user data
            //TODO: Possibly make this async?
            let db = Firestore.firestore()
            var ref: DocumentReference? = nil
            ref = db.collection("users").addDocument(data: [
                "username": username,
                "fullName": name,
                "phoneNumber": phoneNumber
            ]) { err in
                if let err = err {
                    //TODO: Inform user of error saving data
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            
            self.performSegue(withIdentifier: "toHome", sender: self)
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
