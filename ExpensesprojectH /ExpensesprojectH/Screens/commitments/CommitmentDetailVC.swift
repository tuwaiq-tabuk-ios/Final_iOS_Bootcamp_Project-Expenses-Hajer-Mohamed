//
//  CommitmentDetailVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 02/06/1443 AH.
//

import UIKit
import Firebase
import Charts


class CommitmentDetailVC: UIViewController {
  
  //  MARK: -Properties

  var commitment : CommitmentsModel?
  var payments = [Payment]()
  var chartMonths = [String]()
  var chartPaymentStatus = [Int]()
  
  // MARK: - @IBOutlet
  
  @IBOutlet weak var commitmentLabel: UILabel!
  @IBOutlet weak var tableView : UITableView!
  @IBOutlet weak var chartView: LineChartView!
  
  
  func setChart(dataPoints: [String], values: [Int]) {
    var dataEntries: [ChartDataEntry] = []
    
    for i in 0..<dataPoints.count {
      let dataEntry = ChartDataEntry(x: Double(i),
                                     y: Double(values[i]),
                                     data: dataPoints[i] as AnyObject)
      
      dataEntries.append(dataEntry)
    }
    
    
    // MARK: - chartDataSet
    
    let chartDataSet = LineChartDataSet(entries: dataEntries, label: nil)
    chartDataSet.circleRadius = 5
    chartDataSet.circleHoleRadius = 2
    chartDataSet.drawValuesEnabled = false
    chartDataSet.colors = ChartColorTemplates.joyful()
    
    let chartData = LineChartData(dataSets: [chartDataSet])
    
    chartView.data = chartData
    
    chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
    chartView.xAxis.labelPosition = .bottom
    chartView.xAxis.drawGridLinesEnabled = false
    chartView.xAxis.avoidFirstLastClippingEnabled = true
    
    chartView.rightAxis.drawAxisLineEnabled = false
    chartView.rightAxis.drawLabelsEnabled = false
    
    chartView.leftAxis.drawAxisLineEnabled = false
    chartView.pinchZoomEnabled = false
    chartView.doubleTapToZoomEnabled = false
    chartView.legend.enabled = false
    chartView.xAxis.setLabelCount(dataPoints.count, force: true)
  }
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    commitmentLabel.text = commitment?.commitmentName
    
    if let id = commitment?.commitmentID {
      getAllPayments(id: id)
    }
    
  }
  
  // MARK: - getAllPayments
  
  func getAllPayments(id : String) {
    Firestore.firestore().collection(FSCollectionReference.Payments.rawValue).document(id).collection(FSCollectionReference.months.rawValue).order(by: "timestamp", descending: false).getDocuments { snapshot, err in
      if err == nil {
        self.payments.removeAll()
        self.chartMonths.removeAll()
        self.chartPaymentStatus.removeAll()
        if let value = snapshot?.documents {
          for i in value {
            
            let data = i.data()
            let paymentID = data["id"] as? String
            let monthNumber = data["monthNumber"] as? Int
            let status = data["status"] as? String
            let payment = Payment(monnthID : i.documentID, paymentID: paymentID, monthNumber: monthNumber, status: status)
            self.payments.append(payment)
            if let month = monthNumber {
              self.chartMonths.append("#\(month)")
            }
            
            
            if status == "pinding" {
              self.chartPaymentStatus.append(1)
            } else {
              self.chartPaymentStatus.append(2)
            }
            
          }
          self.setChart(dataPoints: self.chartMonths,
                        values: self.chartPaymentStatus)
          self.tableView.reloadData()
        }
      }
    }
  }
}

// MARK: - extensionUITableView

extension CommitmentDetailVC:UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return payments.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CommitmentDetailCell
      cell.delegate = self
      cell.paymentButton.tag = indexPath.row
      
      cell.monthLabel.text = "Month".localize() + " \(indexPath.row + 1)"
      
      if payments[indexPath.row].status == "pinding" {
          cell.paymentButton.backgroundColor = .lightGray
      } else {
          cell.paymentButton.backgroundColor = #colorLiteral(red: 0.2448829114, green: 0.5568040609, blue: 0.4974938631, alpha: 1)
          cell.paymentButton.isEnabled = false
      }
      
      return cell
  }

}



// MARK: - CommitmentDetailCellDelegate

extension CommitmentDetailVC : CommitmentDetailCellDelegate {
  func paymentButtonTapped(index: Int) {
    
    let alert = UIAlertController(title: "Alert".localize(), message: "Do you want to deduct the amount from your total amount ?".localize(), preferredStyle: .alert)
    
    alert.addAction(UIAlertAction(title: "Yes".localize(), style: .default, handler: { action in
      self.updateTotalAmounts()
    }))
    
    alert.addAction(UIAlertAction(title: "No".localize(), style: .default, handler: { action in }))
    self.present(alert, animated: true, completion: nil)
    
    
    Firestore.firestore().collection(FSCollectionReference.Payments.rawValue).document((commitment?.commitmentID)!).collection(FSCollectionReference.months.rawValue).document(payments[index].monnthID!).updateData(["status" : "paid"]) { [self] error in
      if error == nil {
        getAllPayments(id: (commitment?.commitmentID)!)
      }
    }
    
  }
  
  
  // MARK: - updateTotalAmounts
  
  func updateTotalAmounts() {
    guard let userID = Auth.auth().currentUser?.uid else {return}
    Firestore.firestore().collection(FSCollectionReference.totalAmount.rawValue).document(userID).getDocument {
      (snapshot, error) in
      guard let data = snapshot?.data() else
      { return }
      if let totalAmount = data["total"] as? Int {
        if let amount = Int((self.commitment?.amount)!) {
          let newTotal = totalAmount - amount
          guard let userID = Auth.auth().currentUser?.uid else {return}
          Firestore.firestore().collection(FSCollectionReference.totalAmount.rawValue).document(userID).setData(["total":newTotal]) { error in
            if error == nil {
              
              self.showAlert(alertTitle: "Alert".localize(), message: "payment done successfully form your balance. \n your new balance is".localize() + " : \(newTotal)", buttonTitle: "Ok".localize(), goBackAction: false)
            }
          }
        }
      }
    }
  }
}
