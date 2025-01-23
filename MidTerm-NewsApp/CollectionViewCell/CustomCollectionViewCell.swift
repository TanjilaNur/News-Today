//
//  CustomCollectionViewCell.swift
//  MidTerm-NewsApp
//
//  Created by BJIT on 16/1/23.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var categoryBGView: UIView!
    
    @IBOutlet weak var selectionView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        categoryLabel.backgroundColor = .systemBackground
    }
}
