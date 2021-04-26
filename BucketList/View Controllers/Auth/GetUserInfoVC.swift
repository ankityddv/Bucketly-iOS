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
    
    
    @objc
    func didTapCameraButton(_ sender: Any) {
        print("Open gallery")
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.delegate = (self as UIImagePickerControllerDelegate & UINavigationControllerDelegate)
        present(pickerController, animated: true, completion: nil)
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
