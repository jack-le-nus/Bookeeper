//
//  BookDetailViewController.swift
//  MTECHProgramme
//
//  Created by Ritesh Kumar on 4/25/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import UIKit
import Firebase
import MessageUI
import FlatUIKit

class BookDetailViewController: UIViewController, MFMessageComposeViewControllerDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bookCategory: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bookName: UILabel!
    var userId : String!
    var ownerContactDetails : NSNumber!
    var ref: FIRDatabaseReference!
    var _refHandle: FIRDatabaseHandle!
    var bookCell: BookCell?
    var bookId : String!
    @IBOutlet weak var messageBtn: FUIButton!
    @IBOutlet weak var bookDescription: UITextView!
    @IBOutlet weak var checkOutBtn: FUIButton!
    
    override var nibName: String?
        {
        get
        {
            return "BookDetailViewController";
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner(view: self.view)
        
        configureDatabase()
        self.applyTheme()
        
        self.collectionView.register(UINib(nibName: "BookImages", bundle: nil), forCellWithReuseIdentifier: "BookImages")
        self.collectionView.delegate = self
        self.collectionView.isPagingEnabled = true
        self.collectionView.alwaysBounceHorizontal = true
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.contentInset = UIEdgeInsets(top: -65, left: 0, bottom: 0, right: 0)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        self.pageControl.numberOfPages = Int((bookCell?.images!.count)!)
        
        bookName.text = bookCell?.lblName.text
        //adjustUITextViewHeight(textView: bookName)
        //bookName.textContainer.maximumNumberOfLines = 2
        //bookName.textContainer.lineBreakMode = .byWordWrapping
        bookCategory.text = bookCell?.category
        bookAuthor.text = bookCell?.author
        bookDescription.text = bookCell?.bookDescription
        bookId = bookCell?.bookId
        getOwnerDetail()
        hideShowChatButton()
        self.hideSpinner()
        let buttonThemer:ButtonThemer = ButtonThemer()
        buttonThemer.applyTheme(view: checkOutBtn, theme: ButtonTheme())
        buttonThemer.applyTheme(view: messageBtn, theme: ButtonTheme())

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func adjustUITextViewHeight(textView : UITextView)
    {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame;
        textView.isScrollEnabled = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width : CGFloat = scrollView.frame.size.width;
       pageControl.currentPage = Int(scrollView.contentOffset.x/width);
    }
    
    
    
}

extension BookDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookImages", for: indexPath) as! BookImages
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if((bookCell?.images!.count)!>0){
            return (bookCell?.images!.count)!
        }else{
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let imageCell = cell as! BookImages
        cell.contentView.backgroundColor = UIColor.alizarin()
        cell.contentView.layer.borderWidth=1
        if(bookCell?.images[0] != ""){
            FIRStorage.storage().reference(forURL : (bookCell?.images[indexPath.row])!).data(withMaxSize: INT64_MAX ) {( data,error)
                in
                let imageView = UIImage.init(data: data!, scale: 50)
                imageCell.bookImages.image = imageView
            }
        }else{
            imageCell.bookImages.image = #imageLiteral(resourceName: "bookImage")
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //if (collectionView == self.collectionView) {
            return collectionView.bounds.size
        //}
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    // Added by Sidd for Messaging
    
    @IBAction func checkOutAction(_ sender: Any) {
        
        //TODO remove before installing on Device
        updateData()
        if (MFMessageComposeViewController.canSendText()) {
            updateData()
            let messageViewController:MFMessageComposeViewController = MFMessageComposeViewController()
            messageViewController.messageComposeDelegate=self
            messageViewController.recipients = [self.ownerContactDetails.stringValue]
            messageViewController.body = "Hi,I want to borrow your Book."
            
            self.present(messageViewController, animated: true, completion: nil)
        } else {
            print("Message services are not available")
           // print("UserID is \(self.userId!) and contact number is \(self.ownerContactDetails.stringValue)")
        }
        self.alert(content: AppMessage.checkoutSuccessful.rawValue, onCancel: {
            action -> Void in
            self.navigationController?.popViewController(animated: true)
        })
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result:MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func configureDatabase() {
        ref = FIRDatabase.database().reference()
        
    }
    
    func updateData() {
         let currentUserID = FIRAuth.auth()?.currentUser?.uid
        let data = ["borrowerUid" : currentUserID, "isAvailable" : "false"]
        let updateRef = ref.child("Book").child(self.bookId)
        updateRef.updateChildValues(data)
        
        
    }
    
    func getOwnerDetail() {
        
        print("Book id of the selected Book",bookId)
        let query = ref.child(Constants.UserTables.bookTable).child(bookId).child("userId")
        query.observeSingleEvent(of: .value, with: { snapshot in
            self.userId = snapshot.value as! String
            print("userID is", self.userId)
            
            let userQuery = self.ref.child(Constants.UserTables.userTable).child(self.userId).child("phone")
            userQuery.observeSingleEvent(of: .value, with: { userSnapshot in
               // TODO remove comment once Medha fixes Phone number
              //  self.ownerContactDetails = userSnapshot.value as! NSNumber
               // print("contactNo is", self.ownerContactDetails)
            })
        })
        
    }
    
    func hideShowChatButton() {
        
//        let query = ref.child(Constants.UserTables.bookTable).child(bookId).child(AppMessage.isAvailable.rawValue)
//        query.observeSingleEvent(of: .value, with: { bookSnapshot in
//            // TODO remove comment once Medha fixes Phone number
//             let bookAvailable = bookSnapshot.value as! String
//            print("Is book available", bookAvailable)
//            if bookAvailable == "false" {
//            self.checkOutBtn.isHidden = true
//            }else {
//              self.checkOutBtn.isHidden = false
//            }
//        })
    }

    
}
