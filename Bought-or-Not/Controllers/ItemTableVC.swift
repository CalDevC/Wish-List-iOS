//
//  WishlistTableVC.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 3/25/22.
//

import UIKit
import Firebase

class ItemTableVC: UITableViewController {
    
    var wishlistItems: [Item] = []
    let db = Firestore.firestore()
    var listId: String!
    var itemIdx: Int?
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
        
        getData(compHandler: reloadItems)
    }
    
    func reloadItems(){
        activityIndicator.stopAnimating()
        self.wishlistTableView.reloadData()
    }
    
    func getData(compHandler: @escaping()->Void){
        db.collection("item").whereField("listId", isEqualTo: listId as String).getDocuments()
        {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                if(querySnapshot!.documents.count == self.wishlistItems.count){
                    self.activityIndicator.stopAnimating()
                    return
                } else{
                    self.wishlistItems = []
                }
                
                for document in querySnapshot!.documents {
                    
                    let itemData: [String: String] = document.data() as! [String: String]
                    let item = Item(
                        category: itemData["category"] ?? "",
                        image: itemData["image"] ?? "",
                        link: itemData["link"] ?? "",
                        listId: itemData["listId"] ?? "",
                        name: itemData["name"] ?? "",
                        price: itemData["price"] ?? "",
                        userId: itemData["userId"] ?? "",
                        itemId: document.documentID
                    )
                    
                    self.wishlistItems.append(item)
                    
                }
                compHandler()
            }
        }
    }
    
    @IBAction func addItem(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "wishlistToAddItem", sender: nil)
    }
    
    func removeItem(atIdx idx: Int){
        let itemID = wishlistItems[idx].itemId
        db.collection("item").document(itemID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // tells app what data to output in which section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wishlistItems.count
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle
    {
        if(owner.uid != currentUser.uid){
            return UITableViewCell.EditingStyle.none
        } else {
            return UITableViewCell.EditingStyle.delete
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if(editingStyle == .delete){
            removeItem(atIdx: indexPath.row)
            wishlistItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        cell.wishlistCell.text = "   " + item.name
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
            
            itemDetailVC.item = wishlistItems[indexPath.row]
        }
    }
    
}
