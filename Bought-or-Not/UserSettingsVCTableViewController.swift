//
//  UserSettingsVCTableViewController.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 3/23/22.
//

import UIKit
import Firebase

class UserSettingsVCTableViewController: UITableViewController {
    
    //All options and their symbols to be displayed in the user settings
    let menuOptions: [(img: String, text: String)] = [
        ("person.text.rectangle", Constants.userSettings.editAcct),
        ("figure.wave.circle", Constants.userSettings.signOut)]
    
    //The headers of each section in teh user settings
    let sectionHeaders = ["User Settings"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add the custom cell to the table view
        let nib = UINib(nibName: "UserSettingsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "UserSettingsCell")
        tableView.dataSource = self
    }
    
//MARK: - Populate tableView

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sectionHeaders[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuOptions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserSettingsCell", for: indexPath) as! UserSettingsCell
        
        //Set the desired text and symbol using the menuOptions list
        cell.cellImage.image = UIImage(systemName: menuOptions[indexPath.row].img)
        cell.cellText.text = menuOptions[indexPath.row].text

        return cell
    }
    
//MARK: - Handle menu choice selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(menuOptions[indexPath.row].text){
        case Constants.userSettings.editAcct:
            break
        case Constants.userSettings.signOut:
            let firebaseAuth = Auth.auth()
            do {
                //Sign out the user
                try firebaseAuth.signOut()
                
                //Go back to landing page
                navigationController?.popToRootViewController(animated: true)
                print("POPPED")
            } catch let signOutError as NSError {
                //Inform the user of a sign out error
                Util.launchAlert(senderVC: self,
                                 title: "Sign-out Error",
                                 message: Constants.userSettings.signOutErr,
                                 btnText: "Ok")
                print("Error signing out: \(signOutError)")
            }
            print("END")
            break
        default:
            return
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
