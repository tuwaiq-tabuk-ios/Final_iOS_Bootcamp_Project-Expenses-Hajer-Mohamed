//
//  CommitmentsTableViewCell.swift
//  ExpensesprojectH
//
//  Created by hajer . on 27/05/1443 AH.
//

import UIKit

class CommitmentsTVC: UITableViewCell {
  
  //  MARK: -IBOutlet

  @IBOutlet weak var containerView: UIView!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var repeatTypeLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    containerView.layer.cornerRadius = 8
    containerView.clipsToBounds = true
  }
  
  // MARK: - Method configureCell

  func configureCell(commitments:CommitmentsModel) {
    nameLabel.text = commitments.commitmentName
    amountLabel.text = commitments.amount! + " " + "SR".localize()
    dateLabel.text = commitments.commitmentDate
    
    if let period = commitments.period {
      if period > 1 {
        repeatTypeLabel.text = "\(period) Months".localize()
      } else {
        repeatTypeLabel.text = "\(period) Month".localize()
      }
    }
  }
}




