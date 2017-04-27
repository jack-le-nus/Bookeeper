//
//  BookDetailViewController.swift
//  MTECHProgramme
//
//  Created by Ritesh Kumar on 4/25/17.
//  Copyright © 2017 Jack Le. All rights reserved.
//

import UIKit
import Firebase

class BookDetailViewController: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var bookCategory: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bookName: UILabel!

    var bookCell: BookCell?
    @IBOutlet weak var bookDescription: UITextView!

    override var nibName: String?
        {
        get
        {
          return "BookDetailViewController";
        }
    }
    
    override required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
        imageCell.contentView.backgroundColor = UIColor.alizarin()
        imageCell.contentView.layer.borderWidth=1
        //imageCell.contentMode = UIViewContentMode.scaleAspectFit
        if(bookCell?.images[0] != ""){
            FIRStorage.storage().reference(forURL : (bookCell?.images[indexPath.row])!).data(withMaxSize: INT64_MAX ) {( data,error)
                in
                let imageView = UIImage.init(data: data!, scale: 50)
                imageCell.bookImages.image = imageView
            }
        }else{
            imageCell.bookImages.image = #imageLiteral(resourceName: "imageBook")
        }
        cell.contentView.frame = self.collectionView.bounds;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        //if (collectionView == self.collectionView) {
            let padding : CGFloat =  0
            let collectionViewSize = self.collectionView.frame.size.width - padding
            return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        //}
//        else {
//            let padding : CGFloat =  10
//            let collectionViewSize = collectionView.frame.size.width - padding
//            return CGSize(width: collectionViewSize/2, height: collectionViewSize/2)
//        }
        //}
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width : CGFloat = scrollView.frame.size.width;
        pageControl.currentPage = Int(scrollView.contentOffset.x/width);
    }
}
