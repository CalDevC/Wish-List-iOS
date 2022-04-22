//
//  FriendsVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 4/21/22.
//

import UIKit
import Firebase

struct friend{
    let uid: String
    let fullName: String
    let username: String
}


class FriendsVC: UIViewController{
    
    let db = Firestore.firestore()
    var friendList: [friend] = []
    let reuseIdentifier = "cell"
    let dataToSearch = ["Hello", "these", "are", "words", "for", "searching"]
    var matchingData: [String] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewWillAppear(_ animated: Bool) {
        guard let currentUID = Auth.auth().currentUser?.uid else{
            return
        }
        
        friendList = []
        
        //Populate friends list
        let userDataDocRef = db.collection("users").document(currentUID)
        userDataDocRef.getDocument { (doc, error) in
            if let err = error{
                //TODO: Notify user of error
                print(err)
            }
            
            if let document = doc, document.exists {
                
                let docData: [String: Any] = document.data() ?? ["nil": "nil"]
                
                guard let tempFriendList: [String] = docData["friends"] as? [String] else{
                    return
                }
                
                //For each friend
                for friend in tempFriendList{
                    self.addFriend(friendUID: friend)
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchingData = dataToSearch
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        layoutCells()
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "FriendCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    func addFriend(friendUID: String){
        let userDataDocRef = self.db.collection("users").document(friendUID)
        userDataDocRef.getDocument { (doc, error) in
            if let err = error{
                //TODO: Notify user of error
                print(err)
            }
            
            if let document = doc, document.exists {
                //Add friend with details
                let friendData: [String: Any] = document.data() ?? ["nil": "nil"]
                
                let friend = friend(
                    uid: friendData["uid"] as! String,
                    fullName: friendData["fullName"] as! String,
                    username: friendData["username"] as! String
                )
                
                print("FRIEND: \(friend.username)")
                
                self.friendList.append(friend)
                self.collectionView.reloadData()
            }
        }
    }
    

    
}

//MARK: - Collection View Functions
extension FriendsVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friendList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FriendCollectionViewCell
        
        cell.label.text = self.friendList[indexPath.row].username
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item): \(friendList[indexPath.row].username)")
    }
    
    func layoutCells() {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
            layout.minimumInteritemSpacing = 5.0
            layout.minimumLineSpacing = 5.0
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40)/3, height: ((UIScreen.main.bounds.size.width - 40)/3))
            collectionView!.collectionViewLayout = layout
    }
}

//MARK: - Table View Functions
extension FriendsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)
        
        //will be depricated
        cell.textLabel?.text = matchingData[indexPath.row]
        return cell
    }
    
}

//MARK: - Search Bar Functions
extension FriendsVC: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        tableView.isHidden = false
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        tableView.isHidden = true
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        matchingData = []
        
        if(searchText == ""){
            matchingData = dataToSearch
        }
        
        for username in dataToSearch{
            if(username.lowercased().contains(searchText.lowercased())){
                matchingData.append(username)
            }
        }
        
        self.tableView.reloadData()
    }
}
