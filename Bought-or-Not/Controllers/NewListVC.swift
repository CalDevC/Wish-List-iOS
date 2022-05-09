//
//  NewListVC.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 4/20/22.
//

import UIKit
import Firebase

class NewListVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleInput: UITextField!
    
    @IBOutlet weak var occasionLabel: UILabel!
    @IBOutlet weak var occasionPicker: UIPickerView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var accessSwitch: UISwitch!
    
    @IBAction func submitTapped(_ sender: UIButton) {
        let listTitle = titleInput.text!
        print(listTitle)
        let component = 0
        let row = occasionPicker.selectedRow(inComponent: component)
        var pickerOccasion = occasionPicker.delegate?.pickerView?(occasionPicker, titleForRow: row, forComponent: component)
        print(pickerOccasion!)
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
            "title": listTitle,
            "occasion": pickerOccasion,
            "date": pickerDate,
            "public": publicSwitch,
            "userId": currentUid
        ]) { err in
            if let err = err {
                //Error savng data
                print("Error adding document: \(err)")
                Util.launchAlert(senderVC: self,
                                 title: "Error",
                                 message: "Account created but failed to save user data.",
                                 btnText: "Ok")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    let currentUid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    var occasionData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        occasionPicker.delegate = self
        occasionPicker.dataSource = self
        
        // Do any additional setup after loading the view.
        occasionData = ["Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other", "Select Occasion", "Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        datePicker.minimumDate = NSDate.now
        occasionPicker.selectRow(45, inComponent: 0, animated: false)
    }
    
    // Number of columns of data
    @objc(numberOfComponentsInPickerView:) func numberOfComponents(in NewListVC: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    @objc func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return occasionData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    @objc func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return occasionData[row]
    }

}
