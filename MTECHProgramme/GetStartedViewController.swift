//
//  GetStartedViewController.swift
//  MTECHProgramme
//
//  Created by student on 2/5/17.
//
//

import UIKit
import FlatUIKit

class GetStartedViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imagecollectionView: UICollectionView!
    @IBOutlet weak var GetStarted: FUIButton!
    @IBOutlet var TextView: [UITextView]!
    @IBOutlet weak var Label: UITextField!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var logoImage: [String] = ["Image_1", "Image_2", "Image_3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.imagecollectionView.register(UINib(nibName: "GetStartedCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GetStartedCollectionViewCell")
        
        self.imagecollectionView.delegate = self
        self.imagecollectionView.dataSource = self
        self.imagecollectionView.isPagingEnabled = true
        self.imagecollectionView.alwaysBounceHorizontal = true
        self.imagecollectionView.showsHorizontalScrollIndicator = false
        self.imagecollectionView.contentInset = UIEdgeInsets(top: -65, left: 0, bottom: 0, right: 0)
        
        let layout = self.imagecollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        
        
        self.imagecollectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3;
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imagecollectionView.dequeueReusableCell(withReuseIdentifier: "GetStartedCollectionViewCell", for: indexPath) as! GetStartedCollectionViewCell
        
        cell.img.image = UIImage(named: logoImage[indexPath.row])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width : CGFloat = scrollView.frame.size.width;
        pageControl.currentPage = Int(scrollView.contentOffset.x/width);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.bounds.size
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
   
   
    @IBAction func btnclicked(_ sender: Any) {
        self.performSegue(withIdentifier: "showTab", sender: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

