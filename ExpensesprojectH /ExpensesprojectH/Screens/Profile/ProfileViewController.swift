//
//  ProfileViewController.swift
//  ExpensesprojectH
//
//  Created by hajer . on 30/05/1443 AH.
//

import UIKit
import Firebase
import MessageUI

class ProfileViewController: UIViewController,MFMailComposeViewControllerDelegate{
  
  let db = Firestore.firestore().collection("users")

  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var emailLabel: UILabel!
  
    override func viewDidLoad() {
    super.viewDidLoad()
    
    nameLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
    emailLabel.transform = CGAffineTransform(scaleX: 0, y: 0)
    getUserProfile()
  }
  
  func getUserProfile() {
    guard let userID = Auth.auth().currentUser?.uid else {return}
    
    db.whereField("uid", isEqualTo: userID).getDocuments { snapshot, error in
      if let value = snapshot?.documents {
        for user in value {
          let data = user.data()
          print(data)
          let firstName = data["firstname"] as? String
          let lastName = data["lastname"] as? String
          self.nameLabel.text = "\(firstName ?? "??") \(lastName ?? "??")"
          self.emailLabel.text = data["email"] as? String
          UIView.animate(withDuration: 0.5) {
            self.nameLabel.transform = .identity
            self.emailLabel.transform = .identity
          }
        }
      }
    }
  }
  // MARK: - @IBAction

  @IBAction func signoutAction(_ sender: UIButton) {
    try? Auth.auth().signOut()
    
    let vc = storyboard?.instantiateViewController(withIdentifier: "signInVC")
    vc?.modalTransitionStyle = .crossDissolve
    vc?.modalPresentationStyle = .fullScreen
    self.present(vc!, animated: true, completion: nil)
    
  }
  
  
  @IBAction func twitterButtonAction(_ sender: UIButton) {
    let twitterUsername = "expenHh"
    let appURL = URL(string: "twitter://user?screen_name=\(twitterUsername)")!
    let webURL = URL(string: "https://twitter.com/\(twitterUsername)")!
    
    if UIApplication.shared.canOpenURL(appURL as URL) {
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(appURL)
      } else {
        UIApplication.shared.openURL(appURL)
      }
    } else {
      
      //redirect to safari because the user doesn't have twitter
      if #available(iOS 10.0, *) {
        UIApplication.shared.open(webURL)
      } else {
        UIApplication.shared.openURL(webURL)
      }
    }
  }
  
  
  @IBAction func emailButtonAction(_ sender: UIButton) {
    
    let mailComposeViewController = configureMailComposer()
    if MFMailComposeViewController.canSendMail(){
      self.present(mailComposeViewController, animated: true, completion: nil)
    }
    else{
      // IMPORTANT:- email not working in simulator
      
      print("Can't send email \n EMAIL COMPOSER NOT WORKING IN SIMULATOR")
    }
  }
  
  func configureMailComposer() -> MFMailComposeViewController{
    let mailComposeVC = MFMailComposeViewController()
    mailComposeVC.mailComposeDelegate = self
    mailComposeVC.setToRecipients(["expenses.exe@gmail.com"])
    return mailComposeVC
  }
  
  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    controller.dismiss(animated: true)
  }
  
}
