//
//  ProfileViewController.swift
//  MTECHProgramme
//
//  Created by Medha Sharma on 4/20/17.
//
//

import UIKit
import FlatUIKit
import Firebase


class ProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, ReturnAddressDelegate
{
    internal func returnAddressOnMap(data: String) {
        address.text! = data
    }

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userEmailId: FUITextField!
    @IBOutlet weak var userName: FUITextField!
    @IBOutlet weak var userContactNumber: FUITextField!
    @IBOutlet weak var address: UITextView!
    
    var addressData: String = ""
    var imagePicker = UIImagePickerController()
    
    override var nibName: String? {
        get {
            return "ProfileViewController";
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyTheme()
        MapAddressController.delegate = self
        
//        self.navigationItem.hidesBackButton = true
//        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ProfileViewController.back(sender:)))
//        self.navigationItem.leftBarButtonItem = newBackButton
        
        userName.resignFirstResponder()
        userEmailId.resignFirstResponder()
        userContactNumber.resignFirstResponder()
        address.resignFirstResponder()
        
        userName.delegate=self
        userEmailId.delegate=self
        userContactNumber.delegate=self
        address.delegate=self
        
//        let textFieldThemer:TextFieldThemer = TextFieldThemer()
//        textFieldThemer.applyTheme(view: userName, theme: TextFieldTheme())
//        textFieldThemer.applyTheme(view: userEmailId, theme: TextFieldTheme())
//        textFieldThemer.applyTheme(view: userContactNumber, theme: TextFieldTheme())
//        textFieldThemer.applyTheme(view: userAddress, theme: TextFieldTheme())
        
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor.green.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.layer.masksToBounds = false
        userImage.clipsToBounds = true
        if (self.isMovingFromParentViewController)
        {
            alert(content: "Do you want to exit?")
        }
    }
    
    
    override func viewWillDisappear(_ animated : Bool)
    {
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        userEmailId.resignFirstResponder()
        userContactNumber.resignFirstResponder()
        address.resignFirstResponder()
        return true
    }
    
    //Saving the user profile data
    @IBAction func onSaveClick(_ sender: Any) {
        let profileModel:ProfileModel = ProfileModel()
        
        if !validateTextField() {
            return
        }
        
        if !profileModel.isValidEmail(eMail: userEmailId.text!) {
            userEmailId.text = nil
            userEmailId.attributedPlaceholder = NSAttributedString(string:"Please enter valid Email ID",attributes: [NSForegroundColorAttributeName: UIColor.red])
            return
        }
        
        if !profileModel.isValidNumber(number: userContactNumber.text!) {
            userContactNumber.text = nil
            userContactNumber.attributedPlaceholder = NSAttributedString(string:"Please enter Valid Phone no",attributes: [NSForegroundColorAttributeName: UIColor.red])
            return
        }
        
        //Save Values to database and return to home page
    }
    
    //Open map to search places
    @IBAction func seachAPlace(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showAddressView", sender: nil)
    }
    
    //Changes profile picture of user
    @IBAction func changeProfilePic(_ sender: Any) {
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
        }
        
        // Add the actions
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)){
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
        }
        else{
            self.alert(content: "You don't have camera", onCancel: {
                action -> Void in
            })
        }
    }
    
    func openGallary(){
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //save image
            //display image
            userImage.image = image
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    //Null Check validations for the fields
    func validateTextField() -> Bool
    {
        
        var valid: Bool = true
        if ((userName.text?.isEmpty))! {
            // change placeholder color to red color for textfield user name
            userName.attributedPlaceholder = NSAttributedString(string: "Please enter User Name", attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        if ((userEmailId.text?.isEmpty))!{
            userEmailId.attributedPlaceholder = NSAttributedString(string:"Please enter Your Email ID",attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        if ((userContactNumber.text?.isEmpty))!{
            userContactNumber.attributedPlaceholder = NSAttributedString(string:"Please enter Contact Number",attributes: [NSForegroundColorAttributeName:UIColor.red])
            valid = false
        }
        if ((address.text?.isEmpty))!{
             address.attributedText = NSAttributedString(string: "Please enter Address",attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        return valid
    }
}
