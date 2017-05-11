//
//  CreateAccountViewController.swift
//  MTECHProgramme
//
//  Created by Siddharth Deshmukh on 4/24/17.
//
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FlatUIKit

class CreateAccountViewController: UIViewController,UITextFieldDelegate, UINavigationControllerDelegate {

    @IBOutlet var createView: UIView!
    @IBOutlet weak var nameText: FUITextField!
    @IBOutlet weak var confirmPasswordText: FUITextField!
    @IBOutlet weak var passwordText: FUITextField!
    @IBOutlet weak var emailText: FUITextField!
    @IBOutlet weak var createButton: FUIButton!
    
    @IBOutlet weak var signInBtn: FUIButton!
    var ref: FIRDatabaseReference!
    var remoteConfig: FIRRemoteConfig!
    fileprivate var _refHandle: FIRDatabaseHandle!
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
   
    @IBOutlet weak var contactText: FUITextField!
    
    
    override var nibName: String?
        {
        get
        {
            
            return "CreateAccountViewController";
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameText.delegate = self
        emailText.delegate = self
        passwordText.delegate = self
        confirmPasswordText.delegate = self
        let buttonThemer:ButtonThemer = ButtonThemer()
        buttonThemer.applyTheme(view: createButton, theme: ButtonTheme())
        let textFieldThemer:TextFieldThemer = TextFieldThemer()
        textFieldThemer.applyTheme(view: nameText, theme: TextFieldTheme())
        textFieldThemer.applyTheme(view: emailText, theme: TextFieldTheme())
        textFieldThemer.applyTheme(view: passwordText, theme: TextFieldTheme())
        textFieldThemer.applyTheme(view: confirmPasswordText, theme: TextFieldTheme())
        textFieldThemer.applyTheme(view: contactText, theme: TextFieldTheme())
        self.applyTheme()
        self.title = "Create Account"
        configureDatabase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func CreateAccountAction(_ sender: Any) {
        
        if validateData() {
            let password: String = passwordText.text!
            let confirmedPassword = confirmPasswordText.text
            
            if password != confirmedPassword {
                passwordText.attributedPlaceholder = NSAttributedString(string:AppMessage.PasswordNotMatched.rawValue,attributes: [NSForegroundColorAttributeName: UIColor.red])
                return
            }
            if validateName() {
            self.showSpinner(view: self.view)
            FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
            
                 self.hideSpinner()
            
            if let error = error {
                self.alert(content: error.localizedDescription)
                return
            }
            else {
                self.alert(content: AppMessage.SignUpSuccess.rawValue, onCancel: {
                    action -> Void in
                    self.saveData()
                    self.performSegue(withIdentifier: "showBookFromSignUp", sender: nil)
                })
            }
        })
            } else {
                nameText.attributedPlaceholder = NSAttributedString(string:AppMessage.InvalidName.rawValue,attributes: [NSForegroundColorAttributeName: UIColor.red])
            }
        }
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
    }
    
    func saveData() {
        //var newKey: String = ""
        let userID = FIRAuth.auth()?.currentUser?.uid
        let data = [Constants.UserTableField.name : nameText.text! as String,Constants.UserTableField.email: emailText.text! as String, Constants.UserTableField.phone:contactText.text! as String]
        self.ref.child("User").child(userID!).setValue(data)

        
    }

    func validateData() -> Bool{
        
        var valid = true
        if (nameText.text?.isEmpty)! {
            nameText.attributedPlaceholder = NSAttributedString(string:AppMessage.NameEmpty.rawValue,attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        if (emailText.text?.isEmpty)! {
            emailText.attributedPlaceholder = NSAttributedString(string:AppMessage.EmailEmpty.rawValue,attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        if (passwordText.text?.isEmpty)! {
            passwordText.attributedPlaceholder = NSAttributedString(string:AppMessage.PasswordEmpty.rawValue,attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        if (confirmPasswordText.text?.isEmpty)! {
            confirmPasswordText.attributedPlaceholder = NSAttributedString(string:AppMessage.ConfirmPasswordEmpty.rawValue,attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        if (contactText.text?.isEmpty)! {
            contactText.attributedPlaceholder = NSAttributedString(string:AppMessage.ContactNoEmpty.rawValue,attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        
        return valid
    }
    
    func validateName() ->Bool {
        let name :String = nameText.text!
        let letters = NSCharacterSet.letters
        
        //let phrase = "Test case"
        let range = name.rangeOfCharacter(from: letters, options: .caseInsensitive)
        
        // range will be nil if no letters is found
        if range != nil {
            return true
        }
        else {
            return false
        }
        return true;
    }
    
    @IBAction func signInAction(_ sender: Any) {
    navigationController?.popToRootViewController(animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameText.resignFirstResponder()
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        confirmPasswordText.resignFirstResponder()
        return true
    }
    
   
}
