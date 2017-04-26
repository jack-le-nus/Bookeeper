//
//  AppMessage.swift
//  MTECHProgramme
//
//  Created by Jack Le on 11/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import Foundation

enum AppMessage: String {
    case UserOrPasswordEmpty = "Email/password can't be empty"
    case LoginSuccess = "Welcome to the application"
    case PasswordNotMatched = "Password and confirm password must be the same"
     case RequiredFieldNotFilled = "All required fields must be filled"
    case SignUpSuccess = "You created an account successfully"
     case InvalidName = "Name should be valid"
}
