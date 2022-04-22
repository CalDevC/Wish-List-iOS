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

class FriendsVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let db = Firestore.firestore()
    var friendList: [friend] = []
    var temp = ["hello", "there"]
    let reuseIdentifier = "cell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        guard let currentUID = Auth.auth().currentUser?.uid else{
            return
        }
        
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
                
                print("Friends: ")
                //For each friend
                for friend in tempFriendList{
                    self.addFriend(friendUID: friend)
                }
                print("Friend list has \(self.friendList.count) Elements")
                self.collectionView.reloadData()
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCells()
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "FriendCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        // Do any additional setup after loading the view.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("\(self.friendList.count) cells being called")
        return self.temp.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // get a reference to our storyboard cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! FriendCollectionViewCell
        
        // Use the outlet in our custom class to get a reference to the UILabel in the cell
        cell.myLabel.text = self.temp[indexPath.row] // The row value is the same as the index of the desired text within the array.
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item): \(temp[indexPath.row])")
    }
    
    func layoutCells() {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
            layout.minimumInteritemSpacing = 5.0
            layout.minimumLineSpacing = 5.0
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 40)/3, height: ((UIScreen.main.bounds.size.width - 40)/3))
            collectionView!.collectionViewLayout = layout
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
                print("In addfriend: \(self.friendList.count)")
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
