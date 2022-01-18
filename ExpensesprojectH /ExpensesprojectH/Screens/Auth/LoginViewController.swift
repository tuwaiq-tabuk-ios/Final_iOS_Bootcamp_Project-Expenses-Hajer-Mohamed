//
//  LoginViewController.swift
//  ExpensesprojectH
//
//  Created by hajer . on 16/05/1443 AH.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
  
  // MARK: - @IBOutlet
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var showPasswordButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpElements()
  }
  
  // MARK: - setUpElements
  
  func setUpElements() {
    errorLabel.alpha = 0
    
    Utilities.styleTextField(emailTextField)
    Utilities.styleTextField(passwordTextField)
    Utilities.styleFilledButton(loginButton)
  }
  
  // MARK: - @IBAction
  
  var passworsIsAppear = false
  @IBAction func showSecurePassword(_ sender: UIButton) {
    if passworsIsAppear == false {
      passwordTextField.isSecureTextEntry = false
      showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    } else {
      passwordTextField.isSecureTextEntry = true
      showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
    }
    
    passworsIsAppear.toggle()
  }
  
  var emailCheck = false
  var passwordCheck = false
  
  @IBAction func loginPressed(_ sender: Any) {

    if let email = emailTextField.text, email.isEmpty == false {
        emailCheck = true
    } else {
        emailCheck = false
        emailTextField.animateView()
    }
    
    if let password = passwordTextField.text, password.isEmpty == false {
        passwordCheck = true
    } else {
        passwordCheck = false
        passwordTextField.animateView()
    }
    
    if emailCheck == true, passwordCheck == true {
        Auth.auth().signIn(withEmail: emailTextField.text!,
                           password: passwordTextField.text!)
      { (result, error) in
            
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                let homeViewController = self.storyboard?.instantiateViewController(identifier: K.Storyboard.homeViewController)
                
                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
}
}



