//
//  TextFieldThemer.swift
//  MTECHProgramme
//
//  Created by Jack Le on 11/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import Foundation
import FlatUIKit

class TextFieldThemer : Themer<FUITextField, TextFieldTheme> {
    override func applyTheme(view: FUITextField, theme: TextFieldTheme) {
        super.applyTheme(view: view, theme: theme)
        view.font = theme.lightFont
        view.backgroundColor = theme.backgroundColor
        view.edgeInsets = theme.edgeInsets
        view.textColor = theme.textColor
        view.textFieldColor = theme.textFieldColor
        view.borderColor = theme.borderColor
        view.borderWidth = theme.borderWidth
        view.cornerRadius = theme.cornerRadius
        
    }
}
