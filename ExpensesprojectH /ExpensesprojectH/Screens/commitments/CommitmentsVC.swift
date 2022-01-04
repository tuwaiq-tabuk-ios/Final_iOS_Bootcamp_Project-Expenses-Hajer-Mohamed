//
//  CommitmentsVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 26/05/1443 AH.
//

import UIKit
import Firebase

class CommitmentsVC: UIViewController {
  
  let datePicker = UIDatePicker()
  let db = Firestore.firestore()
  
//  var types = ["weekly", "monthly", "yearly"]
  
  
  @IBOutlet weak var TimeperiodTextField: UITextField!
  @IBOutlet weak var repeatTextField: UITextField!
  @IBOutlet weak var amountOfMoneyTextField: UITextField!
  @IBOutlet weak var nameTextField: UITextField!
  
  @IBOutlet weak var typePickerView: UIPickerView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
      
    
    func showAlert() {
      let alert = UIAlertController(title: "Success", message: "Commitment added successfully", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        self.navigationController?.popToRootViewController(animated: true)
      }))
      
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  
  @IBAction func createNewCommitment(_ sender: Any) {
    
    
    guard let commitmentName = nameTextField.text , !commitmentName.isEmpty else {
      UIHelper.makeToast(text: "Please enter commitment name")
      return
    }
    
    guard let amount = amountOfMoneyTextField.text , !amount.isEmpty else {
      UIHelper.makeToast(text: "Please enter amounts")
      return
    }
    
    guard let repeatType = repeatTextField.text , !repeatType.isEmpty else {
      UIHelper.makeToast(text: "Please Select repeat type")
      return
    }
    
    guard let startDate = TimeperiodTextField.text , !startDate.isEmpty else {
      UIHelper.makeToast(text: "Please select Time period")
      return
      
    }
  }
}
