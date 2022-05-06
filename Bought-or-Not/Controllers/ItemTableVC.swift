//
//  WishlistTableVC.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 3/25/22.
//

import UIKit
import Firebase

class ItemTableVC: UITableViewController {
    
    var wishlistItems: [String] = []
    let currentUid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    var listId: String?
    
    @IBOutlet var wishlistTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        //Add the custom cell to the table view
        let nib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        wishlistTableView.register(nib, forCellReuseIdentifier: "ItemTableViewCell")
        wishlistTableView.dataSource = self
        
        activityIndicator.startAnimating()
        getData(compHandler: reloadItems)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //TODO: Check if the current user is the list owner
            //Check if listId belongs to the currentUid
            //If so then show the '+' button
            //Else hide the '+' button
    }
    
    func reloadItems(){
        print("DONE")
        activityIndicator.stopAnimating()
        self.wishlistTableView.reloadData()
    }
    
    func getData(compHandler: @escaping()->Void){
        if(listId != "0") {
            let listItems = db.collection("item").whereField("listId", isEqualTo: listId).getDocuments() {(querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("DOCUMENT")
                        print("\(document.documentID) => \(document.data())")
                        // add listId to array
                        // userListIds.append(document.documentID)
                        let listData: [String: String] = document.data() as! [String: String]
                        for pair in listData {
                            if(pair.key == "name") {
                                self.wishlistItems.append(pair.value)
                            }
                        }
                    }
                    compHandler()
                }
            }
        }
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "wishlistToAddItem", sender: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // tells app what data to output in which section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlistItems.count
    }
    
    // define content that is meant to appear in a given cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // must reload data to read data retrieved from firebase
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell") as? ItemTableViewCell else {
            return UITableViewCell()
        }
        // use list for items
        let item = wishlistItems[indexPath.row]
        cell.wishlistCell.text = "   " + item
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let addItemVC = segue.destination as? AddItemVC else {
            return
        }
        
        addItemVC.listId = listId
        // use section property embedded in indexPath to pull wishlist items
        // wishlistVC.listId = userListIds[indexPath.row]
    }
    
}