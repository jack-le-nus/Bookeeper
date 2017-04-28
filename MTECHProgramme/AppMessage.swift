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
    static let categories = ["abc", "bcd", "gft", "huj"]
}
