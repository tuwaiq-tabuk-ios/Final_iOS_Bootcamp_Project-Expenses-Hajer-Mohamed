//
//  SelectCategoryVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 29/05/1443 AH.
//

import UIKit

protocol SelectCategoryViewControllerDelegate: AnyObject {
  func didSelectCategory(categoryName: String)
}

class SelectCategoryVC: UIViewController {
  
  // MARK: - SelectCategoryViewControllerDelegate

  var delegate: SelectCategoryViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  // MARK: - didSelectCategory

  @IBAction func didSelectCategory(_ sender: UIButton) {
    self.delegate?.didSelectCategory(categoryName: sender.currentTitle ?? "")
    self.navigationController?.popViewController(animated: true)
  }
  
}


