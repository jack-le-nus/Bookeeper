//
//  BookListViewController.swift
//  BookList
//
//  Created by Jack Le on 3/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import UIKit
import FlatUIKit
import Firebase
import FirebaseDatabaseUI
import FirebaseDatabase
import SDWebImage

class BookListViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource
{
   
    var ref: FIRDatabaseReference!
    var _refHandle: FIRDatabaseHandle!
    var books: [FIRDataSnapshot]! = []
    var featuredDataSource: FUICollectionViewDataSource!
    @IBOutlet weak var pageControl: UIPageControl!
    var generalDataSource: FUICollectionViewDataSource!
    var storeRef: FIRStorageReference!
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var generalBookCollectionView: UICollectionView!
    
    //Added by Medha
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    var isMenuVisible = true
    
    var menuNameArray:Array = [String]()
    var flag = true
    
    
    override var nibName: String?
    {
        get
        {
            
            return "BookListViewController";
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyTheme()
        leadingConstraint.constant = -250
        flag = false
        self.ref = FIRDatabase.database().reference()
        self.storeRef = FIRStorage.storage().reference()
        self.bookCollectionView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
        self.bookCollectionView.delegate = self
        self.bookCollectionView.isPagingEnabled = true
        self.bookCollectionView.alwaysBounceHorizontal = true
        self.bookCollectionView.showsHorizontalScrollIndicator = false
        self.bookCollectionView.contentInset = UIEdgeInsets(top: -65, left: 0, bottom: 0, right: 0)
        
        self.generalBookCollectionView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
        self.generalBookCollectionView.delegate = self
        self.generalBookCollectionView.alwaysBounceVertical = true
        
        
        let layout = self.bookCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let layout1 = self.generalBookCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout1.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude
        layout1.minimumLineSpacing = 10
        layout1.minimumInteritemSpacing = 10
        
        
        
        self.title = "Books"
        
        //Added by Medha to implement Navigation Drawer
        
        let currentUser = getUid()
        menuNameArray = ["Profile","Add Books","Borrowed Books","About Us", "Log Out"]
        var message = "Welcome "
        let userRef = ref.child("User").child(currentUser)
        userRef.observeSingleEvent(of: .value, with: { snapshot in
            let values =  snapshot.value as? [String:AnyObject] ?? [:]
            
            //Retrieval of user image and name from db
            let displayName = values["name"] as? String ?? ""
            message = message.appending(displayName)
            self.userLabel.text = message
            if snapshot.hasChild("imageUrl")
            {
                let url = values["imageUrl"] as? String ?? ""
                FIRStorage.storage().reference(forURL: url).data(withMaxSize: 10 * 1024 * 1024, completion: { (data,error) in
                    DispatchQueue.main.async() { Void in
                        let image = UIImage(data: data!)
                        self.userImage.image = image!
                    }
                })
            }
        })
        userImage.contentMode = UIViewContentMode.scaleAspectFit
        userImage.layer.borderWidth = 2        
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.masksToBounds = false
        userImage.clipsToBounds = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let refFeaturedQuery : FIRDatabaseQuery = self.ref.child("Book").queryOrdered(byChild: "isFeatured").queryEqual(toValue: "true")
        
        self.featuredDataSource = self.bookCollectionView?.bind(to: refFeaturedQuery) { bookCollectionView, indexPath, snap in
            let cell = bookCollectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
            let postDict = snap.value as? [String : AnyObject] ?? [:]
            cell.contentView.backgroundColor = UIColor.alizarin()
            cell.contentView.layer.borderWidth=1
            cell.lblName.text = postDict["bookname"] as? String ?? ""
            cell.lblDescription.text = postDict["description"] as? String ?? ""
            cell.author = postDict["author"] as? String ?? ""
            cell.category = postDict["categary"] as? String ?? ""
            cell.bookId = snap.key
            cell.bookDescription = postDict["description"] as? String ?? ""
            cell.userUid = postDict["userId"] as? String ?? ""
            cell.imgBook.contentMode = UIViewContentMode.scaleAspectFit
            cell.isAvailable = postDict["isAvailable"] as? String ?? ""
            let imagesUrls = postDict["imageUrl"] as! NSArray
            let castArray = imagesUrls as? Array<Any>
            cell.images = castArray as! [String]!
            let tImage = imagesUrls[0] as! String
            if(tImage == ""){
                cell.imgBook.image = #imageLiteral(resourceName: "bookImage")
            }else{
                FIRStorage.storage().reference(forURL : imagesUrls[0] as! String).data(withMaxSize: INT64_MAX ) {( data,error)
                    in
                    let messageImageTop = UIImage.init(data: data!, scale: 50)
                    cell.imgBook.image = messageImageTop
                    
                }
            }
            cell.contentView.frame = bookCollectionView.bounds;
            return cell
        }
        
        let refGeneralQuery : FIRDatabaseQuery = self.ref.child("Book").queryOrdered(byChild: "isAvailable").queryEqual(toValue: "true")
        self.generalDataSource = self.generalBookCollectionView?.bind(to: refGeneralQuery) { generalBookCollectionView, indexPath, snap in
            let cell = generalBookCollectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
            let postDict = snap.value as? [String : AnyObject] ?? [:]
            cell.contentView.backgroundColor = UIColor.alizarin()
            cell.contentView.layer.borderWidth=1
            cell.lblName.text = postDict["bookname"] as? String ?? ""
            cell.lblDescription.text = postDict["author"] as? String ?? ""
            cell.imgBook.contentMode = UIViewContentMode.scaleAspectFit
            cell.bookDescription = postDict["description"] as? String ?? ""
            cell.userUid = postDict["userId"] as? String ?? ""
            cell.author = postDict["author"] as? String ?? ""
            cell.category = postDict["categary"] as? String ?? ""
            cell.isAvailable = postDict["isAvailable"] as? String ?? ""
            cell.bookId = snap.key
            cell.imgBook.contentMode = UIViewContentMode.scaleAspectFit
            let imagesUrls = postDict["imageUrl"] as! NSArray
            let castArray = imagesUrls as? Array<Any>
            cell.images = castArray as! [String]!
            let firstImage = imagesUrls[0] as! String
            if(firstImage == ""){
                cell.imgBook.image = #imageLiteral(resourceName: "bookImage")
            }else{
                FIRStorage.storage().reference(forURL : imagesUrls[0] as! String).data(withMaxSize: INT64_MAX ) {( data,error)
                    in
                    let messageImage = UIImage.init(data: data!, scale: 50)
                    cell.imgBook.image = messageImage
                    
                }
            }
            return cell
        }
        
        self.ref.child("Book").queryOrdered(byChild: "isFeatured").queryEqual(toValue: "true")
            .observe(.childAdded, with: { snapshot in
                self.pageControl.numberOfPages = Int(snapshot.childrenCount)
            })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if(flag)
        {
            let currentUser = getUid()
            let userRef = ref.child("User").child(currentUser)
            var message = "Welcome "
            userRef.observeSingleEvent(of: .value, with: { snapshot in
                let values =  snapshot.value as? [String:AnyObject] ?? [:]
                //Retrieval of user image from db
                let displayName = values["name"] as? String ?? ""
                message = message.appending(displayName)
                self.userLabel.text = message
                if (snapshot.hasChild("imageUrl"))
                {
                    let url = values["imageUrl"] as? String ?? ""
                    FIRStorage.storage().reference(forURL: url).data(withMaxSize: 10 * 1024 * 1024, completion: { (data,error) in
                        DispatchQueue.main.async() { Void in
                            let image = UIImage(data: data!)
                            self.userImage.image = image!
                        }
                    })
                }
            })
            
            print(message)
            self.leadingConstraint.constant = -250
            isMenuVisible = !isMenuVisible
        } else{
            flag = true
        }
    }

    
    func getUid() -> String {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! BookCell
        self.performSegue(withIdentifier: "showBookDetail", sender: cell)
        flag = false
        leadingConstraint.constant = -250

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showBookDetail" {
            let detailsVC: BookDetailViewController = segue.destination as! BookDetailViewController
            let cell = sender as! BookCell
            detailsVC.bookCell = cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width : CGFloat = scrollView.frame.size.width;
        pageControl.currentPage = Int(scrollView.contentOffset.x/width);
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if (collectionView == bookCollectionView) {
            return collectionView.bounds.size
        }
        else {
            let padding : CGFloat =  10
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    //Added by Medha
    @IBAction func onProfileClick(_ sender: UIButton)
    {
        self.performSegue(withIdentifier: "openProfileView", sender: nil)
        leadingConstraint.constant = -250
        isMenuVisible = !isMenuVisible
    }
    
    @IBAction func onMenuClick(_ sender: Any)
    {
        if (isMenuVisible)
        {
            leadingConstraint.constant = 0
        }
        else{
            leadingConstraint.constant = -250
        }
        isMenuVisible = !isMenuVisible
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath) as! SideMenuTableViewCell
        cell.menu.text = menuNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell:SideMenuTableViewCell = tableView.cellForRow(at: indexPath) as! SideMenuTableViewCell
        if cell.menu.text! == "Profile"
        {
            self.performSegue(withIdentifier: "openProfileView", sender: nil)
        }else if cell.menu.text! == "Add Books"
        {
            self.performSegue(withIdentifier: "showNewBook", sender: nil)
        }else if cell.menu.text! == "Borrowed Books"
        {
            self.performSegue(withIdentifier: "showBorrowedBooks", sender: nil)
        }else if cell.menu.text! == "Log Out"
        {
            do {
                print("Sign Out Clicked")
                try FIRAuth.auth()?.signOut()
                self.alert(content: AppMessage.SignOutSuccess.rawValue, onCancel: {
                    action -> Void in
                    
                    self.performSegue(withIdentifier: "logOut", sender: nil)
                })
                
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError)
            }
        }else if cell.menu.text! == "About Us"
        {
            self.performSegue(withIdentifier: "openAboutUsView", sender: nil)
        }
    }
}


