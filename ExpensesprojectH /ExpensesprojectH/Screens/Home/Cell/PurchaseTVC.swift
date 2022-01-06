//
//  PurchaseTVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 22/05/1443 AH.
//

import UIKit

class PurchaseTVC: UITableViewCell {
  
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
  }
  
  func configureCell(purchase: PurchaseAmount) {
    descriptionLabel.text = purchase.description
    amountLabel.text = purchase.amount ?? "0" + " SR".localize()
  }
}
