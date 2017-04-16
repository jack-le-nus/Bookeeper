//
//  BookListViewController.swift
//  BookList
//
//  Created by Jack Le on 3/4/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import UIKit
import FlatUIKit
import FirebaseDatabase
import Firebase
import FirebaseDatabaseUI

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
        
        self.bookCollectionView.register(BookCollectionViewCell.self, forCellWithReuseIdentifier: "BookCell")
        self.bookCollectionView.delegate = self
        
        let layout = self.bookCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude
        layout.minimumLineSpacing = 4
        
        self.dataSource = self.bookCollectionView?.bind(to: self.ref.child("Book")) { bookCollectionView, indexPath, snap in
            let cell = bookCollectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCollectionViewCell
            cell.contentView.backgroundColor = UIColor.alizarin()
            cell.contentView.layer.borderWidth=1
            cell.imageView.image = UIImage(named: "dithering")
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
        let heightPadding: CGFloat = 16
        
        let width = self.view.frame.size.width
//        let blob = self.collectionViewDataSource.snapshot(at: indexPath.item)
//        let text = Chat(snapshot: blob)!.text
//        
//        let rect = ChatCollectionViewCell.boundingRectForText(text, maxWidth: width)
        
//        let height = CGFloat(ceil(Double(rect.size.height))) + heightPadding
        return CGSize(width: width, height: 100)
    }}
