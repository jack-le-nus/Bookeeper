//
//  LoginModel.swift
//  Login
//
//  Created by Jack Le on 3/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import Foundation
import Firebase

class LoginModel {
    func isUserOrPasswordEmpty(userID:String?, password:String?) ->Bool{
        return (userID ?? "").isEmpty || (password ?? "").isEmpty
    }
    
    func createUser(userID: String, password: String, onComplete: @escaping (NSError?)->Void){
        FIRAuth.auth()?.createUser(withEmail: userID, password: password, completion: { (user, error) in
            onComplete(error as? NSError)
            return
        })
    }
}
