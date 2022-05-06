//
//  HomeCollectionViewCell.swift
//  Bought-or-Not
//
//  Created by Chase Alexander on 5/5/22.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    var cornerRadius: CGFloat = 10.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Apply rounded corners to contentView
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        
        // Set masks to bounds to false to avoid the shadow
        // from being clipped to the corner radius
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        // Apply a shadow
        layer.shadowRadius = 8.0
        
        //Dark Mode Shadow
        if(self.traitCollection.userInterfaceStyle == .dark){
            layer.shadowOpacity = 0.50
            layer.shadowColor = UIColor.gray.cgColor
        } else{  //Light Mode Shadow
            layer.shadowOpacity = 0.30
            layer.shadowColor = UIColor.black.cgColor
        }
        
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Improve scrolling performance with an explicit shadowPath
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
    }
    

}
