//
//  SignUpVC.swift
//  BucketList
//
//  Created by ANKIT YADAV on 24/04/21.
//

import Hero
import UIKit
import Firebase
import AuthenticationServices

protocol LoginViewControllerDelegate {
    func didFinishAuth()
}

class SignUpVC: UIViewController {

    var delegate: LoginViewControllerDelegate?
    let spinner = SpinnerView()
    let spinnerLabel = UILabel()
    
    //MARK:- @IBOutlet
    @IBOutlet weak var appleButtonView: UIView!
    @IBOutlet weak var usernameTextField: TDCtextField!
    @IBOutlet weak var emailTextField: TDCtextField!
    @IBOutlet weak var passwordTextField: TDCtextField!
    @IBOutlet weak var signUpBttn: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerView2: UIView!
    
    //MARK:- @IBAction
    @IBAction func signUpBttnDidTap(_ sender: Any) {
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if username?.isEmpty != true && email?.isEmpty != true && password?.isEmpty != true {
            if password!.count < 6 && password!.count >= 1 {
                // display error
                self.presentBanner("Password must be greater than 6 characters!", .error)
                errorHaptic()
            } else {
                // create new user
                Auth.auth().createUser(withEmail: email!, password: password!){ [self] (user, error) in
                    if error == nil {
                        /// registered new user now `save` the info to database
                        let uid = Auth.auth().currentUser!.uid
                        let values = ["username": username!,"email": email!]
                        
                        Database.database().reference().child("Users").child("\(uid)").updateChildValues(values) {
                         (error:Error?, ref:DatabaseReference) in
                            if let error = error {
                                self.presentBanner("\(error)", .error)
                            } else {
                                print("Data saved successfully!")
                            }
                        }
                        let vc =  self.storyboard!.instantiateViewController(withIdentifier: "GetUserInfoVC") as! GetUserInfoVC
                        self.present(vc, animated: true, completion: nil)
                    }
                    else {
                        /// if any error occur during creating a user present banner
                        self.presentBanner("Couldn't sign you in, please contact us!", .error)
                        stopLoader()
                    }
                }
            startLoader()
            }
        } else {
            self.presentBanner("Couldn't sign you in, please contact us!", .error)
        }
    }
    @IBAction func signInBttnDidTap(_ sender: Any) {
        lightImpactHaptic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

//MARK:- 🔐 Handle Sign In
extension SignUpVC: ASAuthorizationControllerDelegate {
    
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
//        print("Registering new account with user: \(credential.user)")
        delegate?.didFinishAuth()
//        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
//        appleButtonView.hero.id = HeroIDs.buttonKey
//        self.present(vc, animated: true, completion: nil)
        userDefaults?.set(0, forKey: "onboardingState")
    }
    
    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
//        print("Signing in with existing account with user: \(credential.user)")
        delegate?.didFinishAuth()
//        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
//        appleButtonView.hero.id = HeroIDs.buttonKey
//        self.present(vc, animated: true, completion: nil)
        userDefaults?.set(0, forKey: "onboardingState")
    }
    
    private func signInWithUserAndPassword(credential: ASAuthorizationAppleIDCredential) {
//        print("Signing in using an existing icloud Keychain credential with user:: \(credential.user)")
        delegate?.didFinishAuth()
//        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
//        appleButtonView.hero.id = HeroIDs.buttonKey
//        self.present(vc, animated: true, completion: nil)
        userDefaults?.set(0, forKey: "onboardingState")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        case let appleIdCredentials as ASAuthorizationAppleIDCredential:
            let userId = appleIdCredentials.user
            let userFirstName = appleIdCredentials.fullName?.givenName
            let userEmail = appleIdCredentials.email
            
            userDefaults?.set(userId, forKey: SignInWithAppleManager.userIdentifierKey)
            userDefaults?.set(userFirstName, forKey: SignInWithAppleManager.userFirstNameKey)
            userDefaults?.set(userEmail, forKey: SignInWithAppleManager.userEmailKey)

            if let _ = appleIdCredentials.email, let _ = appleIdCredentials.fullName {
                registerNewAccount(credential: appleIdCredentials)
            } else {
                signInWithExistingAccount(credential: appleIdCredentials)
            }
            break
            
        case _ as ASPasswordCredential:
//            let userId = passwordCredential.user
//            userDefaults?.set(userId, forKey: SignInWithAppleManager.userIdentifierKey)
//            signInWithUserAndPassword(credential: passwordCredential)
            break
        default:
            break
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        print("Something bad happened")
    }
    
    
}
extension SignUpVC: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
}

//MARK:- 🤡 functions()
extension SignUpVC {
    func configure() {
        let appleButton = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        appleButton.frame = CGRect(x: 0, y: 0, width: 354, height: 45)
        appleButton.dropShadow(color: .black, opacity: 0.1 , offSet: CGSize(width: 0.4, height: 0.4),radius: 10)
        
        appleButtonView.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerYAnchor.constraint(equalTo: appleButtonView.centerYAnchor),
            appleButton.leadingAnchor.constraint(equalTo: appleButtonView.leadingAnchor, constant: 0),
            appleButton.trailingAnchor.constraint(equalTo: appleButtonView.trailingAnchor, constant: 0),
            appleButton.heightAnchor.constraint(equalTo: appleButtonView.heightAnchor, multiplier: 0.6)
        ])
        
        self.isModalInPresentation = true
        
        signUpBttn.hero.id = "bttn"
        setUpKeyboardNotifications()
    }
    @objc
    func didTapAppleButton() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName,.email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
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

//MARK:- ⌨️ keyboard notifications
extension SignUpVC {
    func setUpKeyboardNotifications() {
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(swipeHideKeyboard))
        view.addGestureRecognizer(dismissKeyboard)
    }
    @objc func swipeHideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//MARK:- 🔐 Textfield delegate
extension SignUpVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == usernameTextField {
            textField.layer.borderWidth = 2
            textField.backgroundColor = getColor(color: .black)
            textField.layer.borderColor = getColor(color: .neonGreen).cgColor
        } else if textField == emailTextField {
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
