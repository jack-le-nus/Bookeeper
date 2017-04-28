//
//  NewBookViewController.swift
//  MTECHProgramme
//
//  Created by Ritesh Kumar on 4/18/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import UIKit
import ELCImagePickerController
import Firebase
import FlatUIKit

class NewBookViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,ELCImagePickerControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var authorName: FUITextField!
    @IBOutlet weak var bookName: FUITextField!
    
    @IBOutlet weak var createButton: FUIButton!
    @IBOutlet weak var pickImageButton: UIButton!
    @IBOutlet weak var descriptionOfBook: UITextField!

    @IBOutlet weak var selectCategory: FUITextField!
    @IBOutlet weak var imgScrollView: UIScrollView!
    
    var categoryPickerView = UIPickerView()
    
    var ref: FIRDatabaseReference!
    var storageRef: FIRStorageReference!
    
    override var nibName: String?
        {
        get
        {
            return "NewBookViewController";
        }
    }
    
    override required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPickerView.delegate = self
        categoryPickerView.dataSource = self
        authorName.delegate = self
        bookName.delegate = self
        descriptionOfBook.delegate = self
        
        
        let buttonThemer:ButtonThemer = ButtonThemer()
        buttonThemer.applyTheme(view: createButton, theme: ButtonTheme())
        
        let textFieldThemer:TextFieldThemer = TextFieldThemer()
        textFieldThemer.applyTheme(view: authorName, theme: TextFieldTheme())
        textFieldThemer.applyTheme(view: bookName, theme: TextFieldTheme())
        textFieldThemer.applyTheme(view: selectCategory, theme: TextFieldTheme())
        
        imgScrollView.backgroundColor = UIColor.alizarin()
        imgScrollView.layer.borderWidth=1
        
        selectCategory.inputView = categoryPickerView

        isUserSignedIn()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        authorName.resignFirstResponder()
        bookName.resignFirstResponder()
        descriptionOfBook.resignFirstResponder()
        return true
    }
    
    func isUserSignedIn(){
        configureDatabase()
        configureStorage()
    }
    
    //cofig with firebase
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
    }
    
    func configureStorage() {
        storageRef = FIRStorage.storage().reference()
    }

    func getUid() -> String {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    // delegates for picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return AppMessage.categories.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return AppMessage.categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectCategory.text = AppMessage.categories[row]
        self.view.endEditing(false)
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = AppMessage.categories[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 15.0)!,NSForegroundColorAttributeName:UIColor.blue])
        return myTitle
    }

    @IBAction func saveBook(_ sender: Any) {
        // TODO: null and if checkof text field
        let fieldCheck:Bool = true;
        sendBookDetail(fieldCheck : fieldCheck)
        //authorName.resignFirstResponder()
        //bookName.resignFirstResponder()
    }
    
    
    @IBAction func selectImage(_ sender: Any) {
        self.pickImages()
   }
    
    func pickImages() {
        let picker = ELCImagePickerController()
        picker.maximumImagesCount = 3
        picker.imagePickerDelegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    var pickedImages = NSMutableArray()
    
    func elcImagePickerController(_ picker: ELCImagePickerController!, didFinishPickingMediaWithInfo info: [Any]!) {
        self.dismiss(animated: true, completion: nil)
        if (info.count == 0) {
            return
        }
        let subViews = self.imgScrollView.subviews
        for subview in subViews{
            subview.removeFromSuperview()
            pickedImages.removeAllObjects()
        }
        
        for any in info {
            let dict = any as! NSMutableDictionary
            let image = dict.object(forKey: UIImagePickerControllerOriginalImage) as! UIImage
            pickedImages.add(image)
        }
        
        let imageWidth:CGFloat = 320
        let imageHeight:CGFloat = 175
        let yPosition:CGFloat = 15
        var xPosition:CGFloat = 10
        var scrollViewContentSize:CGFloat=0;
        
        for i in pickedImages{
            let myImageView:UIImageView = UIImageView()
            
            myImageView.image = i as? UIImage
            myImageView.contentMode = UIViewContentMode.scaleAspectFit
            myImageView.frame.size.width = imageWidth
            myImageView.frame.size.height = imageHeight
            myImageView.center = self.view.center
            myImageView.frame.origin.y = yPosition
            myImageView.frame.origin.x = xPosition
            
            imgScrollView.addSubview(myImageView)
            imgScrollView.addSubview(pickImageButton)
            let spacer:CGFloat = 5
            xPosition+=imageWidth + spacer
            scrollViewContentSize+=imageWidth + spacer
            imgScrollView.contentSize = CGSize(width: scrollViewContentSize, height: imageHeight)
        }
        let count = imgScrollView.subviews.count;
        print("image count: \(count)")
    }
    
    
    func elcImagePickerControllerDidCancel(_ picker: ELCImagePickerController!) {
        dismiss(animated: true, completion: nil)
    }
    
    
    func sendBookDetail(fieldCheck : Bool) {
        if(fieldCheck == true){
            var newKey: String = ""
            
            var b = [String:String]()
            b[AppMessage.author.rawValue] = authorName.text! as String
            b[AppMessage.categary.rawValue] = selectCategory.text! as String
            b[AppMessage.description.rawValue] = descriptionOfBook.text! as String
            b[AppMessage.isAvailable.rawValue] = "true"
            b[AppMessage.isFeatured.rawValue] = "true"
            b[AppMessage.borrowerUid.rawValue] = ""
            b[AppMessage.bookname.rawValue] = bookName.text! as String
            b[AppMessage.userId.rawValue] = getUid() as String
            
            let query = ref.child("Book").queryOrderedByKey().queryLimited(toLast: 1)
            query.observeSingleEvent(of: .value, with: { snapshot in
                for task in snapshot.children {
                    guard let taskSnapshot = task as? FIRDataSnapshot else {
                        continue
                    }
                    print("Last key in firebase: "+taskSnapshot.key)
                    newKey = String(Int(taskSnapshot.key)! + 1)
                    self.sendImageDeatil(newkey: newKey,data : b)
                }
            })
            
            
            
//            let bookDetail = BookDetail(author:[AppMessage.author.rawValue:authorName.text! as String],
//                categary:[AppMessage.categary.rawValue:selectedCategary as String],
//                description:[AppMessage.description.rawValue:descriptionOfBook.text! as String],
//                bookId:[AppMessage.id.rawValue:newKey as String],
//                isAvailable:[AppMessage.isAvailable.rawValue: true],
//                isFeatured:[AppMessage.isFeatured.rawValue: true],
//                bookName:[AppMessage.bookname.rawValue: bookName.text! as String],
//                owner:[AppMessage.owner.rawValue:"Ritesh" as String]
//            )
            
            
            

        }
        self.alert(content: AppMessage.booksaved.rawValue, onCancel: {
            action -> Void in
            self.performSegue(withIdentifier: "showBookList", sender: nil)
        })
    }
    
    func sendImageDeatil(newkey : String, data: [String:Any]){
        var imageUrls = [String]()
        var sdata = data
        if (pickedImages.count > 0 ){
            let imagePath = "book_image/" +  (newkey)
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            for urls in (pickedImages as NSMutableArray) {
                let newPath = "/\(Double(Date.timeIntervalSinceReferenceDate * 100)).jpg"
                let imageToSave = urls as? UIImage
                let photoData = UIImageJPEGRepresentation(imageToSave!, 0.8)
                storageRef!.child(imagePath).child(newPath).put(photoData!, metadata: metadata)
                {( metadata, error) in
                    if let error = error {
                        print("error uploading : \(error)")
                        return
                    }
                    imageUrls.append(self.storageRef!.child((metadata?.path)!).description)
                    sdata[AppMessage.id.rawValue] = newkey as String
                    sdata[AppMessage.imageUrl.rawValue] = imageUrls
                    self.ref.child("Book").child(newkey).setValue(sdata)
                }
            }
        }else{
            sdata[AppMessage.id.rawValue] = newkey as String
            imageUrls.append("")
            sdata[AppMessage.imageUrl.rawValue] = imageUrls
            self.ref.child("Book").child(newkey).setValue(sdata)
        }
    }

}


