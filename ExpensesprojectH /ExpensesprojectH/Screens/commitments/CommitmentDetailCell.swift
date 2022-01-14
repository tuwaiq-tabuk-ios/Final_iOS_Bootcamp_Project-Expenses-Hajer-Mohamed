//
//  CommitmentDetailCell.swift
//  ExpensesprojectH
//
//  Created by hajer . on 02/06/1443 AH.
//

import UIKit

protocol CommitmentDetailCellDelegate {
  func paymentButtonTapped(index : Int)
}

class CommitmentDetailCell: UITableViewCell {
  
  var delegate : CommitmentDetailCellDelegate!
  
  
  @IBOutlet weak var paymentButton: UIButton!
  @IBOutlet weak var monthLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    paymentButton.layer.cornerRadius = 15
  }
  
  
  @IBAction func paymentButtonAction(_ sender: UIButton) {
    delegate.paymentButtonTapped(index: sender.tag)
  }
}

