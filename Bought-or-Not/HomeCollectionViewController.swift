//
//  HomeCollectionViewController.swift
//  Bought-or-Not
//
//  Created by Chris Huber on 3/20/22.
//

import UIKit

// private let reuseIdentifier = "Cell"

class HomeCollectionViewController: UICollectionViewController {
    
    // @IBOutlet var collectionView: UICollectionView!
    @IBAction func userSettingsPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "homeToUserSettings", sender: self)
    }
    
    let dataSource: [String] = ["New List", "My Birthday", "Christmas"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutCells()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        cell.backgroundColor = UIColor.orange
        
        if let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? HomeCollectionViewCell {
            listCell.configure(with: dataSource[indexPath.row])
            cell = listCell
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print(dataSource[indexPath.row])
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



    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource



    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

