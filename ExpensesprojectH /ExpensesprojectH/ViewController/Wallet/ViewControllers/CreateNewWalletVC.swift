//
//  addNewWalletVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 22/05/1443 AH.
//

import UIKit
import Firebase


class CreateNewWalletVC: UIViewController {

    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var walletNameTextField: UITextField!
    @IBOutlet weak var balanceTextField: UITextField!
    @IBOutlet weak var selectCategoryButton: UIStackView!
    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(self.openCategories(sender:)))
        selectCategoryButton.addGestureRecognizer(tapGuesture)
    }
    
    @objc func openCategories(sender: UITapGestureRecognizer) {
        let viewController = self.storyboard?.instantiateViewController(identifier: "SelectCategoryViewController") as! SelectCategoryVC
        viewController.delegate = self
        self.navigationController?.pushViewController(viewController, animated: false)
    }

   
    @IBAction func createNewWallet(_ sender: UIButton) {
        
        guard let walletName = walletNameTextField.text, !walletName.isEmpty
        else { UIHelper.makeToast(text: "Please enter wallet name")
           return
            
        }
        guard let balance = balanceTextField.text, !balance.isEmpty
        else { UIHelper.makeToast(text: "Please enter balance")
            
            return
        }
        guard let Category = categoryTextField.text, !Category.isEmpty
        else { UIHelper.makeToast(text: "Please select Category ")
            
            return
        }
        
        db.collection("wallets").addDocument(data: ["walletName":walletName, "balance":balance, "category":Category]) { (error) in
            
            if error != nil {
                // Show error message
                print(error?.localizedDescription ?? "")
            } else {
                self.showAlert()
            }
        }
    }
    
    
    func showAlert() {
        let alert = UIAlertController(title: "Success", message: "Wallet added successfully", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.navigationController?.popToRootViewController(animated: false)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension CreateNewWalletVC: SelectCategoryViewControllerDelegate {
    func didSelectCategory(categoryName: String) {
        categoryTextField.text = categoryName
    }
}

