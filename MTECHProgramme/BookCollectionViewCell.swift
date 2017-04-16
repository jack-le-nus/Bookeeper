//
//  BookCollectionViewCell.swift
//  MTECHProgramme
//
//  Created by Jack Le on 14/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {

    var imageView:UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame:self.frame)
        self.contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
