//
//  WishListCollectionViewController.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 3/20/22.
//

import UIKit
import Firebase

class WishListCollectionVC: UICollectionViewController {
    
    var friendView: Bool?
    
    var userLists: [String] = []
    var userListIds: [String] = []
    
    let currentUid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()
    let reuseIdentifier = "cell"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        layoutCells()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "WishListCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.title = Constants.viewNames.wishLists
        
        userLists = []
        userListIds = []
        
        db.collection("wishlist").whereField("userId", isEqualTo: currentUid).getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("QUERY SUCCESSFUL")
                self.userLists.append("New List")
                self.userListIds.append("0")
                
                for document in querySnapshot!.documents {
                    print("DOCUMENT")
                    print("\(document.documentID) => \(document.data())")
                    // add listId to array
                    self.userListIds.append(document.documentID)
                                        
                    for elem in document.data() {
                        if (elem.key == "title") {
                            let listTitle = elem.value as? String
                            self.userLists.append(listTitle!)
                            // print(self.userLists)
                        }
                    }
                }
                self.collectionView.reloadData()
                self.activityIndicator.stopAnimating()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! WishListCollectionViewCell
        
        cell.label.text = self.userLists[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // print("hello")
        collectionView.deselectItem(at: indexPath, animated: true)
        print(userLists[indexPath.row])
        if (indexPath.row == 0) {
            performSegue(withIdentifier: "homeToNewList", sender: indexPath)
        }
        else {
            performSegue(withIdentifier: "homeToWishlist", sender: indexPath)
        }
        print("user id:" + Auth.auth().currentUser!.uid)
    }
    
    func layoutCells() {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
            layout.minimumInteritemSpacing = 5.0
            layout.minimumLineSpacing = 10.0
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40)/3, height: ((UIScreen.main.bounds.size.width - 40)/3))
            collectionView!.collectionViewLayout = layout
    }
    
    // prepare data to carry to next viewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let wishlistVC = segue.destination as? ItemTableVC else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        
        // use section property embedded in indexPath to pull wishlist items
        wishlistVC.listId = userListIds[indexPath.row]
    }
}
