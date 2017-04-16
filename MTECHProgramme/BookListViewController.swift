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

class BookListViewController: UIViewController, UICollectionViewDelegateFlowLayout {
   
    var ref: FIRDatabaseReference!
    var _refHandle: FIRDatabaseHandle!
    var books: [FIRDataSnapshot]! = []
    var dataSource: FUICollectionViewDataSource!
    
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
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
        
        self.ref = FIRDatabase.database().reference()
        
        self.bookCollectionView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
        self.bookCollectionView.delegate = self
        
        let layout = self.bookCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude
        layout.minimumLineSpacing = 4
        
        self.dataSource = self.bookCollectionView?.bind(to: self.ref.child("Book")) { bookCollectionView, indexPath, snap in
            let cell = bookCollectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
            let postDict = snap.value as? [String : AnyObject] ?? [:]
            cell.contentView.backgroundColor = UIColor.alizarin()
            cell.contentView.layer.borderWidth=1
            cell.lblName.text = postDict["name"] as? String ?? ""
            cell.lblDescription.text = postDict["description"] as? String ?? ""
            cell.imgBook.contentMode = UIViewContentMode.scaleAspectFit
            cell.imgBook.sd_setImage(with: URL(string: postDict["imageUrl"] as? String ?? ""))
            return cell
        }
        
        loadBooks()
        
        self.title = "Books"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func loadBooks(){
        self.books.removeAll()
        _refHandle = self.ref.child("Book").observe(.childAdded, with: { (snapshot) -> Void in
            self.books.append(snapshot)
        })
        
        self.bookCollectionView.reloadData()
    }
    
    
    func getUid() -> String {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width, height: collectionView.frame.height)
    }}
