//
//  FSUserManager.swift
//  
//
//  Created by hajer . on 15/06/1443 AH.
//

import UIKit
import Firebase

class FSUserManager {
  
  static var shared = FSUserManager()
  
  // MARK: - Register
  
  func signUpUserWith(firstName: String,
                      lastName: String,
                      email: String,
                      password: String,
                      messageLabel : UILabel,
                      completion : @escaping ()->()) {
    
    Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
      
      
      if err != nil {
        self.showError("Error creating user , try again!".localize(),
                       messageLabel: messageLabel)
      }
      else {
        
        let db = Firestore.firestore()
        
        db.collection(FSCollectionReference.users.rawValue).addDocument(data: ["firstname": firstName, "lastname": lastName, "uid": result!.user.uid, "email" : email]) { (error) in
          
          if error != nil {
            
            self.showError("Error saving user data , try again!".localize(), messageLabel: messageLabel)
          }
        }
        completion()
      }
    }
  }
  
  // MARK: - method signInUser
  
  func signInUser(email: String,
                  password: String,
                  messageLabel : UILabel,
                  completion : @escaping ()->()) {
    
    Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
      if error != nil {
        // Couldn't sign in
        messageLabel.text = error!.localizedDescription
        messageLabel.alpha = 1
      }
      else {
        completion()
      }
    }
  }
  
  
  // MARK: - method showError
  
  func showError(_ message:String, messageLabel : UILabel) {
    messageLabel.text = message
    messageLabel.alpha = 1
  }
  
}
