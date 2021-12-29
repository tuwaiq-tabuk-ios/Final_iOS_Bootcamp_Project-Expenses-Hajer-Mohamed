//
//  WalletTVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 24/05/1443 AH.
//

import UIKit

class WalletTVC: UITableViewCell {

    @IBOutlet weak var ImageWallet: UIImageView!
    @IBOutlet weak var walletNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configureCell(wallet:WalletsModelStruct) {
        walletNameLabel.text = wallet.walletName
        categoryLabel.text = wallet.category
        balanceLabel.text = wallet.balance + "SAR"
    }

}
