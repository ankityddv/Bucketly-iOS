//
//  SignInVC.swift
//  BucketList
//
//  Created by ANKIT YADAV on 24/04/21.
//

import Hero
import UIKit

class SignInVC: UIViewController {

    
    @IBAction func signUpBttnDidTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
    }
    
}
