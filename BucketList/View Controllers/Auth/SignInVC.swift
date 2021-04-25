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
        lightImpactHeptic()
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hero.isEnabled = true
        setUpKeyboardNotifications()
    }
    
}

//MARK:- ⌨️ keyboard notifications
extension SignInVC {
    
    func setUpKeyboardNotifications(){
        
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(SwipehideKeyboard))
        view.addGestureRecognizer(dismissKeyboard)
        
    }
    
    @objc func SwipehideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
