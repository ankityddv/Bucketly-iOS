//
//  ViewController.swift
//  BucketList
//
//  Created by ANKIT YADAV on 20/04/21.
//

import UIKit
import Gemini


class OnboardingVC: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: GeminiCollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pageControll: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // Configure cards animation
        collectionView.gemini
           .scaleAnimation()
           .scale(0.65)
           .scaleEffect(.scaleUp) // or .scaleDown
   }
    
    //MARK:- Configure
    
    func configure() {
        titleLabel.attributedText = NSMutableAttributedString()
            .regular20("Welcome to\n")
            .extraBold40("Bucket List")
        descriptionLabel.attributedText = NSMutableAttributedString()
            .regular14("This ")
            .bold14("shit")
            .regular14(" is getting serious\n")
            .regular14("Get your ass here.")
        // pageControl
        pageControll.hidesForSinglePage = true
        self.pageControll.numberOfPages = 3//procedures.count
    }


}

extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: OnboaringCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViews.onboaringCell, for: indexPath) as! OnboaringCVCell
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.collectionView.animateVisibleCells()
        _ = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        
        let witdh = scrollView.frame.width - (scrollView.contentInset.left*2) - 100
        let index = scrollView.contentOffset.x / witdh
        let roundedIndex = round(index)
        self.pageControll?.currentPage = Int(roundedIndex)
        
        switch roundedIndex {
        case 0:
            UIView.transition(with: self.descriptionLabel,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                    animations: { [weak self] in
                                        self!.descriptionLabel.attributedText = NSMutableAttributedString()
                                            .regular14("This ")
                                            .bold14("shit")
                                            .regular14(" is getting serious\n")
                                            .regular14("Get your ass here.")
                                 }, completion: nil)
        case 1:
            UIView.transition(with: self.descriptionLabel,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                    animations: { [weak self] in
                                        self!.descriptionLabel.attributedText = NSMutableAttributedString()
                                            .regular14("This ")
                                            .bold14("shit mfndbafjhgw ")
                                            .regular14(" is getting serious\n")
                                            .regular14("Get your ass here. 2")
                                 }, completion: nil)
            
        case 2:
            UIView.transition(with: self.descriptionLabel,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                    animations: { [weak self] in
                                        self!.descriptionLabel.attributedText = NSMutableAttributedString()
                                            .regular14("This  vqjkdnjkvqk kjda")
                                            .bold14("shit")
                                            .regular14(" is getting serious\n")
                                            .regular14("Get your ass here.")
                                 }, completion: nil)
            
        default:
            UIView.transition(with: self.descriptionLabel,
                                      duration: 0.5,
                                      options: .transitionCrossDissolve,
                                    animations: { [weak self] in
                                        self!.descriptionLabel.attributedText = NSMutableAttributedString()
                                            .regular14("This ")
                                            .bold14("shit")
                                            .regular14(" is getting serious\n")
                                            .regular14("Get your ass here.")
                                 }, completion: nil)
            
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? OnboaringCVCell {
            self.collectionView.animateCell(cell)
        }
    }
    
    
    
}
