//
//  ButtonThemer.swift
//  MTECHProgramme
//
//  Created by Jack Le on 11/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import Foundation
import UIKit

class LabelThemer : Themer<UILabel, LabelTheme> {
    override func applyTheme(view: UILabel, theme: LabelTheme) {
        super.applyTheme(view: view, theme: theme)
        view.textColor = theme.textColor
    }
}

