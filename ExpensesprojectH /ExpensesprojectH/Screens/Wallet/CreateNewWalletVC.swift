//
//  addNewWalletVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 22/05/1443 AH.
//

import UIKit
import Firebase

class CreateNewWalletVC: UIViewController {
  
  let db = Firestore.firestore()
  
  // MARK: - @IBOutlet
  
  @IBOutlet weak var categoryTextField: UITextField!
  @IBOutlet weak var walletNameTextField: UITextField!
  @IBOutlet weak var balanceTextField: UITextField!
  @IBOutlet weak var selectCategoryButton: UIStackView!
  @IBOutlet weak var otherCategoryTextField: UITextField!
  @IBOutlet weak var createWalletButton: UIButton!
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Utilities.styleFilledButton(createWalletButton)
    
    
    let tapGuesture = UITapGestureRecognizer(target: self,
                                             action: #selector(self.openCategories(sender:)))
    selectCategoryButton.addGestureRecognizer(tapGuesture)
    otherCategoryTextField.isHidden = true
  }
  // MARK: - UITapGestureRecognizer
  
  @objc func openCategories(sender: UITapGestureRecognizer) {
    
    let viewController = self.storyboard?.instantiateViewController(identifier: "SelectCategoryViewController") as! SelectCategoryVC
    viewController.delegate = self
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
  var categoryCheck = false
  
  // MARK: - @IBAction
  
  
  @IBAction func createNewWallet(_ sender: UIButton) {
    
    guard let walletName = walletNameTextField.text, !walletName.isEmpty
    else { UIHelper.showMessage(text: "Please enter wallet name".localize())
      return
    }
    guard let balance = balanceTextField.text, !balance.isEmpty
    else { UIHelper.showMessage(text: "Please enter balance".localize())
      return
    }
    
    var categoryName = String()
    
    guard let Category = categoryTextField.text, !Category.isEmpty
    else { UIHelper.showMessage(text: "Please select Category ".localize())
      return
    }
    categoryName = Category
    
    if categoryTextField.text == "other".localize() {
      guard let userNewCategory = otherCategoryTextField.text, !userNewCategory.isEmpty else {
        UIHelper.showMessage(text: "Please write your Category ".localize())
        return
      }
      categoryName = userNewCategory
    }
    
  

    let walledID = UUID().uuidString
    db.collection(FSCollectionReference.wallets.rawValue).document(walledID).setData( ["id" : walledID, "walletName":walletName, "balance":balance, "category":categoryName, "timestamp" : Date().timeIntervalSince1970, "userID" : Auth.auth().currentUser?.uid]) { (error) in
      
      if error != nil {
        // Show error message
        print(error?.localizedDescription ?? "")
      } else {
        
        self.showAlert(alertTitle: "Success", message: "Wallet added successfully", buttonTitle: "OK", goBackAction: true)
      }
    }
  }
  
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
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
