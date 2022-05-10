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
    let db = Firestore.firestore()
    var listId: String!
    var itemIdx: Int?
    var itemIds: [String] = []
    var currentUser: User!
    var owner: User!
    
    @IBOutlet var wishlistTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var addItemButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        //Add the custom cell to the table view
        let nib = UINib(nibName: "ItemTableViewCell", bundle: nil)
        wishlistTableView.register(nib, forCellReuseIdentifier: "ItemTableViewCell")
        wishlistTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        if(owner.uid == currentUser.uid){
            //Show +
            self.navigationItem.rightBarButtonItem = self.addItemButton
        } else{
            //Hide +
            self.navigationItem.rightBarButtonItem = nil
        }
        
        wishlistItems = []
        itemIds = []
        getData(compHandler: reloadItems)
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
                        self.itemIds.append(document.documentID)
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
        
        print("ITEM IDS:")
        print(self.itemIds)
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "wishlistToAddItem", sender: nil)
    }
    
    func removeItem(atIdx idx: Int){
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
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("WISHLIST COUNT: \(wishlistItems.count)")
            wishlistItems.remove(at: indexPath.row)
            itemIds.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            removeItem(atIdx: indexPath.row)
        }
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

    // define segue action when a cell in a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let itemIdx = indexPath.row
        print(itemIdx)
        performSegue(withIdentifier: "ToItemDetailSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "wishlistToAddItem" {
            guard let addItemVC = segue.destination as? AddItemVC else {
                return
            }
            addItemVC.listId = listId
        }
        else if segue.identifier == "ToItemDetailSegue" {
            guard let itemDetailVC = segue.destination as? ItemDetailVC else {
                return
            }
            guard let indexPath = sender as? IndexPath else {
                return
            }
            itemDetailVC.itemId = itemIds[indexPath.row]                
        }
        
        // addItemVC.listId = listId
        // use section property embedded in indexPath to pull wishlist items
        // wishlistVC.listId = userListIds[indexPath.row]
    }
    
}
