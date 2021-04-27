//
//  GetUserInfoVC.swift
//  BucketList
//
//  Created by ANKIT YADAV on 26/04/21.
//

import UIKit

class GetUserInfoVC: UIViewController {

    let spinner = SpinnerView()
    let spinnerLabel = UILabel()
    var selectedImage: UIImage?
    
    //MARK:- @IBOutlet
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullNameTextField: TDCtextField!
    @IBOutlet weak var updateBttn: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    //MARK:- @IBAction
    @IBAction func upadateBttnDidTap(_ sender: Any) {
        
        
        if self.fullNameTextField.text!.isEmpty {
            /**
             To display the top`banner`in the view.
             */
            Banner.shared.present(configurationHandler: { banner in
                banner.tintColor = getBannerDetails(state: .warning).0
                banner.title = getBannerDetails(state: .warning).1
                banner.subtitle = """
                Full name field is empty
                Please enter your full name
                """
            }, dismissAfter: 1, in: self.view.window, feedbackStyle: .medium, pressHandler: {
                self.view.window?.overrideUserInterfaceStyle = .dark
            })
        } else {
            Banner.shared.present(configurationHandler: { banner in
                banner.tintColor = getBannerDetails(state: .success).0
                banner.title = getBannerDetails(state: .success).1
                banner.subtitle = """
                Updated your profile successfully 🥳
                Go ahead and create a work space
                """
    //            banner.icon = UIImage(systemName: "heart.fill")
            }, dismissAfter: 1, in: view.window, feedbackStyle: .medium, pressHandler: {
                /*
                self.newColor = ([
                    .red, .yellow, .blue, .green, .purple, .orange
                ] as [UIColor]).randomElement()
                 */
                self.view.window?.overrideUserInterfaceStyle = .dark
            }, completionHandler: {
                /**
                 To `hide`the containerView and display `spinner` in the view
                 */
                self.swipeHideKeyboard()
                
                self.containerView.alpha = 1
                UIView.transition(with: self.containerView, duration: 0.4,
                                  options: .curveEaseInOut,
                                  animations: {
                                    self.containerView.alpha = 0
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
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        let openPhotos = UITapGestureRecognizer(target: self, action: #selector(didTapCameraButton))
        profileImage.addGestureRecognizer(openPhotos)
        profileImage.isUserInteractionEnabled = true
        setUpKeyboardNotifications()
    }
    @objc
    func didTapCameraButton(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        present(pickerController, animated: true, completion: nil)
    }
    
}

//MARK:- 🔐 Textfield delegate
extension GetUserInfoVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == fullNameTextField {
            textField.layer.borderWidth = 2
            textField.backgroundColor = getColor(color: .black)
            textField.layer.borderColor = getColor(color: .appColor).cgColor
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
        textField.backgroundColor = getColor(color: .textFieldBg)
        textField.layer.borderColor = getColor(color: .clear).cgColor
    }
}

// Image picker Extension
extension GetUserInfoVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            selectedImage = image
            profileImage.image = image
//            let pngImage = image.png
//            userDefaults?.set(pngImage, forKey: SignInWithAppleManager.userProfileImageKey)
        }
        dismiss(animated: true, completion: nil)
    }
}

//MARK:- ⌨️ keyboard notifications
extension GetUserInfoVC {
    
    func setUpKeyboardNotifications(){
        
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(swipeHideKeyboard))
        view.addGestureRecognizer(dismissKeyboard)
        
    }
    
    @objc func swipeHideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

extension UIImage {
    var jpeg: Data? { jpegData(compressionQuality: 1) }  // QUALITY min = 0 / max = 1
    var png: Data? { pngData() }
}

extension Data {
    var uiImage: UIImage? { UIImage(data: self) }
}

