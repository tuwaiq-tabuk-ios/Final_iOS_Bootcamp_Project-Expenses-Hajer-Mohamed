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
  
  var commitment : CommitmentsModel?
  var payments = [Payment]()
  var months = [String]()
  var paymentStatus = [Int]()
  
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    
    commitmentLabel.text = commitment?.commitmentName
    
    if let id = commitment?.commitmentID {
      getAllPayments(id: id)
    }
    
  }
  
  func getAllPayments(id : String) {
    Firestore.firestore().collection("Payments").document(id).collection("months").order(by: "timestamp", descending: false).getDocuments { snapshot, err in
      if err == nil {
        self.payments.removeAll()
        self.months.removeAll()
        self.paymentStatus.removeAll()
        if let value = snapshot?.documents {
          for i in value {
            
            let data = i.data()
            let paymentID = data["id"] as? String
            let monthNumber = data["monthNumber"] as? Int
            let status = data["status"] as? String
            let payment = Payment(monnthID : i.documentID, paymentID: paymentID, monthNumber: monthNumber, status: status)
            self.payments.append(payment)
            
            if let month = monthNumber {
              self.months.append("#\(month)")
            }
            
            if status == "late" {
              self.paymentStatus.append(1)
            } else if status == "pinding" {
              self.paymentStatus.append(2)
            } else {
              self.paymentStatus.append(3)
            }
            
          }
        }
        self.setChart(dataPoints: self.months, values: self.paymentStatus)
        self.tableView.reloadData()
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
    cell.monthLabel.text = "Month".localize() + " #\(indexPath.row + 1)"
    cell.paymentButton.tag = indexPath.row
    
    if payments[indexPath.row].status == "pinding" {
      cell.paymentButton.backgroundColor = .lightGray
    } else if payments[indexPath.row].status == "paid" {
      cell.paymentButton.backgroundColor = #colorLiteral(red: 0.2448829114, green: 0.5568040609, blue: 0.4974938631, alpha: 1)
    }
    
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print(payments[indexPath.row])
  }
}

extension CommitmentDetailVC : CommitmentDetailCellDelegate {
  func paymentButtonTapped(index: Int) {
    Firestore.firestore().collection("Payments").document((commitment?.commitmentID)!).collection("months").document(payments[index].monnthID!).updateData(["status" : "paid"]) { [self] error in
      if error == nil {
        getAllPayments(id: (commitment?.commitmentID)!)
      }
    }
  }
}
