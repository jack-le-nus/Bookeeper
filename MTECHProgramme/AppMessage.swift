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
    
    case name = "name"
    case author = "author"
    case categary = "categary"
    case userId = "userId"
    case description = "description"
    case id = "id"
    case isAvailable = "isAvailable"
    case isFeatured = "isFeatured"
    case imageUrl = "imageUrl"
    case booksaved = "New Book is saved"
    case bookname = "bookname"
    case borrowerUid = "borrowerUid"
    case checkoutSuccessful = "This book has been checked out to you succesfully"
    static let categories = ["Arts & Photography","Biographies & Memoirs","Business & Money","Calendars","Children's Books","Christian Books & Bibles","Computers and Technology","Cookbooks","Crafts, Hobbies & Home","Education & Teaching"]
    case SignOutSuccess = "Signout Successfully"
   
}
