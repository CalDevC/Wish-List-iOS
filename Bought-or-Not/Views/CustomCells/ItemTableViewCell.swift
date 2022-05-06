//
//  WishlistTableViewCell.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 3/25/22.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var wishlistCell: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
