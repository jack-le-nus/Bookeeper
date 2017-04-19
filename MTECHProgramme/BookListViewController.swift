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

class BookListViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
   
    var ref: FIRDatabaseReference!
    var _refHandle: FIRDatabaseHandle!
    var books: [FIRDataSnapshot]! = []
    var featuredDataSource: FUICollectionViewDataSource!
    @IBOutlet weak var pageControl: UIPageControl!
    var generalDataSource: FUICollectionViewDataSource!
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    @IBOutlet weak var generalBookCollectionView: UICollectionView!

    override var nibName: String?
    {
        get
        {
            
            return "BookListViewController";
        }
    }
    
    override required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyTheme()
        
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
}


