//
//  LoginViewController.swift
//  ExpensesprojectH
//
//  Created by hajer . on 16/05/1443 AH.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var loginButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpElements()
  }
  
  
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
      } else {
          passwordTextField.isSecureTextEntry = true
      }
      
      passworsIsAppear.toggle()
  }
  @IBAction func loginPressed(_ sender: Any) {
    
    
    let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      
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
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}


