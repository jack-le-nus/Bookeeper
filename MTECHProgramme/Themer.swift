//
//  Themer.swift
//  MTECHProgramme
//
//  Created by Jack Le on 11/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import Foundation
import UIKit
import FlatUIKit

class Themer<TControl : UIView, TTheme: Theme> {
    private var strategy: Theme
    
    open func applyTheme(view: TControl, theme: TTheme) {
        let frame : CGRect = CGRect(x: view.frame.minX, y: view.frame.minY, width: view.frame.width, height: theme.controlHeight)
        
        view.frame = frame
    }
    
    init() {
        strategy = Theme()
    }
}
