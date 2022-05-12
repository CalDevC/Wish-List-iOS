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
    var item: Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = item.name
        categoryLabel.text = item.category
        priceLabel.text = item.price
        
        getImage(compHandler: reloadItems)
    }
    
    @IBAction func linkButton(_ sender: Any) {
        // UIApplication.shared.openURL(NSURL(string: self.linkURL!)! as URL)
        UIApplication.shared.open(URL(string: self.item.link)!, options: [:], completionHandler: nil)
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
    
    func getImage(compHandler: @escaping()->Void){
        if(item.image == ""){
            self.itemDetailImageView.image = UIImage(systemName: "photo")
        } else{
            let imageRef = Storage.storage().reference().child(item.image)
            
            imageRef.getData(maxSize: 1 * 100024 * 100024) { data, error in
              if let error = error {
                print(error)
                  Util.launchAlert(
                    senderVC: self,
                    title: "Internal Error",
                    message: "Could not load image 🙁, please try again later",
                    btnText: "Ok"
                  )
              } else {
                // Data for "images/island.jpg" is returned
                let itemImage = UIImage(data: data!)
                self.itemDetailImageView.image = itemImage
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
