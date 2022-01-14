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
  
  // MARK: - @IBOutlet
  
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var errorLabel: UILabel!
  
  // MARK: View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpElements()
  }
  
    
  func setUpElements() {
    errorLabel.alpha = 0
    
    
    // MARK: - Style the elements
    
    Utilities.styleTextField(firstNameTextField)
    Utilities.styleTextField(lastNameTextField)
    Utilities.styleTextField(emailTextField)
    Utilities.styleTextField(passwordTextField)
    Utilities.styleFilledButton(signUpButton)
  }
  
  
  func validateFields() -> String? {
    
    if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
      
      return "Please fill in all fields.".localize()
    }
    
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    if Utilities.isPasswordValid(cleanedPassword) == false {
      return "Please make sure your password is at least 8 characters, contains a special character and a number.".localize()
    }
    
    return nil
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

  
  @IBAction func signUpPressed(_ sender: Any) {
    
    let error = validateFields()
    if error != nil {
      
      showError(error!)
    }
    else {
      
      let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
      
      Auth.auth().createUser(withEmail: email, password: password) { (AuthDataResult, error) in
        
        if error != nil {
          
          self.showError("Error creating user".localize())
        }
        else {
          let db = Firestore.firestore()
          db.collection("users").addDocument(data: ["firstname":firstName,
                                                    "lastname":lastName,
                                                    "uid": AuthDataResult!.user.uid ]) { (error) in
            
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
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}

