//
//  SignInVC.swift
//  BucketList
//
//  Created by ANKIT YADAV on 24/04/21.
//

import Hero
import UIKit
import Firebase

class SignInVC: UIViewController {
    
    let spinner = SpinnerView()
    let spinnerLabel = UILabel()
    
    //MARK:- @IBOutlet
    @IBOutlet weak var emailTextField: TDCtextField!
    @IBOutlet weak var passwordTextField: TDCtextField!
    @IBOutlet weak var signInBttn: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerView2: UIView!
    
    //MARK:- @IBAction
    @IBAction func forgotPasswordDidTap(_ sender: Any) {
        lightImpactHaptic()
        let vc = self.storyboard?.instantiateViewController(identifier: ViewControllers.resetPassword) as! ResetPasswordVC
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func signInBttnDidTap(_ sender: Any) {
        loginUser()
    }
    @IBAction func signUpBttnDidTap(_ sender: Any) {
        lightImpactHaptic()
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

//MARK:- 🤡 functions()
extension SignInVC {
    func loginUser() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
            
        if email.count == 0 && password.count == 0 {
            self.presentBanner("Please enter the email and password!", .error, {
                                print("Working now")})
        }
        else {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil{
                    self.performSegue(withIdentifier: SegueManager.signIn, sender: self)
                    userDefaults?.set("1", forKey: UserDefaultsManager.login)
                }
                else {
                    self.presentBanner(error!.localizedDescription, .error)
                }
                self.stopLoader()
            }
            startLoader()
        }
    }
    func startLoader() {
        self.containerView.alpha = 1
        UIView.transition(with: self.containerView, duration: 0.4,
                          options: .curveEaseInOut,
                          animations: {
                            self.containerView.alpha = 0
                      })
        self.containerView2.alpha = 1
        UIView.transition(with: self.containerView2, duration: 0.4,
                          options: .curveEaseInOut,
                          animations: {
                            self.containerView2.alpha = 0
                      })
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2, execute: {
            self.spinnerLabel.attributedText = NSMutableAttributedString()
                .bold14("LOGGING YOU IN...")
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
        containerView2.alpha = 0
        UIView.transition(with: self.containerView, duration: 0.4,
                          options: .curveEaseInOut,
                          animations: {
                            self.containerView.alpha = 1
                            self.containerView2.alpha = 1
                      })
        self.spinner.removeFromSuperview()
        self.spinnerLabel.removeFromSuperview()
    }
    func presentBanner(_ subtitle: String,_ state: BannerState, _ void: (() -> Void)? = nil) {
        Banner.shared.present(configurationHandler: { banner in
            banner.tintColor = getBannerDetails(state: state).0
            banner.title = getBannerDetails(state: state).1
            banner.subtitle = """
            \(subtitle)
            """
        }, dismissAfter: 1, in: self.view.window, feedbackStyle: .medium, pressHandler: {
            self.view.window?.overrideUserInterfaceStyle = .dark
        }, completionHandler: void)
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
