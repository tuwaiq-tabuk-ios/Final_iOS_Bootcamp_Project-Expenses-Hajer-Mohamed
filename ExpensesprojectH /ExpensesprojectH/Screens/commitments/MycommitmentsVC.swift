//
//  MycommitmentsVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 27/05/1443 AH.
//

import UIKit
import Firebase

class MycommitmentsVC: UIViewController {
  
  var commitments: [CommitmentsModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
}

extension MycommitmentsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commitments.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "commitmentsTVC") as! CommitmentsTableViewCell
        
        Cell.configureCell(commitments: commitments[indexPath.row])
        Cell.backgroundColor = UIColor.white
        return Cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
