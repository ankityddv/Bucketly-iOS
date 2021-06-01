//
//  SettingsViewController.swift
//  Bucketly
//
//  Created by ANKIT YADAV on 31/05/21.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var profileBttn: UIButton!
    @IBOutlet weak var optionsBttn: UIButton!
    
    //MARK:- IBAction
    @IBAction func profileBttnDidTap(_ sender: Any) {
    }
    @IBAction func optionsBttnDidTap(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFuncs()
    }
    override func viewWillAppear(_ animated: Bool) {
        lightImpactHaptic()
    }

}

extension SettingsViewController {
    func configureFuncs() {
        configureNavBar()
        // set the theme to dark for app
        UIApplication.shared.windows.forEach { window in
            window.overrideUserInterfaceStyle = .dark
        }
    }
    
    func configureNavBar() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.layer.masksToBounds = false
    }
}
