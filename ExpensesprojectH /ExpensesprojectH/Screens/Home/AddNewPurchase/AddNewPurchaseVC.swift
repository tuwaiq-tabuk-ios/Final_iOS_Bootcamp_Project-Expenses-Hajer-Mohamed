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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  
  func setupUI() {
    descriptionTextView.layer.borderWidth = 1
    descriptionTextView.layer.borderColor = UIColor.gray.cgColor
    descriptionTextView.layer.cornerRadius = 8
    descriptionTextView.clipsToBounds = true
    
    amountTextField.layer.borderWidth = 1
    amountTextField.layer.borderColor = UIColor.white.cgColor
    amountTextField.layer.cornerRadius = 8
    amountTextField.clipsToBounds = true
    
  }
  // MARK: - @IBAction
  
  @IBAction func addNewPurchase(_ sender: UIButton) {
    
    guard let amount = amountTextField.text, !amount.isEmpty else {
      UIHelper.makeToast(text: "Please Enter Purchase Amount".localize())
      return
    }
    
    guard let description = descriptionTextView.text, !description.isEmpty else {
      UIHelper.makeToast(text: "Please Enter Purchase Description".localize())
      return
    }
    self.addNewItem(amount: amount, purchaseDescription: description)
  }
  
  
  func addNewItem(amount: String, purchaseDescription: String) {
    let purchaseID = UUID().uuidString
    db.collection("purchases").document(purchaseID).setData([
      "amount":amount,
      "purchaseDescription":purchaseDescription,
      "timestamp" : Date().timeIntervalSince1970,
      "id" : purchaseID
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
  
  
  func showAlert() {
    let alert = UIAlertController(title: "Success".localize(), message: "Purchase added successfully".localize(), preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK".localize(), style: .default, handler: { action in
      self.navigationController?.popToRootViewController(animated: true)
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
  
  
  func updateTotalAmount(total: Int) {
    guard let userID = Auth.auth().currentUser?.uid else {return}
    db.collection("totalAmount").document(userID).setData(["total":total])
    self.showAlert()
    
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}
