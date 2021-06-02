//
//  CartViewController.swift
//  Bucketly
//
//  Created by ANKIT YADAV on 31/05/21.
//

import UIKit
import Firebase

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
}

class ProductsCell: UICollectionViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
}

class CartViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let categoriesArr = ["ALL","FLIPKART","AMAZON","BEST BUY","MYNTRA","SNAPDEAL"]
    
    //MARK:- IBOutlet
    @IBOutlet weak var profileBttn: UIButton!
    @IBOutlet weak var optionsBttn: UIButton!
    @IBOutlet weak var categoryCV: UICollectionView!
    @IBOutlet weak var productsCV: UICollectionView!
    
    //MARK:- IBAction
    @IBAction func profileBttnDidTap(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllers.profile) as! ProfileViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func optionsBttnDidTap(_ sender: Any) {
        let first = UIAction(title: "Default") { [self] _ in
            
        }
        
        let menu = UIMenu(title: "", children: [first])
        optionsBttn.showsMenuAsPrimaryAction = true
        optionsBttn.menu = menu
    }
    
    //MARK:- Collection View
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCV {
            return categoriesArr.count
        } else {
            return 3
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCV {
            let cell:CategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViews.categoryCell, for: indexPath) as! CategoryCell
            cell.titleLabel.text = categoriesArr[indexPath.row]
            cell.bgView.layer.cornerRadius = 10
            cell.bgView.layer.borderWidth = 0.9
            cell.bgView.layer.borderColor = UIColor.darkGray.cgColor
            return cell
        } else {
            let cell:ProductsCell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViews.productsCell, for: indexPath) as! ProductsCell
            cell.productImage.layer.cornerRadius = 10
            cell.layer.cornerRadius = 15
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCV {
            let cell = collectionView.cellForItem(at: indexPath) as! CategoryCell
            cell.bgView.layer.backgroundColor = UIColor(named: "greenAppColor")?.cgColor
            cell.titleLabel.textColor = UIColor.black
            cell.bgView.layer.borderWidth = 0
            lightImpactHaptic()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFuncs()
//        fetchProfileImage()
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
        setUpTabBar()
        configureAppTheme()
    }
    func configureNavBar() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
    func setUpTabBar(){
        let appearance = self.tabBarController?.tabBar.standardAppearance
        appearance!.shadowImage = nil
        appearance!.shadowColor = nil
        appearance!.backgroundEffect = nil
        appearance!.backgroundColor = UIColor.black
        self.tabBarController?.tabBar.standardAppearance = appearance!
        self.tabBarController?.tabBar.barTintColor = UIColor.black
        self.tabBarController?.tabBar.layer.masksToBounds = false
        self.tabBarController?.tabBar.layer.shadowColor = UIColor.black.cgColor
        self.tabBarController?.tabBar.layer.shadowOpacity = 0.4
        self.tabBarController?.tabBar.layer.shadowOffset = CGSize(width: 0.4, height: 0.4)
        self.tabBarController?.tabBar.layer.shadowRadius = 10
    }
    func configureAppTheme() {
        // set the theme to dark
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
    }
    func fetchProfileImage() {
        // Retrive image
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/profile")
        let imageRef = storageRef.child("\(uid).png")
        imageRef.getData(maxSize: 1*1000*1000) { (data,error) in
            if error == nil {
//                self.profileBttn.setImage(UIImage(data: data!), for: .normal)
//                self.profileBttn.frame.size = CGSize(width: 46, height: 46)
//                self.profileBttn.layer.cornerRadius = 23
                print("Loaded")
            }
            else{
                print(error?.localizedDescription ?? error as Any)
            }
        }
    }
}
