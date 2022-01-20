//
//  DescribeVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 19/05/1443 AH.
//

import UIKit
import Firebase

class AddNewPurchaseVC: UIViewController {
  
  let db = Firestore.firestore()
  var totalAmount = 0
  
  // MARK: - @IBOutlet
  
  @IBOutlet weak var descriptionTextView: UITextView!
  @IBOutlet weak var amountTextField: UITextField!
  @IBOutlet weak var addNewPurchaseButton: UIButton!
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
// MARK: -Method setupUI
  
  func setupUI() {
    descriptionTextView.layer.borderWidth = 1
    descriptionTextView.layer.borderColor = UIColor.gray.cgColor
    descriptionTextView.layer.cornerRadius = 8
    descriptionTextView.clipsToBounds = true
    
    amountTextField.layer.borderWidth = 1
    amountTextField.layer.borderColor = UIColor.white.cgColor
    amountTextField.layer.cornerRadius = 8
    amountTextField.clipsToBounds = true
    
    Utilities.styleFilledButton(addNewPurchaseButton)
    
  }
  
  // MARK: - @IBAction
  
  @IBAction func addNewPurchase(_ sender: UIButton) {
    
    guard let amount = amountTextField.text,
          !amount.isEmpty else {
      UIHelper.makeToast(text: "Please Enter Purchase Amount".localize())
      return
    }
    
    guard let description = descriptionTextView.text,
          !description.isEmpty else {
      UIHelper.makeToast(text: "Please Enter Purchase Description".localize())
      return
    }
    self.addNewItem(amount: amount, purchaseDescription: description)
  }
  
  // MARK: -Method addNewItem
    
  func addNewItem(amount: String, purchaseDescription: String) {
    let purchaseID = UUID().uuidString
    db.collection(FSCollectionReference.purchases.rawValue).document(purchaseID).setData([
      "amount":amount,
      "purchaseDescription":purchaseDescription,
      "timestamp" : Date().timeIntervalSince1970,
      "id" : purchaseID,
      "userID" : Auth.auth().currentUser?.uid
    ])
    { error in
      if error != nil {
        // Show error message
        print(error?.localizedDescription ?? "")
      } else {
        
        self.updateTotalAmount(total: self.totalAmount - Int(amount)!)
      }
    }
  }
  
  
  // MARK: -  Method updateTotalAmount
  
  
  func updateTotalAmount(total: Int) {
    guard let userID = Auth.auth().currentUser?.uid else {return}
    db.collection(FSCollectionReference.totalAmount.rawValue).document(userID).setData(["total":total])
    
    showAlert(alertTitle: "Success", message: "Purchase added successfully", buttonTitle: "OK", goBackAction: true)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}
