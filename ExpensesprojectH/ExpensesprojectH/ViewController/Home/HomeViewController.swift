//
//  HomeViewController.swift
//  ExpensesprojectH
//
//  Created by hajer . on 16/05/1443 AH.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var addbutton: UIButton!
    @IBOutlet weak var textFiledhome: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureButton()
    }
    
    func ConfigureButton() {
        
        addbutton.layer.cornerRadius = 15
        addbutton.layer.borderWidth = 0.5
        textFiledhome.layer.cornerRadius = 20
        textFiledhome.layer.borderWidth = 0.5
    }
}
