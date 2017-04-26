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

class CreateAccountViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var createView: UIView!
    @IBOutlet weak var nameText: FUITextField!
    @IBOutlet weak var confirmPasswordText: FUITextField!
    @IBOutlet weak var passwordText: FUITextField!
    @IBOutlet weak var emailText: FUITextField!
    @IBOutlet weak var createButton: FUIButton!
    var ref: FIRDatabaseReference!
    var remoteConfig: FIRRemoteConfig!
    fileprivate var _refHandle: FIRDatabaseHandle!
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    
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
        createView.backgroundColor = UIColor(fromHexCode: "#ECF3F4")
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
        let password: String = passwordText.text!
        let confirmedPassword = confirmPasswordText.text
        
        if password != confirmedPassword {
           self.alert(content: AppMessage.PasswordNotMatched.rawValue)
        }
        FIRAuth.auth()?.createUser(withEmail: emailText.text!, password: passwordText.text!, completion: { (user, error) in
            
            self.hideSpinner()
            
            if let error = error {
                self.alert(content: error.localizedDescription)
                return
            }
            else {
                self.alert(content: AppMessage.LoginSuccess.rawValue, onCancel: {
                    action -> Void in
                    self.saveData()
                    self.performSegue(withIdentifier: "showBookFromSignUp", sender: nil)
                })
            }
        })
        
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
    }
    
    func saveData() {
        var newKey: String = ""
        let data = [Constants.UserTableField.name : nameText.text! as String,Constants.UserTableField.email: emailText.text! as String]
        let query = ref.child("User").queryOrderedByKey().queryLimited(toLast: 1)
        query.observeSingleEvent(of: .value, with: { snapshot in
            for task in snapshot.children {
                guard let taskSnapshot = task as? FIRDataSnapshot else {
                    continue
                }
                print("Last key in firebase: "+taskSnapshot.key)
                newKey = String(Int(taskSnapshot.key)! + 1)
               self.ref.child("User").child(newKey).setValue(data)
            }
        })
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameText.resignFirstResponder()
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
        confirmPasswordText.resignFirstResponder()
        return true
    }
}
