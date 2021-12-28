//
//  DescribeVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 19/05/1443 AH.
//

import UIKit
import Firebase

class AddNewPurchaseVC: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var amountTextField: UITextField!
    
    let db = Firestore.firestore()
    var totalAmount = 0
    
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
        amountTextField.layer.borderColor = UIColor.gray.cgColor
        amountTextField.layer.cornerRadius = 8
        amountTextField.clipsToBounds = true
        
    }
    
    @IBAction func addNewPurchase(_ sender: UIButton) {
        
        guard let amount = amountTextField.text, !amount.isEmpty else {
            UIHelper.makeToast(text: "Please Enter Purchase Amount")
            return
        }
        
        guard let description = descriptionTextView.text, !description.isEmpty else {
            UIHelper.makeToast(text: "Please Enter Purchase Description")
            return
        }
        
        self.addNewItem(amount: amount, purchaseDescription: description)
        
    }
    
    
    func addNewItem(amount: String, purchaseDescription: String) {
        
        db.collection("purchases").addDocument(data: ["amount":amount, "purchaseDescription":purchaseDescription]) { (error) in
            
            if error != nil {
                // Show error message
                print(error?.localizedDescription ?? "")
            } else {
                
                self.updateTotalAmount(total: self.totalAmount - Int(amount)!)
            }
        }
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Success", message: "Purchase added successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateTotalAmount(total: Int) {
        db.collection("totalAmount").document("totalAmounts").setData(["total":total])
        
        self.showAlert()
        
    }
}
