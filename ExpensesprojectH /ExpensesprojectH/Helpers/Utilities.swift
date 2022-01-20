//
//  Utilities.swift
//  ExpensesprojectH
//
//  Created by hajer . on 16/05/1443 AH.
//
import Foundation
import UIKit


class Utilities: UIViewController {
  
  //  MARK: - Method styleTextField
  
  static func styleTextField(_ textfield:UITextField) {
    let bottomLine = CALayer()
    bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2,
                              width: textfield.frame.width,
                              height: 2)
    
    bottomLine.backgroundColor = #colorLiteral(red: 0.2466930747, green: 0.5560029149, blue: 0.4963359237, alpha: 1)
    textfield.borderStyle = .none
    textfield.layer.addSublayer(bottomLine)
    
  }
//  MARK: - Method styleButton
  
    static func styleFilledButton(_ button:UIButton) {
      
      button.backgroundColor =  #colorLiteral(red: 0.2091423273, green: 0.4873036742, blue: 0.4300398827, alpha: 1)
      button.layer.cornerRadius = 25
      button.tintColor = UIColor.white
  }
  
  
  static func styleHollowButton(_ button:UIButton) {
      
      button.layer.borderWidth = 2
      button.layer.borderColor = UIColor.black.cgColor
      button.layer.cornerRadius = 25.0
      button.tintColor = UIColor.black
  }
}
