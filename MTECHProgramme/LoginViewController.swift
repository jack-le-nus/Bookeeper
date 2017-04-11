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
    
    override var nibName: String?
    {
        get
        {
            return "LoginViewController";
        }
    }
    
    override required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userID.delegate=self
        password.delegate=self
        
        let buttonThemer:ButtonThemer = ButtonThemer()
        buttonThemer.applyTheme(view: btnLogin, theme: ButtonTheme())
        
        let textFieldThemer:TextFieldThemer = TextFieldThemer()
        textFieldThemer.applyTheme(view: userID, theme: TextFieldTheme())
        textFieldThemer.applyTheme(view: password, theme: TextFieldTheme())
        
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
        
        let login:LoginModel = LoginModel()
        
        if !login.isUserOrPasswordEmpty(userID: userID.text, password: password.text) {
            showSpinner(view: self.view)
            
            FIRAuth.auth()?.createUser(withEmail: userID.text!, password: password.text!, completion: { (user, error) in
                
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

}
