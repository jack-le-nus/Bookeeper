//
//  BookCell.swift
//  MTECHProgramme
//
//  Created by Jack Le on 14/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import UIKit

class BookCell: UICollectionViewCell {
    
    var imageView:UIImageView = UIImageView()
    
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var imgBook: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
