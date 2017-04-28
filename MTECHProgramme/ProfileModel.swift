//
//  ProfileModel.swift
//  MTECHProgramme
//
//  Created by Medha Sharma on 4/20/17.
//
//

import Foundation
import Firebase

class ProfileModel
{
    var ref: FIRDatabaseReference!
    //to validate user phone number
    func isValidNumber(number: String) -> Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: number, options: [], range: NSMakeRange(0, number.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == number.characters.count
            }
            else {
                return false
            }
        }
        catch {
            return false
        }
    }
    
    //to validate user email id
    func isValidEmail(eMail: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: eMail, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, eMail.characters.count)) != nil
        }
        catch {
            return false
        }
    }
    
    //to validate password
    
    func isPasswordUpdated(password: String, confirmPassword: String) -> String {
        if(confirmPassword.isEmpty)
        {
            return "Empty"
        }
        if(!(password==confirmPassword))
        {
            return "Do not match"
        }
        return "None"
    }
    
    func isUserEmailIdAlreadyExist(userEmailId : String) -> Bool
    {
        var isExists = false
        ref = FIRDatabase.database().reference()
        ref.child("User").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(userEmailId)
            {
                isExists = true
            }
        })
        return isExists
    }
    
    //to validate user name
    func isValidName(name: String) -> Bool
    {
        let letters = NSCharacterSet.letters
        let range = name.rangeOfCharacter(from: letters, options: .caseInsensitive)
        // range will be nil if no letters is found
        if range != nil {
            return true
        }
        else {
            return false
        }
    }
}
