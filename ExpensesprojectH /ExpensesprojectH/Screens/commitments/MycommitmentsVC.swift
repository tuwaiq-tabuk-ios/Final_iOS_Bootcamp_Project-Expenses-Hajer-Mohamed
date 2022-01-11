//
//  MycommitmentsVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 27/05/1443 AH.
//

import UIKit
import Firebase

class MycommitmentsVC: UIViewController {
  let db = Firestore.firestore()
  var commitments: [CommitmentsModel] = []
  
  @IBOutlet weak var tableView: UITableView!
  
  
  // MARK: - View lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.delegate = self
    getData()
    
  }
  
  func getData() {
    db.collection("commitments").order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, error) in
      if error != nil {
        print("Error")
      } else {
        if let snapshot = snapshot {
          self.commitments.removeAll()
          for document in snapshot.documents {
            let commitment = CommitmentsModel(commitmentID: document["commitmentID"] as? String, amount: document["amount"] as? String, commitmentDate: document["commitmentDate"] as? String, commitmentName: document["commitmentName"] as? String, period: document["period"] as? Int, uid: document["uid"] as? String)
            
            self.commitments.append(commitment)
          }
          self.tableView.reloadData()
        }
      }
    }
  }
}
// MARK: - extension UITableView

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
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "commitmentDetails", sender: commitments[indexPath.row])
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      
      if let commitment = commitments[indexPath.row].commitmentID {
        db.collection("commitments").document(commitment).delete { error in
          if error == nil {
            self.commitments.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .top)
            tableView.endUpdates()
          } else {
            print(error?.localizedDescription)
          }
        }
      }
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "commitmentDetails" {
      let vc = segue.destination as! CommitmentDetailVC
      vc.commitment = sender as! CommitmentsModel
    }
  }
}

