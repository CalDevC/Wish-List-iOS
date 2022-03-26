//
//  WishlistTableVC.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 3/25/22.
//

import UIKit
import Firebase

class WishlistTableVC: UITableViewController {
    
    var wishlistItems: [String] = []
    
    let currentUid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    var listId: String?
    
    @IBOutlet var wishlistTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add the custom cell to the table view
        let nib = UINib(nibName: "WishlistTableViewCell", bundle: nil)
        wishlistTableView.register(nib, forCellReuseIdentifier: "WishlistTableViewCell")
        wishlistTableView.dataSource = self
        
        print("View did load")
        getData(compHandler: reloadItems)
        print("Done with data")
        
        wishlistTableView.reloadData()
    }
    
    func reloadItems(){
        print("DONE")
        self.wishlistTableView.reloadData()
    }
    
    func getData(compHandler: @escaping()->Void){
        if(listId != "0") {
            let listItems = db.collection("item").whereField("listId", isEqualTo: listId).getDocuments() {(querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    print("QUERY SUCCESSFUL")
                    for document in querySnapshot!.documents {
                        print("DOCUMENT")
                        print("\(document.documentID) => \(document.data())")
                        // add listId to array
                        // userListIds.append(document.documentID)
                        let listData: [String: String] = document.data() as! [String: String]
                        for pair in listData {
                            if(pair.key == "name") {
                                print(pair.value)
                                self.wishlistItems.append(pair.value)
                                print(self.wishlistItems)
                            }
                        }
                    }
                    compHandler()
                }
            }
        }
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WishlistTableViewCell") as? WishlistTableViewCell else {
            return UITableViewCell()
        }
        // use list for items
        let item = wishlistItems[indexPath.row]
        cell.wishlistCell.text = item
        return cell
    }
    
}
