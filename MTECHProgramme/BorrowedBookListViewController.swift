//
//  BorrowedBookListViewController.swift
//  MTECHProgramme
//
//  Created by Siddharth Deshmukh on 4/25/17.
//
//

import UIKit
import FlatUIKit
import Firebase
import FirebaseDatabaseUI
import FirebaseDatabase
import SDWebImage

class BorrowedBookListViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate
{
    
    var ref: FIRDatabaseReference!
    var _refHandle: FIRDatabaseHandle!
    var books: [FIRDataSnapshot]! = []
    var currentUserUid : String!
    
    var generalDataSource: FUICollectionViewDataSource!
    
       @IBOutlet weak var borrowedBookCollectionView: UICollectionView!
    
    override var nibName: String?
        {
        get
        {
            
            return "BorrowedBookListViewController";
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.applyTheme()
      
        self.ref = FIRDatabase.database().reference()
        
        self.borrowedBookCollectionView.register(UINib(nibName: "BookCell", bundle: nil), forCellWithReuseIdentifier: "BookCell")
        self.borrowedBookCollectionView.delegate = self
        self.borrowedBookCollectionView.alwaysBounceVertical = true
        
        let layout1 = self.borrowedBookCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout1.minimumInteritemSpacing = CGFloat.greatestFiniteMagnitude
        layout1.minimumLineSpacing = 10
        layout1.minimumInteritemSpacing = 10
        
        currentUserUid = (FIRAuth.auth()?.currentUser?.uid)!
        
       let borrowedBookQuery = self.ref.child("Book").queryOrdered(byChild: "borrowerUid").queryEqual(toValue: currentUserUid)
        
        self.generalDataSource = self.borrowedBookCollectionView?.bind(to: borrowedBookQuery) { borrowedBookCollectionView, indexPath, snap in
            
            let postDict = snap.value as? [String : AnyObject] ?? [:]
            
            let cell = borrowedBookCollectionView.dequeueReusableCell(withReuseIdentifier: "BookCell", for: indexPath) as! BookCell
            cell.contentView.backgroundColor = UIColor.alizarin()
            cell.contentView.layer.borderWidth=1
            cell.lblName.text = postDict["bookname"] as? String ?? ""
            cell.lblDescription.text = postDict["author"] as? String ?? ""
            cell.imgBook.contentMode = UIViewContentMode.scaleAspectFit
            cell.bookDescription = postDict["description"] as? String ?? ""
            cell.author = postDict["author"] as? String ?? ""
            cell.category = postDict["categary"] as? String ?? ""
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
            self.title = "Borrowed Books"
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func getUid() -> String {
        return (FIRAuth.auth()?.currentUser?.uid)!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "borrowedBookDetail", sender: collectionView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "borrowedBookDetail" {
            let detailsVC: BookDetailViewController = segue.destination as! BookDetailViewController
            let indexPaths:NSIndexPath = self.borrowedBookCollectionView.indexPathsForSelectedItems![0] as NSIndexPath
            let cell = borrowedBookCollectionView.cellForItem(at: indexPaths as IndexPath) as! BookCell
            detailsVC.bookCell = cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width : CGFloat = scrollView.frame.size.width;
       // pageControl.currentPage = Int(scrollView.contentOffset.x/width);
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
            let padding : CGFloat =  10
            let collectionViewSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
}
