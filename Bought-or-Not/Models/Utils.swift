//
//  Utils.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 3/23/22.
//

import Foundation
import UIKit

class Util{
    //Launch an alert to notify the user of something
    static func launchAlert(senderVC: UIViewController, title: String, message: String, btnText: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: btnText, style: UIAlertAction.Style.default, handler: nil))
        senderVC.present(alert, animated: true, completion: nil)
    }
    
    //Add a red border to the textfield
    static func errorOnTextfield(textfield: UITextField){
        textfield.layer.borderWidth = 1.0
        textfield.layer.borderColor = UIColor.red.cgColor
    }
    
    //Remove any red border from the textfield
    static func clearErrorOnTextfield(textfield: UITextField){
        textfield.layer.borderWidth = 0.0
    }
    
}
