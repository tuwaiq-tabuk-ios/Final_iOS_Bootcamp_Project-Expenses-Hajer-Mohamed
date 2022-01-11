//
//  addNewWalletVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 22/05/1443 AH.
//

import UIKit
import Firebase
import Charts


class CreateNewWalletVC: UIViewController {
  
  let db = Firestore.firestore()
  
  
  
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var walletNameTextField: UITextField!
  @IBOutlet weak var balanceTextField: UITextField!
  @IBOutlet weak var selectCategoryButton: UIStackView!
  @IBOutlet weak var otherCategoryTextField: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.openCategories(sender:)))
    selectCategoryButton.addGestureRecognizer(tapGuesture)
    otherCategoryTextField.isHidden = true
  }
  
  @objc func openCategories(sender: UITapGestureRecognizer) {
    let viewController = self.storyboard?.instantiateViewController(identifier: "SelectCategoryViewController") as! SelectCategoryVC
 viewController.delegate = self
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
  
  var categoryCheck = false
  
  // MARK: - @IBAction
  
  
  @IBAction func createNewWallet(_ sender: UIButton) {
    
    guard let walletName = walletNameTextField.text, !walletName.isEmpty
    else { UIHelper.makeToast(text: "Please enter wallet name".localize())
      return
    }
    guard let balance = balanceTextField.text, !balance.isEmpty
    else { UIHelper.makeToast(text: "Please enter balance".localize())
      return
    }
    
    var categoryName = String()
    
    guard let Category = categoryTextField.text, !Category.isEmpty
    else { UIHelper.makeToast(text: "Please select Category ".localize())
      return
    }
    categoryName = Category
    
    if categoryTextField.text == "other".localize() {
      guard let userNewCategory = otherCategoryTextField.text, !userNewCategory.isEmpty else {
        UIHelper.makeToast(text: "Please write your Category ".localize())
        return
      }
      categoryName = userNewCategory
    }
    
    let walletID = UUID().uuidString
    db.collection("wallets").document(walletID).setData( ["id" : walletID, "walletName":walletName, "balance":balance, "category":categoryName, "timestamp" : Date().timeIntervalSince1970]) { (error) in
      
      if error != nil {
        // Show error message
        print(error?.localizedDescription ?? "")
      } else {
        self.showAlert()
      }
    }
  }
  
  func showAlert() {
    let alert = UIAlertController(title: "Success".localize(), message: "Wallet added successfully".localize(), preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
      self.navigationController?.popToRootViewController(animated: true)
    }))
    self.present(alert, animated: true, completion: nil)
  }
}

// MARK: - extension CreateNewWalletVC

extension CreateNewWalletVC: SelectCategoryViewControllerDelegate {
  func didSelectCategory(categoryName: String) {
    categoryTextField.text = categoryName
    if categoryName == "other".localize() {
      otherCategoryTextField.isHidden = false
    } else {
      otherCategoryTextField.isHidden = true
    }
  }
}
