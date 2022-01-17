//
//  SingUpViewController.swift
//  ExpensesprojectH
//
//  Created by hajer . on 16/05/1443 AH.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController {
  
  var firstNameCheck = false
  var lastNameCheck = false
  var emailCheck = false
  var passwordCheck = false
  var repeatPasswordCheck = false
  
  // MARK: - @IBOutlet
  
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  @IBOutlet weak var repeatPasswordTextField: UITextField!
  @IBOutlet weak var showPasswordButton: UIButton!
  @IBOutlet weak var showRepeatPasswordButton: UIButton!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpElements()
  }
  // MARK: -  setUpElements
  func setUpElements() {
    
    errorLabel.alpha = 0
    
    Utilities.styleTextField(firstNameTextField)
    Utilities.styleTextField(lastNameTextField)
    Utilities.styleTextField(emailTextField)
    Utilities.styleTextField(passwordTextField)
    Utilities.styleTextField(repeatPasswordTextField)
    Utilities.styleFilledButton(signUpButton)
  }
  
  
  func validateFields() -> String? {
    
    if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      
      return "Please fill in all fields.".localize()
    }
    
    
    let cleanedPassword = passwordTextField
      .text!
      .trimmingCharacters(in: .whitespacesAndNewlines)
    
    if Utilities.isPasswordValid(cleanedPassword) == false {
      return "Please make sure your password is at least 8 characters, contains a special character and a number.".localize()
    }
    
    return nil
  }
  
  var passworsIsAppear = false
  
  @IBAction func showSecurePassword(_ sender: UIButton) {
    
    if passworsIsAppear == false {
      passwordTextField.isSecureTextEntry = false
      showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
    } else {
      passwordTextField.isSecureTextEntry = true
      showPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    
    passworsIsAppear.toggle()
  }
  
  
  var repeatPassworsIsAppear = false
  @IBAction func showSecureRepeatPassword(_ sender: Any) {
    if repeatPassworsIsAppear == false {
      repeatPasswordTextField.isSecureTextEntry = false
      showRepeatPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
    } else {
      repeatPasswordTextField.isSecureTextEntry = true
      showRepeatPasswordButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
    }
    
    repeatPassworsIsAppear.toggle()
  }
  
  
  
  @IBAction func signUpTapped(_ sender: Any) {
    
    if let firstName = firstNameTextField.text, firstName.isEmpty == false {
      firstNameCheck = true
    } else {
      firstNameCheck = false
      firstNameTextField.animateView()
    }
    
    if let lastName = lastNameTextField.text, lastName.isEmpty == false {
      lastNameCheck = true
    } else {
      lastNameCheck = false
      lastNameTextField.animateView()
    }
    
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
    
    if let repeatPassword = repeatPasswordTextField.text, repeatPassword.isEmpty == false {
      repeatPasswordCheck = true
    } else {
      repeatPasswordCheck = false
      repeatPasswordTextField.animateView()
    }
    
    if firstNameCheck == true, lastNameCheck == true, emailCheck == true, passwordCheck == true, repeatPasswordCheck == true {
      if passwordTextField.text != repeatPasswordTextField.text {
        errorLabel.alpha = 1
        errorLabel.text = "not exact password, try again!!"
        return
      }
      
      
      
      Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (result, err) in
        
        
        if err != nil {
          
          self.showError("Error creating user".localize())
        }
        else {
          
          let db = Firestore.firestore()
          
          db.collection("users").addDocument(data: ["firstname":self.firstNameTextField.text!, "lastname":self.lastNameTextField.text!, "uid": result!.user.uid, "email" : self.emailTextField.text! ]) { (error) in
            
            if error != nil {
              self.showError("Error saving user data".localize())
            }
          }
          self.transitionToHome()
        }
      }
    }
    
  }
  
  func showError(_ message:String) {
    errorLabel.text = message
    errorLabel.alpha = 1
  }
  
  
  func transitionToHome() {
    
    let homeViewController = storyboard?.instantiateViewController(identifier: K.Storyboard.homeViewController)
    
    view.window?.rootViewController = homeViewController
    view.window?.makeKeyAndVisible()
    
  }
}

