//
//  HomeCollectionViewController.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 3/20/22.
//

import UIKit
import Firebase

var userLists: [String] = []
var userListIds: [String] = []

class HomeCollectionViewController: UICollectionViewController {
    
    // @IBOutlet var collectionView: UICollectionView!
    @IBAction func userSettingsPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.segues.homeToUserSettings, sender: self)
    }
    
    let currentUid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    
    // var dataSource: [String] = ["New List", "My Birthday", "Christmas"]
    // var userLists: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCells()
        
        print("CURRENT UID")
        print(currentUid)
        
        userLists.append("New List")
        userListIds.append("0")
        print(userLists)
        
        let wishlists = db.collection("wishlist").whereField("userId", isEqualTo: currentUid).getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("QUERY SUCCESSFUL")
                for document in querySnapshot!.documents {
                    print("DOCUMENT")
                    print("\(document.documentID) => \(document.data())")
                    // add listId to array
                    userListIds.append(document.documentID)
                    let listData: [String: String] = document.data() as! [String: String]
                    for pair in listData {
                        if(pair.key == "title") {
                            print(pair.value)
                            userLists.append(pair.value)
                            print(userLists)
                        }
                    }
                }
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return populateLists(userLists: userLists).count
        return userLists.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        cell.backgroundColor = UIColor.orange
        
        // must reload data to read data retrieved from firebase
        collectionView.reloadData()

        if let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HomeCollectionViewCell {
            listCell.configure(with: userLists[indexPath.row])
            cell = listCell
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
        collectionView.deselectItem(at: indexPath, animated: true)
        print(userLists[indexPath.row])
        performSegue(withIdentifier: "homeToWishlist", sender: indexPath)
        // print("user id:" + Auth.auth().currentUser!.uid)
    }
    
    func layoutCells() {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
            layout.minimumInteritemSpacing = 5.0
            layout.minimumLineSpacing = 5.0
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40)/3, height: ((UIScreen.main.bounds.size.width - 40)/3))
            collectionView!.collectionViewLayout = layout
    }
    
    // prepare data to carry to next viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let wishlistVC = segue.destination as? WishlistTableVC else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        
        // use section property embedded in indexPath to pull wishlist items
        wishlistVC.listId = userListIds[indexPath.row]
    }
}



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource



    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

