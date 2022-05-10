//
//  WishListCollectionViewController.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 3/20/22.
//

import UIKit
import Firebase

class WishListCollectionVC: UICollectionViewController, UIGestureRecognizerDelegate {
    
    var currentUser: User!
    var owner: User!
    var userLists: [String] = []
    var userListIds: [String] = []
    var currentUid: String!
    
    let db = Firestore.firestore()
    let reuseIdentifier = "cell"
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newListBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        if(owner == nil){
            let tabBar = tabBarController as! TabBarVC
            currentUser = tabBar.currentUser
            owner = currentUser
        }
        
        layoutCells()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "WishListCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        let longPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gestureRecognizer:)))
        longPress.minimumPressDuration = 0.5
        longPress.delegate = self
        longPress.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.title = Constants.viewNames.wishLists
        
        if(owner.uid == currentUser.uid){
            self.tabBarController?.navigationItem.rightBarButtonItem = self.newListBtn
        } else{
            self.tabBarController?.navigationItem.rightBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
        }
        
        userLists = []
        userListIds = []
        
        db.collection("wishlist").whereField("userId", isEqualTo: owner!.uid).getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
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
    
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer){

        if (gestureRecognizer.state != UIGestureRecognizer.State.began){
            return
        }

        let location = gestureRecognizer.location(in: self.collectionView)

        if let indexPath: NSIndexPath = self.collectionView?.indexPathForItem(at: location) as NSIndexPath? {
            //do whatever you need to do
            print("Index Number: \(indexPath.row)")
            print("IN RECOGNIZER: \(userLists[indexPath.row]): \(userListIds[indexPath.row])")
            //TODO: Remove a tile
            //Prompt for confirmation
            //If yes
                //Save listId
                //Remove element from userLists and userListIds
                //Remove element from collection view
                //Remove list from database
                //Remove all items from database where listId == this listId
            //If no
                //cancel
        }

    }
    
    @IBAction func newListBtnPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Constants.segues.wishListToNewList, sender: self)
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
        collectionView.deselectItem(at: indexPath, animated: true)
        print(userLists[indexPath.row])
        performSegue(withIdentifier: Constants.segues.wishListToItemList, sender: indexPath)
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
        guard let itemTableVC = segue.destination as? ItemTableVC else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        
        // use section property embedded in indexPath to pull wishlist items
        itemTableVC.listId = userListIds[indexPath.row]
        itemTableVC.currentUser = currentUser
        itemTableVC.owner = owner
    }
}
