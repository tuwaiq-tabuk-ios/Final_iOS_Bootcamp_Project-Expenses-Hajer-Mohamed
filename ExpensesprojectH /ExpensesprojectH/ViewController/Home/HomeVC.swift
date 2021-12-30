//
//  HomeViewController.swift
//  ExpensesprojectH
//
//  Created by hajer . on 16/05/1443 AH.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
    
    @IBOutlet weak var totalAmountTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let db = Firestore.firestore()
    
    var purchases: [PurchaseAmount] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        totalAmountTextField.delegate = self
        getTotalAmounts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTotalAmounts()
        getdata()
    }
    
    
    
    @IBAction func addNewPurchase(_ sender: UIButton) {
        
        guard let amount = totalAmountTextField.text, !amount.isEmpty else {
            UIHelper.makeToast(text: "Please enter total amount first")
            return
        }
        
        guard let _ = Int(amount) else {
            UIHelper.makeToast(text: "Please enter valid amount")
            return
        }
        
        let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.addNewPurchase) as! AddNewPurchaseVC
        
        viewController.totalAmount = Int(amount)!
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
//
    
    func getdata() {
        db.collection("purchases").getDocuments { (snapshot, error) in
            if error != nil {
                print("Error")
                
            } else {
                if let snapshot = snapshot {
                    self.purchases.removeAll()
                    for document in snapshot.documents {
                        let purchase = PurchaseAmount(amount:document["amount"] as? String ?? "", description: document["purchaseDescription"] as? String ?? "")
                        self.purchases.append(purchase)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    func getTotalAmounts() {
        db.collection("totalAmount").document("totalAmounts").addSnapshotListener {
            (snapshot, error) in
            guard let data = snapshot?.data() else
            { return }
            if let totalAmount = data["total"] as? Int {
                self.totalAmountTextField.text = "\(totalAmount)"
            }
        }
    }
    //
    func updateTotalAmount(total: Int) {
        db.collection("totalAmount").document("totalAmounts").setData(["total":total])
    }
}


extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return purchases.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseTVC") as! PurchaseTVC
        
        Cell.configureCell(purchase: purchases[indexPath.row])
        Cell.backgroundColor = UIColor.white
        return Cell
    }
}


func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
    return UIView()
    
}


extension HomeVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else {
            return
        }
        
        if let amount = Int(text) {
            updateTotalAmount(total: amount)
        }
    }
}

