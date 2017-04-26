//
//  LoginViewController.swift
//  Login
//
//  Created by Jack Le on 3/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import UIKit
import FlatUIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var lblUserID: UILabel!
    @IBOutlet weak var btnLogin: FUIButton!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var userID: FUITextField!
    @IBOutlet weak var password: FUITextField!
    @IBOutlet weak var createAccount: FUIButton!
    override var nibName: String?
    {
        get
        {
            return "LoginViewController";
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userID.delegate=self
        password.delegate=self
        
        let buttonThemer:ButtonThemer = ButtonThemer()
        buttonThemer.applyTheme(view: btnLogin, theme: ButtonTheme())
        buttonThemer.applyTheme(view: createAccount, theme: ButtonTheme())
        
        let textFieldThemer:TextFieldThemer = TextFieldThemer()
        textFieldThemer.applyTheme(view: userID, theme: TextFieldTheme())
        textFieldThemer.applyTheme(view: password, theme: TextFieldTheme())
        
        self.userID.text = "jack@gmail.com"
        self.password.text = "123456"
        
        self.title = "Login"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userID.resignFirstResponder()
        password.resignFirstResponder()
        return true
    }

    @IBAction func login(_ sender: Any) {
        userID.resignFirstResponder()
        password.resignFirstResponder()
        
        do {
            try FIRAuth.auth()?.signOut()
            
        } catch _ {
            
        }
        
        
        
//        let userId:String = ((FIRAuth.auth()?.currentUser)?.uid)!
//        if (!userId.isEmpty) {
//            self.performSegue(withIdentifier: "showTab", sender: nil)
//            return
//        }
        
        let login:LoginModel = LoginModel()
        
        if !login.isUserOrPasswordEmpty(userID: userID.text, password: password.text) {
            showSpinner(view: self.view)
            
            FIRAuth.auth()?.signIn(withEmail: userID.text!, password: password.text!, completion: { (user, error) in
                
                self.hideSpinner()
                
                if let error = error {
                    self.alert(content: error.localizedDescription)
                    return
                }
                else {
                    self.alert(content: AppMessage.LoginSuccess.rawValue, onCancel: {
                        action -> Void in
        
                        self.performSegue(withIdentifier: "showTab", sender: nil)
                    })
                }
            })
        } else {
            self.alert(content: AppMessage.UserOrPasswordEmpty.rawValue)
        }
        
    }
    
    
    @IBAction func createAccountClick(_ sender: Any) {
      loginSession() 
    }
    
    func loginSession() {
        
        self.performSegue(withIdentifier: "showCreate", sender: nil)
        
    }

}
