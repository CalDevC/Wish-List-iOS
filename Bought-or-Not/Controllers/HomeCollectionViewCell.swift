//
//  HomeCollectionViewCell.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 3/20/22.
//

import UIKit

class HomeCollectionViewCell:
    UICollectionViewCell {
    
    @IBOutlet weak var listCellLabel: UILabel!
    
    func configure(with listName: String) {
        listCellLabel.text = listName
        self.listCellLabel.preferredMaxLayoutWidth = self.bounds.width - 5;
    }
}
