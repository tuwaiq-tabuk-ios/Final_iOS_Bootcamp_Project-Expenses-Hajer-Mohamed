//
//  Extensions.swift
//  ExpensesprojectH
//
//  Created by hajer . on 03/06/1443 AH.
//

import Foundation
import UIKit


extension String {
  func localize() -> String {
    return NSLocalizedString(self, tableName: "Localization", bundle: .main, value: self, comment: self)
  }
}


extension UIViewController {
  func showAlert123(alertTitle: String, message: String, buttonTitle: String, goBackAction: Bool = true) {
    let alert = UIAlertController(title: alertTitle.localize(), message: message.localize(), preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: buttonTitle.localize(), style: .default, handler: { action in
      if goBackAction == true {
        self.navigationController?.popToRootViewController(animated: true)
      }
    }))
    
    self.present(alert, animated: true, completion: nil)
  }
}
  extension UIView {
      
      func animateView() {
          self.transform = CGAffineTransform(scaleX: 1, y: 0)
          UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: .curveEaseInOut) {
              self.transform = .identity
          }

      }
  }
