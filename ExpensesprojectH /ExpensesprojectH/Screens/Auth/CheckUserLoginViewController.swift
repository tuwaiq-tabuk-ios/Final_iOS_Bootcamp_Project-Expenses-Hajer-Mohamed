//
//  CheckUserLoginViewController.swift
//  ExpensesprojectH
//
//  Created by hajer . on 01/06/1443 AH.
//


import UIKit
import Firebase

class CheckUserLoginViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    if Auth.auth().currentUser?.uid == nil {
      
      // go to signIn
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "signInVC")
      vc?.modalPresentationStyle = .fullScreen
      vc?.modalTransitionStyle = .crossDissolve
      DispatchQueue.main.async {
        self.present(vc!, animated: true, completion: nil)
      }
    } else {
      
      // go to HomeVC
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC")
      vc?.modalPresentationStyle = .fullScreen
      vc?.modalTransitionStyle = .crossDissolve
      DispatchQueue.main.async {
        self.present(vc!, animated: true, completion: nil)
      }
    }
  }
}
