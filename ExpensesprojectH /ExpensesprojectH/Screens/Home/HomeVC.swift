//
//  HomeViewController.swift
//  ExpensesprojectH
//
//  Created by hajer . on 16/05/1443 AH.
//

import UIKit
import Firebase

class HomeVC: UIViewController {
  
  //  MARK: -Properties
  
  let db = Firestore.firestore()
  var purchases: [PurchaseAmount] = []
  let refreshControl = UIRefreshControl()
  
  let descriptionView = UIView()
  let descriptionLabel = UILabel()

  
  // MARK: - @IBOutlet
  
  @IBOutlet weak var totalAmountTextField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var addPurchaseButton: UIButton!
  
  
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Utilities.styleFilledButton(addPurchaseButton)
    
    
    tableView.dataSource = self
    tableView.delegate = self
    refreshControl.tintColor = .gray
    tableView.addSubview(refreshControl)
    
    let nib = UINib(nibName: "PurchaseTVC", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "PurchaseTVC")
    
    totalAmountTextField.delegate = self
    getTotalAmounts()
    
    refreshControl.addTarget(self,
                             action: #selector(getdata),
                             for: .valueChanged)
    setUpDescriptionView()
  }
  
  func setUpDescriptionView() {
      descriptionView.translatesAutoresizingMaskIntoConstraints = false
      descriptionView.backgroundColor = .white
      descriptionView.alpha = 0
      descriptionView.layer.shadowColor = UIColor.gray.cgColor
      descriptionView.layer.shadowOpacity = 1
      descriptionView.layer.shadowOffset = .zero
      descriptionView.layer.shadowRadius = 10
      descriptionView.layer.cornerRadius = 15
      tableView.addSubview(descriptionView)
      
      descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    
    descriptionLabel.text = " First step for saving is to study the budget. Define the total income, also the full expenses like bills,You can now add and track you purchases easily by adding it here .".localize()
    
    
      descriptionLabel.textAlignment = .center
      descriptionLabel.textColor = .gray
      descriptionLabel.numberOfLines = 0
      descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
      descriptionView.addSubview(descriptionLabel)
      
      NSLayoutConstraint.activate([
        descriptionView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
        descriptionView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
        descriptionView.widthAnchor.constraint(equalTo: tableView.widthAnchor, constant: -60),
        
        descriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 10),
        descriptionLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -10),
        descriptionLabel.leftAnchor.constraint(equalTo: descriptionView.leftAnchor, constant: 10),
        descriptionLabel.rightAnchor.constraint(equalTo: descriptionView.rightAnchor, constant: -10),
        
      ])
  }

  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getTotalAmounts()
    getdata()
  }
  
  // MARK: - @IBAction
  
  @IBAction func ButtonEdit(_ sender: UIButton) {
    tableView.isEditing = !tableView.isEditing
  }
  
  @IBAction func addNewPurchase(_ sender: UIButton) {
    
    
    guard let amount = totalAmountTextField.text, !amount.isEmpty else {
      UIHelper.showMessage(text: "Please enter total amount first".localize())
      return
    }
    
    guard let _ = Int(amount) else {
      UIHelper.showMessage(text: "Please enter valid amount".localize())
      return
    }
    
    let viewController = self.storyboard?.instantiateViewController(identifier: K.Storyboard.addNewPurchase) as! AddNewPurchaseVC
    
    viewController.totalAmount = Int(amount)!
    
    self.navigationController?.pushViewController(viewController, animated: true)
  }
  
  
  // MARK: - Method getdata()
  
  @objc func getdata() {
    db.collection(FSCollectionReference.purchases.rawValue).order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
      if error != nil {
        print("Error")
      } else {
        if let snapshot = snapshot {
          self.purchases.removeAll()
          for document in snapshot.documents {
            let purchase = PurchaseAmount(id: document["id"] as? String, amount:document["amount"] as? String ?? "", description: document["purchaseDescription"] as? String ?? "", userID: document["userID"] as? String)
            
            if purchase.userID == Auth.auth().currentUser!.uid {
              self.purchases.append(purchase)
            }
            
          }
          self.refreshControl.endRefreshing()
          self.tableView.reloadData()
          if self.purchases.isEmpty {
              self.descriptionView.alpha = 1
              self.descriptionView.isHidden = false
          } else {
              self.descriptionView.isHidden = true
          }
        }
      }
    }
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  // MARK: - Method getTotalAmounts()
  
  func getTotalAmounts() {
    guard let userID = Auth.auth().currentUser?.uid else {return}
    
    db.collection(FSCollectionReference.totalAmount.rawValue).document(userID).addSnapshotListener {
      
      (snapshot, error) in
      guard let data = snapshot?.data() else
      { return }
      if let totalAmount = data["total"] as? Int {
        self.totalAmountTextField.text = "\(totalAmount)"
      }
    }
  }
  
  
  // MARK: - Method updateTotalAmount()
  
  func updateTotalAmount(total: Int) {
    
    guard let userID = Auth.auth().currentUser?.uid else {return}
    db.collection(FSCollectionReference.totalAmount.rawValue).document(userID).setData(["total":total])
  }
}


// MARK: - extension UITableView
extension HomeVC: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return purchases.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let Cell = tableView.dequeueReusableCell(withIdentifier: "PurchaseTVC") as! PurchaseTVC
    
    Cell.configureCell(purchase: purchases[indexPath.row])
    
    return Cell
  }
  
  
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    purchases.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(purchases[indexPath.row])
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      
      if let purchase = purchases[indexPath.row].id {
        
        db.collection(FSCollectionReference.purchases.rawValue).document(purchase).delete { error in
          if error == nil {
            
            self.purchases.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
          } else {
            print(error?.localizedDescription)
          }
        }
      }
    }
  }
}


// MARK: - extension UITextFieldDelegate

extension HomeVC: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text, !text.isEmpty else {return}
    
    if let amount = Int(text) {
      updateTotalAmount(total: amount)
    }
  }
}




