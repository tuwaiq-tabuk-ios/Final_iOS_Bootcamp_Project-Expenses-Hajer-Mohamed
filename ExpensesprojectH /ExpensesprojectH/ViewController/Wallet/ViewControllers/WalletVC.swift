//
//  WalletVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 22/05/1443 AH.
//

import UIKit
import Firebase

class WalletVC: UIViewController {
    
    @IBOutlet weak var tapleView: UITableView!
    
    let db = Firestore.firestore()
    var wallets: [WalletsModelStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapleView.delegate = self
        tapleView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    func getData() {
        db.collection("wallets").getDocuments { ( snapshot, error) in
            if error != nil {
                print("Error")
            } else {
                if let snapshot = snapshot {
                    self.wallets.removeAll()
                    for document in snapshot.documents {
                        let wallet = WalletsModelStruct(walletName: document["walletName"] as?
                            String ?? "",balance: document["balance"] as? String ?? "", category: document["category"] as? String ?? "")
                        
                        self.wallets.append(wallet)
                    }
                    self.tapleView.reloadData()
                }
            }
        }
    }
}


extension WalletVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "WalletTVC") as! WalletTVC
        
        Cell.configureCell(wallet: wallets [indexPath.row])
        return Cell
        
    }
}

