//
//  ChatMessageViewController.swift
//  MTECHProgramme
//
//  Created by student on 2/5/17.
//
//

import UIKit
import Firebase
import FirebaseGoogleAuthUI
import GoogleSignIn
import Photos


class ChatMessageViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    // Instance Variable
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var imagebutton: UIButton!
    @IBOutlet weak var imageDisplay: UIImageView!
    @IBOutlet weak var backgroundBlur: UIVisualEffectView!
    @IBOutlet var dismissImageRecognizer: UITapGestureRecognizer!
    @IBOutlet var dismissKeyboardRecognizer: UITapGestureRecognizer!
    
    var ref: FIRDatabaseReference!
    var messages: [FIRDataSnapshot]! = []
    var msglength: NSNumber = 10
    fileprivate var _refHandle: FIRDatabaseHandle?
    
    var storageRef: FIRStorageReference!
    
    override var nibName: String?
    {
        get
        {
            return "ChatMessageViewController";
        }
    }
    @IBOutlet weak var clientTable: UITableView!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.clientTable.register(UITableViewCell.self, forCellReuseIdentifier: "tableViewCell")
        self.clientTable.dataSource = self
        self.clientTable.delegate = self
        
        configureDatabase()
        configureStorage()
        
    }
    
    deinit {
        if let refHandle =  _refHandle {
            self.ref.child("messages").removeObserver(withHandle: refHandle)
        }
    }
    
    func configureDatabase(){
        
        ref = FIRDatabase.database().reference()
        
        //Listen for the new Messages  in the firebase database
        
        _refHandle = self.ref.child("messages").observe(.childAdded, with: { [weak self] (snapshot) -> Void in
            guard let strongSelf = self else {return}
            strongSelf.messages.append(snapshot)
            self?.clientTable.beginUpdates();
            strongSelf.clientTable.insertRows(at: [IndexPath(row: strongSelf.messages.count-1, section: 0)], with: .automatic)
            self?.clientTable.endUpdates();
            
        })
    }
    
    
    func configureStorage(){
        
        storageRef = FIRStorage.storage().reference()
        
    }
    
    @IBAction func didSendMessage(_ sender: UIButton) {
        _ = textFieldShouldReturn(messageTextField)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text  else {
            return true
        }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= self.msglength.intValue
        
    }
    
    //UITableViewDataSource protocol method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue cell
        let cell = self.clientTable .dequeueReusableCell(withIdentifier: "tableViewCell", for: indexPath)
        // Unpack message from Firebase DataSnapshot
        let messageSnapshot: FIRDataSnapshot! = self.messages[indexPath.row]
        guard let message = messageSnapshot.value as? [String:String] else { return cell }
        let name = message[Constants.MessageFields.name] ?? ""
        if let imageURL = message[Constants.MessageFields.imageURL] {
            if imageURL.hasPrefix("gs://") {
                FIRStorage.storage().reference(forURL: imageURL).data(withMaxSize: INT64_MAX) {(data, error) in
                    if let error = error {
                        print("Error downloading: \(error)")
                        return
                    }
                    cell.imageView?.image = UIImage.init(data: data!)
                    tableView.reloadData()
                }
            } else if let URL = URL(string: imageURL), let data = try? Data(contentsOf: URL) {
                cell.imageView?.image = UIImage.init(data: data)
            }
            cell.textLabel?.text = "sent by: \(name)"
        } else {
            let text = message[Constants.MessageFields.text] ?? ""
            cell.textLabel?.text = name + ": " + text
            cell.imageView?.image = UIImage(named: "ic_account_circle")
            if let photoURL = message[Constants.MessageFields.photoURL], let URL = URL(string: photoURL),
                let data = try? Data(contentsOf: URL) {
                cell.imageView?.image = UIImage(data: data)
            }
        }
        return cell
    }
    
    
    
    
    // UITextViewDelegateProtocols methos
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text else {
            return true
        }
        textField.text = ""
        view.endEditing(true)
        let data = [Constants.MessageFields.text: text]
        sendMessage(withData: data)
        return true
    }
    
    func sendMessage(withData data: [String: String]){
        var mdata = data
        mdata[Constants.MessageFields.name] = FIRAuth.auth()?.currentUser?.displayName
        if let photoURL = FIRAuth.auth()?.currentUser?.photoURL{
            mdata[Constants.MessageFields.photoURL] = photoURL.absoluteString
        }
        // push data to Firebase Database
        self.ref.child("messages").childByAutoId().setValue(mdata)
    }
    
    // Mark: Image Picker
    
    
    @IBAction func didTapAddPhoto(_ sender: AnyObject) {
        let picker = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            picker.sourceType = .camera
        }
        else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
   }
    
    
    @IBAction func dismissImageDisplay(_ sender: AnyObject) {
        // if touch detected when image is displayed
        if imageDisplay.alpha == 1.0 {
            UIView.animate(withDuration: 0.25) {
                self.backgroundBlur.effect = nil
                self.imageDisplay.alpha = 0.0
            }
            dismissImageRecognizer.isEnabled = false
            messageTextField.isEnabled = true
        }
    }
    
    // MARK: Show Image Display
    
    func showImageDisplay(_ image: UIImage) {
        dismissImageRecognizer.isEnabled = true
        dismissKeyboardRecognizer.isEnabled = false
        messageTextField.isEnabled = false
        UIView.animate(withDuration: 0.25) {
            self.backgroundBlur.effect = UIBlurEffect(style: .light)
            self.imageDisplay.alpha = 1.0
            self.imageDisplay.image = image
        }
    }
  
    func sendPhotoMessage(photoData: Data) {
        // build a path using the user’s ID and a timestamp
        let imagePath = "chat_photos/" + FIRAuth.auth()!.currentUser!.uid + "/\(Double(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        // set content type to “image/jpeg” in firebase storage metadata
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        // create a child node at imagePath with imageData and metadata
        storageRef!.child(imagePath).put(photoData, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error uploading: \(error)")
                return
            }
            // use sendMessage to add imageURL to database
            self.sendMessage(withData: [Constants.MessageFields.imageURL: self.storageRef!.child((metadata?.path)!).description])
        }
    }
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String:Any]) {
    // constant to hold the information about the photo
       if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage, let photoData = UIImageJPEGRepresentation(photo, 0.8) {
           // call function to upload photo message
             sendPhotoMessage(photoData: photoData)
         }
         picker.dismiss(animated: true, completion: nil)
        }

     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         picker.dismiss(animated: true, completion: nil)
     }
    
    func showAlert(withTitle title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title,
                                          message: message, preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}


