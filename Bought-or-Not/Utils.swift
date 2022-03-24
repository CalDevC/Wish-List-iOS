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
    
}
