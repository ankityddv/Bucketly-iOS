//
//  SettingsTViewController.swift
//  Bucketly
//
//  Created by ANKIT YADAV on 02/06/21.
//

import UIKit
import Firebase
import MessageUI

class SettingsViewController: UITableViewController {

    //MARK:- IBOutlet
    @IBOutlet weak var profileBttn: UIButton!
    @IBOutlet weak var optionsBttn: UIButton!
    
    //MARK:- IBAction
    @IBAction func profileBttnDidTap(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: ViewControllers.profile) as! ProfileViewController
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func optionsBttnDidTap(_ sender: Any) {
        let first = UIAction(title: "Default") { [self] _ in
            
        }
        
        let menu = UIMenu(title: "", children: [first])
        optionsBttn.showsMenuAsPrimaryAction = true
        optionsBttn.menu = menu
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureFuncs()
    }
    override func viewWillAppear(_ animated: Bool) {
        lightImpactHaptic()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 2
        case 1:
            return 4
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 20, y: 8, width: 320, height: 20)
        let titleStr = self.tableView(tableView, titleForHeaderInSection: section)
        myLabel.text = titleStr
        myLabel.font = UIFont(name: Fonts.extraBold, size: 12) ?? UIFont.systemFont(ofSize: 18)
        myLabel.textColor = UIColor.gray
        let headerView = UIView()
        headerView.backgroundColor = UIColor.black
        headerView.addSubview(myLabel)
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 1:
                do {
                    try Auth.auth().signOut()
                    "0".saveToUserDefaults(forKey: UserDefaultsManager.login)
                } catch {
                    print("Sign out failed")
                }
                
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                print("Terms")
            case 2:
                tellAFriend()
            case 3:
                writeReview()
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                reportABug()
            default:
                break
            }
        default:
            break
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension SettingsViewController {
    func configureFuncs() {
        configureNavBar()
    }
    func configureNavBar() {
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        self.navigationController?.navigationBar.layer.masksToBounds = false
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
    func tellAFriend() {
        //let message1 = "Download Dinero App to manage your online subscriptions."
        //let image = UIImage(named: "default")
        let myWebsite = NSURL(string:"https://apps.apple.com/us/app/dinero-subscription-manager/id1545370811")
        let shareAll = [myWebsite as Any] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    func writeReview(){
        let url = URL(string: "https://apps.apple.com/us/app/dinero-subscription-manager/id1545370811")
            
        var components = URLComponents(url: url!, resolvingAgainstBaseURL: false)

        components?.queryItems = [
            URLQueryItem(name: "action", value: "write-review")
        ]
        guard let writeReviewURL = components?.url else {
            return
        }
        UIApplication.shared.open(writeReviewURL)
    }
    func reportABug() {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["yadavankit840@gmail.com"])
        composer.setSubject("Support!")
        composer.setMessageBody("Hey, I found this bug in app which ...", isHTML: false)
        present(composer, animated: true)
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            controller.dismiss(animated: true)
        }
        switch result {
        case .cancelled:
            break
        case .failed:
            presentBanner("Can't send email at the moment", .error)
        case .saved:
            presentBanner("Saved to the draft", .success)
        case .sent:
            presentBanner("Email Sent", .success)
        @unknown default:
            fatalError()
        }
        controller.dismiss(animated: true)
    }
    
}
