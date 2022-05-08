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

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
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
        UIApplication.shared.openURL(NSURL(string: self.linkURL!)! as URL)
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
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    self.nameLabel.text = document.data()?["name"] as? String
                    self.categoryLabel.text = document.data()?["category"] as? String
                    self.priceLabel.text = document.data()?["price"] as? String
                    self.linkURL = document.data()?["link"] as? String
                    self.locationLabel.text = document.data()?["location"] as? String
                }
                else {
                    print("Document does not exist")
                    return
                }
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
