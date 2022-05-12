//
//  ItemDetailVC.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 5/8/22.
//

import UIKit
import Firebase
import FirebaseStorage

class ItemDetailVC: UIViewController {

    let currentUid = Auth.auth().currentUser!.uid
    let db = Firestore.firestore()

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemDetailImageView: UIImageView!
    
    private var collectionRef: CollectionReference!
    var itemId: String?
    var itemName: String?
    var itemCategory: String?
    var linkURL: String?
    var docRef = Firestore.firestore().collection("item")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(itemId!)
        getData(compHandler: reloadItems)
    }
    
    @IBAction func linkButton(_ sender: Any) {
        // UIApplication.shared.openURL(NSURL(string: self.linkURL!)! as URL)
        UIApplication.shared.open(URL(string: self.linkURL!)!, options: [:], completionHandler: nil)
    }
    
    func reloadItems(){
        print("RELOAD")
        // activityIndicator.stopAnimating()
        // self.wishlistTableView.reloadData()
    }
    
    func linkTextView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
    
    func getData(compHandler: @escaping()->Void){
        if(itemId != nil) {
            docRef.document(itemId!).getDocument { (document, error) in
                if let document = document, document.exists {
                    print(document.data())
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    
                    self.navigationItem.title = document.data()?["name"] as? String
                    self.categoryLabel.text = document.data()?["category"] as? String
                    self.priceLabel.text = "$\(document.data()!["price"] as! String)"
                    self.linkURL = document.data()?["link"] as? String
                    let myImage = document.data()?["image"] as! String
                    
                    // let storage = Storage.storage()
                    let storageRef = Storage.storage().reference()
                    let imagePath = myImage
                    print("IMAGE PATH")
                    print(imagePath)
                    if(imagePath == ""){
                        self.itemDetailImageView.image = UIImage(systemName: "photo")
                    } else{
                        self.itemDetailImageView.isHidden = false
                        let imageRef = storageRef.child(imagePath)

                        // print(document.data()?["image"] as? String)
                        
                        imageRef.getData(maxSize: 1 * 100024 * 100024) { data, error in
                          if let error = error {
                            print("ERRORORORO")
                            print(error)
                            // Uh-oh, an error occurred!
                          } else {
                            // Data for "images/island.jpg" is returned
                            let itemImage = UIImage(data: data!)
                            self.itemDetailImageView.image = itemImage
                          }
                        }
                    }
                }
                else {
                    print("Document does not exist")
                    return
                }
            }
        }
    }

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
