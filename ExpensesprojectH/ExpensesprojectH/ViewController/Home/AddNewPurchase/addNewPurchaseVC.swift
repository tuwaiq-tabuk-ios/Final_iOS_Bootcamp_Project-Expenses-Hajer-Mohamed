//
//  DescribeVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 19/05/1443 AH.
//

import UIKit

class addNewPurchaseVC: UIViewController {
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var amountTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addNewPurchase(_ sender: UIButton) {
        
        var purchaseAmount = PurchaseAmount(amount: amountTextField.text!, description: descriptionTextView.text!)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "addPurchase")  , object: nil , userInfo: ["addNewPurchase":purchaseAmount])
        
        
        navigationController?.popViewController(animated: true)
    }
}


