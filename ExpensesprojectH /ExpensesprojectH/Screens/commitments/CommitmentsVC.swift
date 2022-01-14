//
//  CommitmentsVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 26/05/1443 AH.
//

import UIKit
import Firebase

class CommitmentsVC: UIViewController {
  
  let db = Firestore.firestore()
  var types = [1, 3, 6, 12]
  var timePreiod = 0
  
  // MARK: - @IBOutlet
  
  @IBOutlet weak var timePeriodTextField: UITextField!
  @IBOutlet weak var amountOfMoneyTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  @IBOutlet weak var typePickerView: UIPickerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    typePickerView.dataSource = self
    typePickerView.delegate = self
    timePeriodTextField.delegate = self
    
  }
  
  // MARK: - @IBAction
  
  @IBAction func createNewCommitment(_ sender: Any) {
    view.endEditing(true)
    
    guard let commitmentName = nameTextField.text , !commitmentName.isEmpty else {
      UIHelper.makeToast(text: "Please enter commitment name".localize())
      return
    }
    
    guard let amount = amountOfMoneyTextField.text , !amount.isEmpty else {
      UIHelper.makeToast(text: "Please enter amounts".localize())
      return
    }
    
    guard let period = timePeriodTextField.text , !period.isEmpty else {
      UIHelper.makeToast(text: "Please Select repeat type".localize())
      return
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "dd/MM/YYYY"
    let commitmentDate = formatter.string(from: Date())
    
    if let user = Auth.auth().currentUser {
      let commitmentID = UUID().uuidString
      db.collection("commitments").document(commitmentID).setData(["uid" : user.uid, "commitmentName":commitmentName, "amount":amount, "period":timePreiod, "timestamp": Date().timeIntervalSince1970, "commitmentDate" : commitmentDate, "commitmentID" : commitmentID]) { (error) in
        
        if error != nil {
          // Show error message
          print(error?.localizedDescription ?? "")
        } else {
          
          
          for i in 1...self.timePreiod {
            
            Firestore.firestore().collection("Payments").document(commitmentID).collection("months").document(UUID().uuidString).setData([
              "status" : "pinding",
              "id" : UUID().uuidString,
              "timestamp" : Date().timeIntervalSince1970,
              "monthNumber" : i
              
            ]) { err in
              if err == nil {
                self.showAlert()
              }
            }
          }
        }
      }
    }
  }
  
  
  func showAlert() {
    let alert = UIAlertController(title: "Success".localize(),
                                  message: "Commitment added successfully".localize(),
                                  preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "OK".localize(),
                                  style: .default,
                                  handler: { action in
      self.navigationController?.popToRootViewController(animated: true)
    }))
    self.present(alert, animated: true, completion: nil)
  }
}

// MARK: - UIPickerView

extension CommitmentsVC: UIPickerViewDataSource,
                         UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  func pickerView(_ pickerView: UIPickerView,
                  numberOfRowsInComponent component: Int) -> Int {
    return types.count
  }
  
  
  func pickerView(_ pickerView: UIPickerView,
                  titleForRow row: Int,
                  forComponent component: Int) -> String? {
    return "\(types[row])" + " Months".localize()
  }
  
  
  func pickerView(_ pickerView: UIPickerView,
                  didSelectRow row: Int,
                  inComponent component: Int) {
    timePreiod = types[row]
    timePeriodTextField.text = "\(types[row])" + " Months".localize()
    self.typePickerView.isHidden = true
  }
}

// MARK: -  UITextFieldDelegate
extension CommitmentsVC: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if textField == timePeriodTextField {
      view.endEditing(true)
      self.typePickerView.isHidden = false
    }
    return false
    
  }
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}

