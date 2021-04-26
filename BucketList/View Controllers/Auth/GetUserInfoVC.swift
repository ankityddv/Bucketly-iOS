//
//  GetUserInfoVC.swift
//  BucketList
//
//  Created by ANKIT YADAV on 26/04/21.
//

import UIKit

class GetUserInfoVC: UIViewController {

    var selectedImage: UIImage?
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func upadateBttnDidTap(_ sender: Any) {
        Banner.shared.present(configurationHandler: { banner in
            banner.tintColor = UIColor(named: "greenAppColor")
            banner.title = "SUCCESS"
            banner.subtitle = """
            Updated your profile successfully 🥳
            Go ahead and create a work space
            """
            if #available(iOS 13.0, *) {
//                banner.icon = UIImage(systemName: "heart.fill")
            }
        }, dismissAfter: 1.5, in: view.window, feedbackStyle: .medium, pressHandler: {
//            self.newColor = ([
//                .red, .yellow, .blue, .green, .purple, .orange
//            ] as [UIColor]).randomElement()
            if #available(iOS 13.0, *) {
                self.view.window?.overrideUserInterfaceStyle = .dark
            } else {
                // Fallback on earlier versions
            }
        }, completionHandler: {
//            (sender as AnyObject).setTitle("Present again", for: .normal)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        let openPhotos = UITapGestureRecognizer(target: self, action: #selector(didTapCameraButton))
        profileImage.addGestureRecognizer(openPhotos)
        profileImage.isUserInteractionEnabled = true
    }
    @objc
    func didTapCameraButton(_ sender: Any) {
//        print("Open gallery")
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        present(pickerController, animated: true, completion: nil)
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

extension UIImage {
    var jpeg: Data? { jpegData(compressionQuality: 1) }  // QUALITY min = 0 / max = 1
    var png: Data? { pngData() }
}

extension Data {
    var uiImage: UIImage? { UIImage(data: self) }
}
