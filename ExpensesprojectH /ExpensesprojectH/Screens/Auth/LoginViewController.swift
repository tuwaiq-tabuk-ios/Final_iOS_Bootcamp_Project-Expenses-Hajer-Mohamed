//
//  LoginViewController.swift
//  ExpensesprojectH
//
//  Created by hajer . on 16/05/1443 AH.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
  
  // MARK: -Properties
  
  var emailCheck = false
  var passwordCheck = false
  
  // MARK: - @IBOutlet
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var showPasswordButton: UIButton!
  
  // MARK: - View lifecycle
  
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
  
  
  @IBAction func loginPressed(_ sender: Any) {
    
    // Create cleaned versions of the text field
    
    if let email = emailTextField.text,
       email.isEmpty == false {
      emailCheck = true
    } else {
      emailCheck = false
      emailTextField.animateView()
    }
    
    if let password = passwordTextField.text,
       password.isEmpty == false {
      passwordCheck = true
    } else {
      passwordCheck = false
      passwordTextField.animateView()
    }
    
    if emailCheck == true, passwordCheck == true {
      // Signing in the user
      FSUserManager.shared.signInUser(email: emailTextField.text!,
                                      password: passwordTextField.text!,
                                      messageLabel: errorLabel) {
        
        let homeViewController = self.storyboard?.instantiateViewController(identifier: K.Storyboard.homeViewController)
        self.view.window?.rootViewController = homeViewController
        self.view.window?.makeKeyAndVisible()
      }
   
    }
   
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
}


