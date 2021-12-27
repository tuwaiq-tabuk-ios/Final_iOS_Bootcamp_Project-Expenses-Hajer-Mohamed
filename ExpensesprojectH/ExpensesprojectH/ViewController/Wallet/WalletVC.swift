//
//  WalletVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 22/05/1443 AH.
//

import UIKit

class WalletVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addNewWallet(_ sender: UIButton) {
        
        let viewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.addNewWallet) as! addNewWalletVC
        let VC = viewController
        self.navigationController?.pushViewController(VC, animated: true)

        
    }
}
