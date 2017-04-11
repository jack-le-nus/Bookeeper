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

class Themer<TControl : UIControl, TTheme: Theme> {
    private var strategy: Theme
    
    open func applyTheme(view: TControl, theme: TTheme) {

    }
    
    init() {
        strategy = Theme()
    }
}
