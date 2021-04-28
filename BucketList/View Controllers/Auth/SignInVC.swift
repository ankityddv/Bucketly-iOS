//
//  SignInVC.swift
//  BucketList
//
//  Created by ANKIT YADAV on 24/04/21.
//

import Hero
import UIKit

class SignInVC: UIViewController {
    
    
    //MARK:- @IBOutlet
    @IBOutlet weak var emailTextField: TDCtextField!
    @IBOutlet weak var passwordTextField: TDCtextField!
    @IBOutlet weak var signInBttn: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    
    //MARK:- @IBAction
    @IBAction func forgotPasswordDidTap(_ sender: Any) {
        lightImpactHeptic()
        let vc = self.storyboard?.instantiateViewController(identifier: "ResetPasswordVC") as! ResetPasswordVC
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func signInBttnDidTap(_ sender: Any) {
    }
    @IBAction func signUpBttnDidTap(_ sender: Any) {
        lightImpactHeptic()
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signInBttn.hero.id = "bttn"
        self.hero.isEnabled = true
        setUpKeyboardNotifications()
    }
}

//MARK:- ⌨️ keyboard notifications
extension SignInVC {
    
    func setUpKeyboardNotifications(){
        
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(swipeHideKeyboard))
        view.addGestureRecognizer(dismissKeyboard)
        
    }
    
    @objc func swipeHideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//MARK:- 🔐 Textfield delegate
extension SignInVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
            textField.layer.borderWidth = 2
            textField.backgroundColor = getColor(color: .black)
            textField.layer.borderColor = getColor(color: .neonGreen).cgColor
        } else if textField == passwordTextField {
            textField.layer.borderWidth = 2
            textField.backgroundColor = getColor(color: .black)
            textField.layer.borderColor = getColor(color: .neonGreen).cgColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.backgroundColor = getColor(color: .textFieldBg)
        textField.layer.borderColor = getColor(color: .clear).cgColor
    }
}
