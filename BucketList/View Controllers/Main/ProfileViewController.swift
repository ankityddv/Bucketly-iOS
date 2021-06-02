//
//  ProfileViewController.swift
//  Bucketly
//
//  Created by ANKIT YADAV on 31/05/21.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    let spinner = SpinnerView()
    let spinnerLabel = UILabel()
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var editProfileBttn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchName()
        editProfileBttn.layer.borderWidth = 1
        editProfileBttn.layer.cornerRadius = 10
        editProfileBttn.layer.borderColor = UIColor.lightGray.cgColor
    }
    override func viewWillAppear(_ animated: Bool) {
        startLoader()
    }
}

extension ProfileViewController {
    func fetchName() {
        let userID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        ref.child("Users").child(userID ?? "0").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.userNameLabel.text = "@\(username)"
            self.fetchProfileImage()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func fetchProfileImage() {
        // Retrive image
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/profile")
        let imageRef = storageRef.child("\(uid).png")
        imageRef.getData(maxSize: 1*1000*1000) { (data,error) in
            if error == nil{
//                print(data ?? Data.self)
                self.profileImageView.image = UIImage(data: data!)
                self.stopLoader()
            }
            else{
                print(error?.localizedDescription ?? error as Any)
            }
        }
    }
}

extension ProfileViewController {
    // Spinner
    func startLoader() {
        self.containerView.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            self.spinnerLabel.attributedText = NSMutableAttributedString()
                .bold14("LOADING...")
            self.spinnerLabel.frame = CGRect(x: self.view.frame.size.width  / 2, y: self.view.frame.size.height / 2, width: 150, height: 40)
            self.spinnerLabel.center.x = self.view.center.x
            self.spinnerLabel.center.y = self.view.center.y + 20
            self.spinnerLabel.textAlignment = .center
            
            self.spinner.frame = CGRect(x: self.view.frame.size.width  / 2, y: self.view.frame.size.height / 2, width: 30, height: 30)
            self.spinner.center = CGPoint(x: self.view.frame.size.width  / 2, y: (self.view.frame.size.height / 2)-20)
            self.view.addSubview(self.spinnerLabel)
            self.view.addSubview(self.spinner)
            self.spinner.animate()
        })
    }
    func stopLoader() {
        containerView.alpha = 0
        UIView.transition(with: self.containerView, duration: 0.4,
                          options: .curveEaseInOut,
                          animations: {
                            self.containerView.alpha = 1
                      })
        self.spinner.removeFromSuperview()
        self.spinnerLabel.removeFromSuperview()
    }
}
