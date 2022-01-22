//
//  WalletVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 22/05/1443 AH.
//

import UIKit
import Firebase

class WalletVC: UIViewController {
  
  //  MARK: -Properties
  
  let db = Firestore.firestore()
  var wallets: [Wallet] = []
  var arrWallets = [UIImage(named: "Imagewallet-2")!,
                    UIImage(named: "Imagewallet-1")!]
  var timer : Timer?
  var currentCellIndex = 0
  let refreshControl = UIRefreshControl()
  
  let descriptionView = UIView()
  let descriptionLabel = UILabel()
  
  
  // MARK: - @IBOutlet
  
  @IBOutlet weak var tapleView: UITableView!
  @IBOutlet weak var walletCollection: UICollectionView!
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var createWalletButton: UIButton!
  
  
  // MARK: - View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    Utilities.styleFilledButton(createWalletButton)
    
    tapleView.delegate = self
    tapleView.dataSource = self
    walletCollection.delegate = self
    walletCollection.dataSource = self
    pageControl.numberOfPages = arrWallets.count
    startTimer()
    
    refreshControl.tintColor = .gray
    refreshControl.addTarget(self,
                             action: #selector(getData),
                             for: .valueChanged)
    
    tapleView.addSubview(refreshControl)
    let nip = UINib(nibName: "WalletTVC",
                    bundle: nil)
    
    tapleView.register(nip, forCellReuseIdentifier: "WalletTVC")
    
    setUpDescriptionView()
  }
  
  func setUpDescriptionView() {
    descriptionView.translatesAutoresizingMaskIntoConstraints = false
    descriptionView.backgroundColor = .white
    descriptionView.alpha = 0
    descriptionView.layer.shadowColor = UIColor.gray.cgColor
    descriptionView.layer.shadowOpacity = 1
    descriptionView.layer.shadowOffset = .zero
    descriptionView.layer.shadowRadius = 10
    descriptionView.layer.cornerRadius = 15
    tapleView.addSubview(descriptionView)
    
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.text = "We made it easier to start saving money by using this wallet".localize()
    descriptionLabel.textAlignment = .center
    descriptionLabel.textColor = .gray
    descriptionLabel.numberOfLines = 0
    descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    descriptionView.addSubview(descriptionLabel)
    
    NSLayoutConstraint.activate([
      descriptionView.centerXAnchor.constraint(equalTo: tapleView.centerXAnchor),
      descriptionView.centerYAnchor.constraint(equalTo: tapleView.centerYAnchor),
      descriptionView.widthAnchor.constraint(equalTo: tapleView.widthAnchor, constant: -60),
      
      descriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 10),
      descriptionLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -10),
      descriptionLabel.leftAnchor.constraint(equalTo: descriptionView.leftAnchor, constant: 10),
      descriptionLabel.rightAnchor.constraint(equalTo: descriptionView.rightAnchor, constant: -10),
      
    ])
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.getData()
  }
  
  // MARK: - @IBAction
  
  @IBAction func btnEdit(_ sender: UIButton) {
    tapleView.isEditing = !tapleView.isEditing
  }
  
  func startTimer() {
    timer = Timer.scheduledTimer(timeInterval: 2.5,
                                 target: self,
                                 selector: #selector (moveToNextIndex),
                                 userInfo: nil, repeats: true)
  }
  
  // MARK: -Method moveToNextIndex
  
  @objc func moveToNextIndex(){
    if currentCellIndex < arrWallets.count - 1{
      currentCellIndex += 1
    }else {
      currentCellIndex = 0
    }
    walletCollection.scrollToItem(at: IndexPath(item: currentCellIndex,
                                                section: 0),
                                  at: .centeredHorizontally, animated: true)
    
    pageControl.currentPage = currentCellIndex
  }
  
  // MARK: -  Method getData
  
  @objc func getData() {
    db.collection(FSCollectionReference.wallets.rawValue).order(by: "timestamp", descending: true).getDocuments { ( snapshot, error) in
      if error != nil {
        print("Error")
      } else {
        if let snapshot = snapshot {
          self.wallets.removeAll()
          for document in snapshot.documents {
            let wallet = Wallet(id: document["id"] as?
                                String, walletName: document["walletName"] as?
                                String ?? "",balance: document["balance"] as? String ?? "", category: document["category"] as? String ?? "", userID: document["userID"] as? String)
            if wallet.userID == Auth.auth().currentUser?.uid {
              self.wallets.append(wallet)
            }
            
          }
          self.tapleView.reloadData()
          
          if self.wallets.isEmpty {
              self.descriptionView.alpha = 1
              self.descriptionView.isHidden = false
          } else {
              self.descriptionView.isHidden = true
          }
          
      }
    }
  }
  }
}


// MARK: - extension UITableView


extension WalletVC : UITableViewDelegate,
                     UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return wallets.count
  }
  
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
  UITableViewCell {
    
    let Cell = tableView.dequeueReusableCell(withIdentifier: "WalletTVC", for: indexPath) as! WalletTVC
    
    
    Cell.configureCell(wallet: wallets [indexPath.row])
    return Cell
  }
  
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90
  }
  
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      
      if let walletID = wallets[indexPath.row].id {
        
        db.collection(FSCollectionReference.wallets.rawValue).document(walletID).delete { error in
          if error == nil {
            self.wallets.remove(at: indexPath.row)
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
}


// MARK: - extension UICollectionView

extension WalletVC: UICollectionViewDelegate,
                    UICollectionViewDataSource,
                    UICollectionViewDelegateFlowLayout {
  
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arrWallets.count
  }
  
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletCell",
                                                  for: indexPath) as! WalletCollection
    cell.imgCollection.image = arrWallets[indexPath.row]
    return cell
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
    
  }
}

