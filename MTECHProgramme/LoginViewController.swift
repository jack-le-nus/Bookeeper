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
import GoogleSignIn

class LoginViewController: UIViewController, UITextFieldDelegate,GIDSignInUIDelegate, GIDSignInDelegate{
    @IBOutlet weak var lblUserID: UILabel!
    @IBOutlet weak var lblSignup: UILabel!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var btnLogin: FUIButton!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var userID: FUITextField!
    @IBOutlet weak var password: FUITextField!
    @IBOutlet weak var createAccount: FUIButton!
    @IBOutlet weak var google_signIn: GIDSignInButton!
    
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
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
       // GIDSignIn.sharedInstance().signIn()
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().delegate = self
        userID.delegate=self
        password.delegate=self
        google_signIn.style = .wide
        
        self.applyTheme()
        
        let buttonThemer:ButtonThemer = ButtonThemer()
        let buttonTheme: ButtonTheme = ButtonTheme()
        buttonThemer.applyTheme(view: btnLogin, theme: buttonTheme)
        buttonThemer.applyTheme(view: createAccount, theme: buttonTheme)
        
        let textFieldThemer:TextFieldThemer = TextFieldThemer()
        let textFieldTheme: TextFieldTheme = TextFieldTheme()
        textFieldThemer.applyTheme(view: userID, theme: textFieldTheme)
        textFieldThemer.applyTheme(view: password, theme: textFieldTheme)
        
        let labelThemer:LabelThemer = LabelThemer()
        let labelTheme: LabelTheme = LabelTheme()
        //  labelThemer.applyTheme(view: lblForgotPassword, theme: labelTheme)
        labelThemer.applyTheme(view: lblSignup, theme: labelTheme)
        
        self.title = "Login"
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            print(error.localizedDescription)
            
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                          accessToken: authentication.accessToken)
        FIRAuth.auth()?.signIn(with: credential, completion: {(user,error) in
            if error != nil{
                print (error?.localizedDescription)
                return
            }
            else {
                self.alert(content: AppMessage.LoginSuccess.rawValue, onCancel: {
                    action -> Void in
                    
                    self.performSegue(withIdentifier: "showTab", sender: nil)
                })
            }
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        if let error = error{
            print(error.localizedDescription)
            return
        }
        try! FIRAuth.auth()!.signOut()
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
    
    override func viewDidAppear(_ animated: Bool) {
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if let user = user {
                print("User is signed in.")
            } else {
                print("User is signed out.")
            }
        }
    }
    
    @IBAction func forgotPassword(_ sender: Any){
        print("password forgot clicked")
        let alert = UIAlertController(title: "Reset Password",message: "",preferredStyle: .alert)
        
        alert.addTextField { (emailTextField: UITextField) in
            emailTextField.keyboardAppearance = .dark
            emailTextField.keyboardType = .default
            emailTextField.autocorrectionType = .default
            emailTextField.placeholder = "Enter Your Email"
            emailTextField.clearButtonMode = .whileEditing
        }
        
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
            // Get 1st TextField's text
            let textField = alert.textFields![0]
            print(textField.text!)
            FIRAuth.auth()?.sendPasswordReset(withEmail: textField.text!) { (error) in
                // ...
                if let error = error {
                    self.alert(content: error.localizedDescription)
                }else {
                    self.alert(content: AppMessage.PasswordResetSuccess.rawValue)
                }
                print("password reset mail sent Successfuly")
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
}
