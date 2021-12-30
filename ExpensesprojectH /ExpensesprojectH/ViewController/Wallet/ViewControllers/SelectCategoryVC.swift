//
//  SelectCategoryVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 24/05/1443 AH.
//

import UIKit

protocol SelectCategoryViewControllerDelegate: AnyObject {
    func didSelectCategory(categoryName: String)
}

class SelectCategoryVC: UIViewController {

    weak var delegate: SelectCategoryViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func didSelectCategory(_ sender: UIButton) {
        
        self.delegate?.didSelectCategory(categoryName: sender.currentTitle ?? "")
        self.navigationController?.popViewController(animated: false)
    }
    
}

