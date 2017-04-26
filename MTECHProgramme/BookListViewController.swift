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
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var generalBookCollectionView: UICollectionView!
    
    //Added by Medha
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    var isMenuVisible = true
    var menuNameArray:Array = [String]()
    
    
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
        leadingConstraint.constant = -245
        self.ref = FIRDatabase.database().reference()
        
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
        
        let refFeaturedQuery : FIRDatabaseQuery = self.ref.child("Book").queryOrdered(byChild: "isFeatured").queryEqual(toValue: "true")
        
        self.featuredDataSource = self.bookCollectionView?.bind(to: refFeaturedQuery) { bookCollectionView, indexPath, snap in
            let cell = bookCollectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
            let postDict = snap.value as? [String : AnyObject] ?? [:]
            cell.contentView.backgroundColor = UIColor.alizarin()
            cell.contentView.layer.borderWidth=1
            cell.lblName.text = postDict["name"] as? String ?? ""
            cell.lblDescription.text = postDict["description"] as? String ?? ""
            cell.imgBook.contentMode = UIViewContentMode.scaleAspectFit
            cell.imgBook.sd_setImage(with: URL(string: postDict["imageUrl"] as? String ?? ""))
            cell.contentView.frame = bookCollectionView.bounds;
            return cell
        }
        
        self.generalDataSource = self.generalBookCollectionView?.bind(to: self.ref.child("Book")) { generalBookCollectionView, indexPath, snap in
            let cell = generalBookCollectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
            let postDict = snap.value as? [String : AnyObject] ?? [:]
            cell.contentView.backgroundColor = UIColor.alizarin()
            cell.contentView.layer.borderWidth=1
            cell.lblName.text = postDict["name"] as? String ?? ""
            cell.lblDescription.text = postDict["author"] as? String ?? ""
            cell.imgBook.contentMode = UIViewContentMode.scaleAspectFit
            cell.imgBook.sd_setImage(with: URL(string: postDict["imageUrl"] as? String ?? ""))
            return cell
        }
        
        self.ref.child("Book").queryOrdered(byChild: "isFeatured").queryEqual(toValue: true)
            .observe(.childAdded, with: { snapshot in
                self.pageControl.numberOfPages = Int(snapshot.childrenCount)
            })
        
        self.title = "Books"
        
        //Added by Medha to implement Navigation Drawer
        
        menuNameArray = ["Profile","My Books","Borrowed Books","About Us", "Log Out"]
        userImage.contentMode = UIViewContentMode.scaleAspectFit
        userImage.layer.borderWidth = 2
        userImage.layer.borderColor = UIColor.green.cgColor
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.layer.masksToBounds = false
        userImage.clipsToBounds = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SideMenuTableViewCell", bundle: nil), forCellReuseIdentifier: "SideMenuTableViewCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func getUid() -> String {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showBookDetail", sender: collectionView)
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
        leadingConstraint.constant = -245
        isMenuVisible = !isMenuVisible
    }
    
    @IBAction func onMenuClick(_ sender: Any)
    {
        if (isMenuVisible)
        {
            leadingConstraint.constant = 0
        }
        else{
            leadingConstraint.constant = -245
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
        }        
    }
}

