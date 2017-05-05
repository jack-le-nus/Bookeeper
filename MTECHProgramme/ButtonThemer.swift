//
//  ButtonThemer.swift
//  MTECHProgramme
//
//  Created by Jack Le on 11/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import Foundation
import FlatUIKit

class ButtonThemer : Themer<FUIButton, ButtonTheme> {
    override func applyTheme(view: FUIButton, theme: ButtonTheme) {
        super.applyTheme(view: view, theme: theme)
        view.buttonColor = theme.buttonColor
        view.titleLabel?.font = theme.boldFont
        view.setTitleColor(theme.titleColor, for:UIControlState.normal)
    }
}

