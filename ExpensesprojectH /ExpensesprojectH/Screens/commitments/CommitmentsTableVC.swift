//
//  MycommitmentsVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 27/05/1443 AH.
//

import UIKit
import Firebase

class CommitmentsTableVC: UIViewController {
  //  MARK: -Properties
  
  let db = Firestore.firestore()
  var commitments: [CommitmentsModel] = []
  
  
  // MARK: - @IBOutlet
  @IBOutlet weak var tableView: UITableView!
  
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nib = UINib(nibName: "commitmentsTVC", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "commitmentsTVC")
    
    tableView.dataSource = self
    tableView.delegate = self
    getData()
    
  }
  
  // MARK: - Method getData()
  
  func getData() {
    db.collection(FSCollectionReference.commitments.rawValue).order(by: "timestamp", descending: true).addSnapshotListener { (snapshot, error) in
      if error != nil {
        print("Error")
      } else {
        if let snapshot = snapshot {
          self.commitments.removeAll()
          for document in snapshot.documents {
            let commitment = CommitmentsModel(commitmentID: document["commitmentID"] as? String, amount: document["amount"] as? String, commitmentDate: document["commitmentDate"] as? String, commitmentName: document["commitmentName"] as? String, period: document["period"] as? Int, uid: document["uid"] as? String)
            
            if commitment.uid == Auth.auth().currentUser?.uid {
              self.commitments.append(commitment)
            }
            
          }
          self.tableView.reloadData()
        }
      }
    }
  }
}


// MARK: - UITableView

extension CommitmentsTableVC: UITableViewDataSource,
                              UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commitments.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let Cell = tableView.dequeueReusableCell(withIdentifier: "commitmentsTVC",
                                             for: indexPath) as! CommitmentsTVC
    
    Cell.configureCell(commitments: commitments[indexPath.row])
    return Cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "commitmentDetails", sender: commitments[indexPath.row])
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      if let commitmentID = commitments[indexPath.row].commitmentID {
        db.collection(FSCollectionReference.commitments.rawValue).document(commitmentID).delete()
      }
    }
  }
  
  
  // MARK: - Method prepare
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "commitmentDetails" {
      let vc = segue.destination as! CommitmentDetailVC
      vc.commitment = sender as? CommitmentsModel
    }
  }
}

