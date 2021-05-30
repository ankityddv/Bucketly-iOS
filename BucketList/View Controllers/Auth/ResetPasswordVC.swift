//
//  ResetPasswordVC.swift
//  Bucketly
//
//  Created by ANKIT YADAV on 28/04/21.
//

import Hero
import UIKit
import Firebase

class ResetPasswordVC: UIViewController {

    let spinner = SpinnerView()
    let spinnerLabel = UILabel()
    
    //MARK:- @IBOutlet
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var emailSentSuccessFullyView: UIView!
    @IBOutlet weak var emailTextField: TDCtextField!
    @IBOutlet weak var resetPasswordBttn: UIButton!
    @IBOutlet weak var dismissBttn: UIButton!
    @IBOutlet weak var emailSentMessage: UILabel!
    
    //MARK:- @IBAction
    @IBAction func dismissBttnDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func resetPasswordBttnDidTap(_ sender: Any) {
        self.swipeHideKeyboard()
        if self.emailTextField.text!.isEmpty {
            presentBanner("Email field is empty \nPlease enter your email", .warning)
        } else {
            resetUserPassword()
            showLoader()
        }
        
    }
    @IBAction func openMailBttnDidTap(_ sender: Any) {
        let mailURL = URL(string: "message://")!
        if UIApplication.shared.canOpenURL(mailURL) {
            UIApplication.shared.open(mailURL, options: [:], completionHandler: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpKeyboardNotifications()
        dismissBttn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        resetPasswordBttn.hero.id = "bttn"
        self.hero.isEnabled = true
    }
    
}

//MARK:- 🔐 Textfield delegate
extension ResetPasswordVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextField {
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

//MARK:- ⌨️ keyboard notifications
extension ResetPasswordVC {
    
    func setUpKeyboardNotifications() {
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(swipeHideKeyboard))
        view.addGestureRecognizer(dismissKeyboard)
    }
    @objc func swipeHideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    func resetUserPassword() {
        let email = emailTextField.text!
        if email == "" {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        
        } else {
            Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                if error != nil {
                    self.presentBanner((error!.localizedDescription as String), .error, {
                                        self.stopLoader()})
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                        self.presentBanner("We've sent you an email with reset \npassword link. Check you mail 📮", .success, {
                            self.emailSentSuccessFullyView.alpha = 0
                            UIView.transition(with: self.containerView, duration: 0.4,
                                              options: .curveEaseInOut,
                                              animations: {
                                                self.emailSentMessage.attributedText = NSMutableAttributedString()
                                                    .regular14("Please go to your ")
                                                    .bold14White("\(self.emailTextField.text!) ")
                                                    .regular14(
                                                    """
                                                    email and click the password reset link for yout Bucketly account.

                                                    It could take a few minutes to appear, and be sure to check any spam and promotional folders-just in case!
                                                    """)
                                                self.emailSentSuccessFullyView.center = CGPoint(x: self.view.frame.size.width  / 2, y: self.view.frame.size.height / 2)
                                                self.view.addSubview(self.emailSentSuccessFullyView)
                                                self.emailSentSuccessFullyView.alpha = 1
                                          })
                            self.forgotPasswordView.removeFromSuperview()
                            self.spinner.removeFromSuperview()
                            self.spinnerLabel.removeFromSuperview()
                        })
                    })
                }
            })
        }
    }
    
    func showLoader() {
        /**
         To `hide`the containerView and display `spinner` in the view
         */
        self.containerView.alpha = 1
        UIView.transition(with: self.containerView, duration: 0.4,
                          options: .curveEaseInOut,
                          animations: {
                            self.containerView.alpha = 0
                      })
        self.spinnerLabel.attributedText = NSMutableAttributedString()
            .bold14("LOOKING FOR YOU ...")
        self.spinnerLabel.frame = CGRect(x: self.view.frame.size.width  / 2, y: self.view.frame.size.height / 2, width: 150, height: 40)
        self.spinnerLabel.center.x = self.view.center.x
        self.spinnerLabel.center.y = self.view.center.y + 20
        self.spinnerLabel.textAlignment = .center
        
        self.spinner.frame = CGRect(x: self.view.frame.size.width  / 2, y: self.view.frame.size.height / 2, width: 30, height: 30)
        self.spinner.center = CGPoint(x: self.view.frame.size.width  / 2, y: (self.view.frame.size.height / 2)-20)
        self.view.addSubview(self.spinnerLabel)
        self.view.addSubview(self.spinner)
        self.spinner.animate()
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
