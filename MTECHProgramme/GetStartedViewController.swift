//
//  GetStartedViewController.swift
//  MTECHProgramme
//
//  Created by student on 2/5/17.
//
//

import UIKit
import FlatUIKit

class GetStartedViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextViewDelegate, UICollectionViewDelegate {

    @IBOutlet weak var imagecollectionView: UICollectionView!
    @IBOutlet weak var GetStarted: FUIButton!
    @IBOutlet var TextView: UITextView!
    @IBOutlet weak var Label: UITextField!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var logoImage: [String] = ["Head","chat_image","book-image"]
    
    var logoLabel:[String] = ["Book Catalog", "Start Chat","Add books"]
    
    var logoText: [String] = ["Let's Begin The Journey","Ask to get if book available","My added books"]
    override var nibName: String?
        {
        get
        {
            return "GetStartedViewController";
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "GetStartedViewController", bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        TextView.delegate = self
        
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
        
        let buttonThemer:ButtonThemer = ButtonThemer()
        let buttonTheme: ButtonTheme = ButtonTheme()
        buttonThemer.applyTheme(view: GetStarted, theme: buttonTheme)
        
        TextView.text = logoText[0]
        Label.text = logoLabel[0]
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
                for cell in imagecollectionView.visibleCells  as [UICollectionViewCell]    {
                    let indexPath = imagecollectionView.indexPath(for: cell as UICollectionViewCell)
        
                    TextView.text = logoText[indexPath!.row]
                    Label.text = logoLabel[indexPath!.row]
                }
    }
    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {

//    }
    
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

