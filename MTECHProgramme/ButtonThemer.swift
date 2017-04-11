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
        view.buttonColor = theme.buttonColor
        view.shadowColor = theme.shadowColor
        view.shadowHeight = theme.shadowHeight
        view.cornerRadius = theme.cornerRadius
        view.titleLabel?.font = theme.font
        view.setTitleColor(theme.titleColor, for:UIControlState.normal);
        
    }
}

