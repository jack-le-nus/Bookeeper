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
    
    var category: String = ""
    var author: String = ""
    var bookDescription: String = ""
    var images: [String]! = []
    var bookId: String = ""
    var borrowerUid: String = ""
    var userUid: String = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
