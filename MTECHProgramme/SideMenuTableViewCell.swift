//
//  SideMenuTableViewCell.swift
//  MTECHProgramme
//
//  Created by Medha Sharma on 4/21/17.
//
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {


    
    @IBOutlet weak var menu: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
