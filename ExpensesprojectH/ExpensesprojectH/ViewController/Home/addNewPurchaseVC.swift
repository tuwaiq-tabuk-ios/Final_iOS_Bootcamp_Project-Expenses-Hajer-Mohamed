//
//  DescribeVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 19/05/1443 AH.
//

import UIKit

class addNewPurchaseVC: UIViewController {

    
    @IBOutlet weak var addDes: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureButton()
    }
    
    func ConfigureButton() {
        
        addDes.layer.cornerRadius = 20
        addDes.layer.borderWidth = 1
        
        
        
    }
    
    
}
