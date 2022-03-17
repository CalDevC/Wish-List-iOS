//
//  LandingPageVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 3/17/22.
//

import UIKit

class LandingPageVC: UIViewController {
    
    //Button actions
    @IBAction func signInBtnPress(_ sender: Any) {
        performSegue(withIdentifier: "toSignIn", sender: self)
    }
    
    @IBAction func createAcctBtnPress(_ sender: Any) {
        performSegue(withIdentifier: "toRegistration", sender: self)
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
