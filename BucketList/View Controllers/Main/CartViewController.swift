//
//  CartViewController.swift
//  Bucketly
//
//  Created by ANKIT YADAV on 31/05/21.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
}

class CartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let categoriesArr = ["ALL","FLIPKART","AMAZON","BEST BUY","MYNTRA","SNAPDEAL"]
    
    //MARK:- IBOutlet
    @IBOutlet weak var profileBttn: UIButton!
    @IBOutlet weak var optionsBttn: UIButton!
    @IBOutlet weak var categoryCV: UICollectionView!
    
    //MARK:- IBAction
    @IBAction func profileBttnDidTap(_ sender: Any) {
    }
    @IBAction func optionsBttnDidTap(_ sender: Any) {
    }
    
    //MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesArr.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViews.categoryCell, for: indexPath) as! CategoryCell
        cell.titleLabel.text = categoriesArr[indexPath.row]
        cell.bgView.layer.cornerRadius = 10
        cell.bgView.layer.borderWidth = 0.9
        cell.bgView.layer.borderColor = UIColor.darkGray.cgColor
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
        cell.bgView.layer.backgroundColor = UIColor(named: "greenAppColor")?.cgColor
        cell.titleLabel.textColor = UIColor.black
        cell.bgView.layer.borderWidth = 0
        lightImpactHaptic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFuncs()
    }
    override func viewWillAppear(_ animated: Bool) {
        lightImpactHaptic()
    }
}

extension CartViewController {
    func configureFuncs() {
        switch getLoginState() {
        case .isLoggedIn:
            break
        case .isLoggedOut:
            let vc = storyboard?.instantiateViewController(identifier: ViewControllers.onboarding) as! OnboardingVC
            self.present(vc, animated: true, completion: nil)
        }
        configureNavBar()
    }
    
    func configureNavBar() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
}
