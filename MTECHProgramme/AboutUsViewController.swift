//
//  AboutUsViewController.swift
//  MTECHProgramme
//
//  Created by Medha Sharma on 5/2/17.
//
//

import UIKit

class AboutUsViewController: UIViewController
{
    override var nibName: String? {
        get {
            return "AboutUsViewController";
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.applyTheme()
        self.title = "About Us"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
