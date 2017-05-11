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
    
    @IBOutlet weak var btnSearch: FUIButton!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: FUITextField!
    @IBOutlet weak var userEmailId: FUITextField!
    @IBOutlet weak var userContactNumber: FUITextField!
    @IBOutlet weak var address: FUITextField!
    
    @IBOutlet weak var btnUpdate: FUIButton!
    var addressData: String = ""
    var imagePicker = UIImagePickerController()
    var signedUser = ""
    var ref: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    var storage: FIRStorage!
    var data = NSData()
    var currentUser = (FIRAuth.auth()?.currentUser?.uid)!
    
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
        self.title = "Profile"
        ref = FIRDatabase.database().reference()
        storageRef = FIRStorage.storage().reference()
        storage = FIRStorage()
        self.showSpinner(view: self.view)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        userImage.isUserInteractionEnabled = true
        userImage.addGestureRecognizer(tapGestureRecognizer)
        
        userName.resignFirstResponder()
        userEmailId.resignFirstResponder()
        userContactNumber.resignFirstResponder()
        address.resignFirstResponder()
        
        userEmailId.isUserInteractionEnabled = false
        
        userName.delegate=self
        userEmailId.delegate=self
        userContactNumber.delegate=self
        address.delegate=self
        
        let textFieldThemer:TextFieldThemer = TextFieldThemer()
        textFieldThemer.applyTheme(view: userName, theme: TextFieldTheme())
        textFieldThemer.applyTheme(view: userEmailId, theme: TextFieldTheme())
        textFieldThemer.applyTheme(view: userContactNumber, theme: TextFieldTheme())
        textFieldThemer.applyTheme(view: address, theme: TextFieldTheme())
        
        let buttonThemer:ButtonThemer = ButtonThemer()
        buttonThemer.applyTheme(view: btnUpdate, theme: ButtonTheme())
        buttonThemer.applyTheme(view: btnSearch, theme: ButtonTheme())
        
        let userRef = ref.child("User").child(currentUser)
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            
            let values =  snapshot.value as? [String:AnyObject] ?? [:]
            
            if snapshot.hasChild("imageUrl")
            {
                let url = values["imageUrl"] as? String ?? ""
                FIRStorage.storage().reference(forURL: url).data(withMaxSize: 10 * 1024 * 1024, completion: { (data, error) in
                    DispatchQueue.main.async() { Void in
                        let image = UIImage(data: data!)
                        self.userImage.image = image!
                    }
                })
            }
            
            self.userName.text = values["name"] as? String ?? ""
            self.userEmailId.text = FIRAuth.auth()?.currentUser?.email ?? ""
            self.address.text = values["address"] as? String ?? ""
            self.userContactNumber.text  = values["phone"] as? String ?? ""
            
            self.hideSpinner()
        })
    }
    
    @IBAction func onUpdateClick(_ sender: Any)
    {
        let profileModel:ProfileModel = ProfileModel()
        
        if !validateTextField() {
            return
        }
        
        if(!profileModel.isValidName(name: userName.text!)) {
            userName.text = nil
            userName.attributedPlaceholder = NSAttributedString(string:"Name should be valid",attributes: [NSForegroundColorAttributeName: UIColor.red])
            return
        }
        
        if !profileModel.isValidNumber(number: userContactNumber.text!) {
            userContactNumber.text = nil
            userContactNumber.attributedPlaceholder = NSAttributedString(string:"Contact no should be valid",attributes: [NSForegroundColorAttributeName: UIColor.red])
            return
            
        }
        
        if(userImage.image == nil) {
            self.alert(content: "Your image is required")
            return
        }
        self.showSpinner(view: self.view)
        
        data = UIImageJPEGRepresentation(userImage.image!, 0.8)! as NSData
        // set upload path
        let filePath = "user_image/" + "\(currentUser)/\("userPhoto")"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpeg"
        
        self.storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print("error uploading : \(error.localizedDescription)")
                return
            }else{
                let downloadURL = self.storageRef!.child((metaData?.path)!).description
                //store downloadURL at database
                self.ref.child("User").child(self.currentUser).updateChildValues(["imageUrl": downloadURL])
            }
        }
        
        //Save Values to database and return to home page
        self.ref.child("User").child(currentUser).child("name").setValue(userName.text!)
        self.ref.child("User").child(currentUser).child("email").setValue(userEmailId.text!)
        self.ref.child("User").child(currentUser).child("phone").setValue(userContactNumber.text!)
        self.ref.child("User").child(currentUser).child("address").setValue(address.text!)
        
        let alert:UIAlertController=UIAlertController(title: "You updated profile successfully", message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) {
            UIAlertAction in
            _ = self.navigationController?.popViewController(animated: true)
            self.hideSpinner()
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName.resignFirstResponder()
        userEmailId.resignFirstResponder()
        userContactNumber.resignFirstResponder()
        address.resignFirstResponder()
        return true
    }
    
    //Open map to search places
    @IBAction func seachAPlace(_ sender: UIButton) {
        self.performSegue(withIdentifier: "showAddressView", sender: nil)
    }
    
    //Changes profile picture of user
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default) {
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
            self.present(imagePicker, animated: true, completion: nil)
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
        var valid = true
        if ((userName.text?.isEmpty))! {
            userName.text = nil
            userName.attributedPlaceholder = NSAttributedString(string:"Name is required",attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
            
        }
        if ((userContactNumber.text?.isEmpty))!{
            userContactNumber.text = nil
            userContactNumber.attributedPlaceholder = NSAttributedString(string:"Contact no is required",attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        if ((address.text?.isEmpty))!{
            address.text = nil
            address.attributedPlaceholder = NSAttributedString(string:"Address is required",attributes: [NSForegroundColorAttributeName: UIColor.red])
            valid = false
        }
        return valid
    }
}
