//
//  NewListVC.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 4/20/22.
//

import UIKit
import Firebase

class NewListVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let currentUid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleInput: UITextField!
    
    @IBOutlet weak var occasionLabel: UILabel!
    @IBOutlet weak var occasionPicker: UIPickerView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var accessSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        occasionPicker.delegate = self
        occasionPicker.dataSource = self
        titleInput.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.minimumDate = NSDate.now
        occasionPicker.selectRow(45, inComponent: 0, animated: false)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("EDITING TEXT")
        Util.clearErrorOnTextfield(textfield: textField)
    }
    
    //Dismisses keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        if(titleInput == nil || titleInput.unwrappedText == ""){
            Util.errorOnTextfield(textfield: titleInput)
            Util.launchAlert(
                senderVC: self,
                title: "Cannot Create List",
                message: "Please provide a title for your new wish list",
                btnText: "Ok"
            )
            return
        } else{
            Util.clearErrorOnTextfield(textfield: titleInput)
        }
        
        let row = occasionPicker.selectedRow(inComponent: 0)
        
        var pickerOccasion: String = occasionPicker.delegate?.pickerView?(
            occasionPicker,
            titleForRow: row,
            forComponent: 0
        ) ?? "None"
        
        if (pickerOccasion == "Select Occasion"){
            pickerOccasion = "None"
        }
        let pickerDate: Date = datePicker.date
        print(pickerDate)
        let publicSwitch: Bool = accessSwitch.isOn
        print(publicSwitch)
        
        //Add new list data
        var ref: DocumentReference? = nil
        ref = self.db.collection("wishlist").addDocument(data: [
            "title": titleInput.unwrappedText,
            "occasion": pickerOccasion,
            "date": pickerDate,
            "public": publicSwitch,
            "userId": currentUid
        ]) { err in
            if let err = err {
                //Error savng data
                print("Error adding document: \(err)")
                Util.launchAlert(
                    senderVC: self,
                    title: "Error",
                    message: "Account created but failed to save user data.",
                    btnText: "Ok"
                )
                return
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    // Number of columns of data
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in NewListVC: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Constants.data.occassionWheelData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    @objc func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Constants.data.occassionWheelData[row]
    }
    
}
