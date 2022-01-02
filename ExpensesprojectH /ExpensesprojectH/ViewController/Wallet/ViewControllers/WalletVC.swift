//
//  WalletVC.swift
//  ExpensesprojectH
//
//  Created by hajer . on 22/05/1443 AH.
//

import UIKit
import Firebase

class WalletVC: UIViewController {
    
    @IBOutlet weak var tapleView: UITableView!
    @IBOutlet weak var walletCollection: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    let db = Firestore.firestore()
    var wallets: [WalletsModelStruct] = []
    var arrWallets = [UIImage(named: "image99")!,
                    UIImage(named: "image90")!]
    var timer : Timer?
    var currentCellIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tapleView.delegate = self
        tapleView.dataSource = self
        
        walletCollection.delegate = self
        walletCollection.dataSource = self
        pageControl.numberOfPages = arrWallets.count
        startTimer()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    
    func startTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector (moveToNextIndex), userInfo: nil, repeats: true)
    }
    
    @objc func moveToNextIndex(){
        
        if currentCellIndex < arrWallets.count - 1{
            currentCellIndex += 1
            
        }else {
            currentCellIndex = 0
        }
        
        walletCollection.scrollToItem(at: IndexPath(item: currentCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        
        pageControl.currentPage = currentCellIndex
    }
    
    
    func getData() {
        db.collection("wallets").getDocuments { ( snapshot, error) in
            if error != nil {
                print("Error")
            } else {
                if let snapshot = snapshot {
                    self.wallets.removeAll()
                    for document in snapshot.documents {
                        let wallet = WalletsModelStruct(walletName: document["walletName"] as?
                                                        String ?? "",balance: document["balance"] as? String ?? "", category: document["category"] as? String ?? "")
                        self.wallets.append(wallet)
                    }
                    self.tapleView.reloadData()
                }
            }
        }
    }
}


extension WalletVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wallets.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
    UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "WalletTVC") as! WalletTVC
        
        Cell.configureCell(wallet: wallets [indexPath.row])
        return Cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
}

extension WalletVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrWallets.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalletCell", for: indexPath) as! WalletCollection
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
