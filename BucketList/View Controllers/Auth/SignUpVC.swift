//
//  SignUpVC.swift
//  BucketList
//
//  Created by ANKIT YADAV on 24/04/21.
//

import Hero
import UIKit
import AuthenticationServices

protocol LoginViewControllerDelegate {
    
    func didFinishAuth()
}

class SignUpVC: UIViewController {

    var delegate: LoginViewControllerDelegate?
    
    //MARK:- @IBOutlet
    @IBOutlet weak var appleButtonView: UIView!
    @IBOutlet weak var usernameTextField: TDCtextField!
    @IBOutlet weak var emailTextField: TDCtextField!
    @IBOutlet weak var passwordTextField: TDCtextField!
    @IBOutlet weak var signUpBttn: UIButton!
    
    //MARK:- @IBAction
    @IBAction func signUpBttnDidTap(_ sender: Any) {
    }
    @IBAction func signInBttnDidTap(_ sender: Any) {
        lightImpactHeptic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

//MARK:- 🔐 Handle Sign In
extension SignUpVC: ASAuthorizationControllerDelegate {
    
    private func registerNewAccount(credential: ASAuthorizationAppleIDCredential) {
        print("Registering new account with user: \(credential.user)")
        delegate?.didFinishAuth()
//        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
//        appleButtonView.hero.id = HeroIDs.buttonKey
//        self.present(vc, animated: true, completion: nil)
        userDefaults?.set(0, forKey: "onboardingState")
    }
    
    private func signInWithExistingAccount(credential: ASAuthorizationAppleIDCredential) {
        print("Signing in with existing account with user: \(credential.user)")
        delegate?.didFinishAuth()
//        let vc = storyboard?.instantiateViewController(withIdentifier: VCIdentifierManager.dashboardKey) as! DashboardVC
//        appleButtonView.hero.id = HeroIDs.buttonKey
//        self.present(vc, animated: true, completion: nil)
        userDefaults?.set(0, forKey: "onboardingState")
    }
    
    private func signInWithUserAndPassword(credential: ASAuthorizationAppleIDCredential) {
        print("Signing in using an existing icloud Keychain credential with user:: \(credential.user)")
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
        print("Something bad happened")
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
//        print("Tapped")
    }
    
}

//MARK:- ⌨️ keyboard notifications
extension SignUpVC {
    
    func setUpKeyboardNotifications(){
        
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
