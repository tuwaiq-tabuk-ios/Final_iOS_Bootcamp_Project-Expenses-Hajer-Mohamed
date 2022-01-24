//
//  CommitmentsVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 26/05/1443 AH.
//

import UIKit
import Firebase

class CommitmentsVC: UIViewController {
  
  //  MARK: -Properties

  let db = Firestore.firestore()
  var months = [1, 3, 6, 12]
  var timePreiod = 0
  
  // MARK: - @IBOutlet
  
  @IBOutlet weak var timePeriodTextField: UITextField!
  @IBOutlet weak var amountOfMoneyTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var typePickerView: UIPickerView!
  @IBOutlet weak var totalAmountLabel: UILabel!
  @IBOutlet weak var createCommitmentButton: UIButton!
  @IBOutlet weak var showCommimentsButton: UIButton!
  
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    Utilities.styleFilledButton(createCommitmentButton)
    Utilities.styleFilledButton(showCommimentsButton)
    
    typePickerView.dataSource = self
    typePickerView.delegate = self
    timePeriodTextField.delegate = self
    
  }
  
  
  // MARK: - @IBAction
  
  @IBAction func createNewCommitment(_ sender: Any) {
    view.endEditing(true)
    
    guard let commitmentName = nameTextField.text , !commitmentName.isEmpty else {
      UIHelper.showMessage(text: "Please enter commitment name".localize())
      return
    }
    
    guard let amount = amountOfMoneyTextField.text , !amount.isEmpty else {
      UIHelper.showMessage(text: "Please enter amounts".localize())
      return
    }
    
    guard let period = timePeriodTextField.text , !period.isEmpty else {
      UIHelper.showMessage(text: "Please Select repeat type".localize())
      return
    }
    
    
    // MARK: - DateFormatter()

    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/YYYY"
    let commitmentDate = formatter.string(from: Date())
    
    
    if let user = Auth.auth().currentUser {
      let commitmentID = UUID().uuidString
      
      db.collection(FSCollectionReference.commitments.rawValue).document(commitmentID).setData(["uid" : user.uid, "commitmentName":commitmentName, "amount":amount, "period":timePreiod, "timestamp": Date().timeIntervalSince1970, "commitmentDate" : commitmentDate, "commitmentID" : commitmentID]) { (error) in
        
        if error != nil {
          // Show error message
          print(error?.localizedDescription ?? "")
        } else {
          
          
          for i in 1...self.timePreiod {
              
              Firestore.firestore().collection(FSCollectionReference.Payments.rawValue).document(commitmentID).collection(FSCollectionReference.months.rawValue).document(UUID().uuidString).setData([
                  "status" : "pinding",
                  "id" : UUID().uuidString,
                  "timestamp" : Date().timeIntervalSince1970,
                  "monthNumber" : i
              
            ]) { err in
              if err == nil {
                self.showAlert(alertTitle: "Success",
                               message: "Commitment added successfully", buttonTitle: "OK")
              }
            }
          }
        }
      }
    }
  }
}

// MARK: - UIPickerView

extension CommitmentsVC: UIPickerViewDataSource,
                         UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return months.count
  }
  
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(months[row])" + " Months".localize()
  }
  
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    timePreiod = months[row]
    timePeriodTextField.text = "\(months[row])" + " Months".localize()
    self.typePickerView.isHidden = true
    
    if let amount = amountOfMoneyTextField.text, amount.isEmpty == false {
      totalAmountLabel.text = "your total amount = \(Int(amount)! * timePreiod)".localize()
    }
  }
}


// MARK: - UITextFieldDelegate

extension CommitmentsVC: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == timePeriodTextField {
      view.endEditing(true)
      self.typePickerView.isHidden = false
    }
    return false
  }
  
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    if let amount = amountOfMoneyTextField.text, amount.isEmpty == false, let period = timePeriodTextField.text, period.isEmpty == false {
      totalAmountLabel.text = "your total amount = \(Int(amount)! * timePreiod)".localize()
    }
  }
}
