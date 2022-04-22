//
//  FriendsVC.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 4/21/22.
//

import UIKit
import Firebase

class FriendsVC: UIViewController{
    
    let db = Firestore.firestore()
    var friendList: [User] = []
    var userList: [String: User] = [:]
    let reuseIdentifier = "cell"
    var matchingData: [User] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        friendList = []
        userList = [:]
        //Get search data
        fetchAllUsers()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        collectionView.isHidden = true
        searchBar.isHidden = true
        activityIndicator.startAnimating()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        layoutCells()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let nib = UINib(nibName: "FriendCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
    }
    
    func fetchFriends(forUID: String){
        let userDataDocRef = db.collection("users").document(forUID)
        userDataDocRef.getDocument { (doc, error) in
            if let err = error{
                //TODO: Notify user of error
                print(err)
            }

            if let document = doc, document.exists {

                let docData: [String: Any] = document.data() ?? ["nil": "nil"]

                guard let friendUIDList: [String] = docData["friends"] as? [String] else{
                    return
                }

                //For each friend
                for friendUID in friendUIDList{
                    if let friend = self.userList[friendUID]{
                        self.friendList.append(friend)
                    }
                }
                self.renderUI()
                self.collectionView.reloadData()
            }
        }
    }
    
    func fetchAllUsers(){
        db.collection("users").getDocuments() {(querySnapshot, err) in
            if let err = err {
                print("Error getting all users: \(err)")
            } else {
                //Save data
                for user in querySnapshot!.documents{
                    if(user.documentID != "takenUsernames"){
                        let userData: [String: Any] = user.data()
                        
                        let user = User(
                            uid: userData["uid"] as! String,
                            fullName: userData["fullName"] as! String,
                            username: userData["username"] as! String
                        )
                        
                        self.userList[user.uid] = user
                    }
                }
                
                //Populate friends list after all users are added
                guard let currentUID = Auth.auth().currentUser?.uid else{
                    return
                }
                self.fetchFriends(forUID: currentUID)
            }
        }
    }
    
    func renderUI(){
        //Do redering
        print("Rendering")
        collectionView.isHidden = false
        searchBar.isHidden = false
        activityIndicator.stopAnimating()
    }
    
//    func addFriend(friendUID: String){
//        let userDataDocRef = self.db.collection("users").document(friendUID)
//        userDataDocRef.getDocument { (doc, error) in
//            if let err = error{
//                //TODO: Notify user of error
//                print(err)
//            }
//
//            if let document = doc, document.exists {
//                //Add friend with details
//                let friendData: [String: Any] = document.data() ?? ["nil": "nil"]
//
//                let friend = User(
//                    uid: friendData["uid"] as! String,
//                    fullName: friendData["fullName"] as! String,
//                    username: friendData["username"] as! String
//                )
//
//                print("FRIEND: \(friend.username)")
//
//                self.friendList.append(friend)
//                self.collectionView.reloadData()
//            }
//        }
//    }
    

    
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
        cell.textLabel?.text = matchingData[indexPath.row].username
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.endEditing(true)
        performSegue(withIdentifier: Constants.segues.friendToProfile, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        guard let profileVC = segue.destination as? ProfileVC else {
            return
        }
        guard let indexPath = sender as? IndexPath else {
            return
        }
        
        profileVC.user = matchingData[indexPath.row]
    }
    
}

//MARK: - Search Bar Functions
extension FriendsVC: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if(searchBar.text != ""){
            tableView.isHidden = false
        }
        
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
            tableView.isHidden = true
        } else{
            tableView.isHidden = false
        }
        
        for user in userList{
            let username = user.value.username
            if(username.lowercased().contains(searchText.lowercased())){
                matchingData.append(user.value)
            }
        }
        
        if(matchingData.count == 0){
            matchingData.append(User(uid: "0", fullName: "No Results", username:"No Results"))
        }
        
        self.tableView.reloadData()
    }
}
