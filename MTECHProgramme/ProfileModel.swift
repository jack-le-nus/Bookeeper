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
    
    
    func isValidEmail(eMail: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: eMail, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, eMail.characters.count)) != nil
        }
        catch {
            return false
        }
    }
}
