//
//  NewListVC.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 4/20/22.
//

import UIKit

class NewListVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var occasionLabel: UILabel!
    @IBOutlet weak var occasionPicker: UIPickerView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!

    @IBOutlet weak var accessLabel: UILabel!
    @IBOutlet weak var accessSwitch: UISwitch!
    
    var occasionData: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        occasionPicker.delegate = self
        occasionPicker.dataSource = self
        
        // Do any additional setup after loading the view.
        occasionData = ["Birthday", "Christmas", "Graduation", "Hanukkah", "Housewarming", "Retirement", "Valentine's Day", "Other"]
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
