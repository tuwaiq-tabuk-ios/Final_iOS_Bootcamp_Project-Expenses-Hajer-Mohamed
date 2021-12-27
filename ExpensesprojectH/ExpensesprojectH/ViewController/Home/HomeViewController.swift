//
//  HomeViewController.swift
//  ExpensesprojectH
//
//  Created by hajer . on 16/05/1443 AH.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var totalAmountTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    
    //    : [PurchaseAmount] = []
    
    var purchases = [ PurchaseAmount(amount: "150", description: "Test")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(addPurchase), name: NSNotification.Name(rawValue: "addPurchase"), object: nil)
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @objc func addPurchase(notfication : Notification) {
        if let NewPurchaseAmount = notfication.userInfo?["addNewPurchase"] as? PurchaseAmount {
            purchases.append(NewPurchaseAmount)
            tableView.reloadData()
        }
    }
    
    @IBAction func addNewPurchase(_ sender: UIButton) {
        
        let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.addNewPurchase) as! addNewPurchaseVC
        let VC = viewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
}

extension HomeViewController : UITableViewDataSource, UITableViewDelegate {
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


