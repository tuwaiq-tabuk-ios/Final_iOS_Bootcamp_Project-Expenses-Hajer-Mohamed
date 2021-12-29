//
//  WalletVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 22/05/1443 AH.
//

import UIKit

class WalletVC: UIViewController {
    
    
    @IBOutlet weak var tapleView: UITableView!
    
    var wallets: [WalletsModelStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapleView.delegate = self
        tapleView.dataSource = self
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        Cell.backgroundColor = UIColor.white
        return Cell
        
    }
}

