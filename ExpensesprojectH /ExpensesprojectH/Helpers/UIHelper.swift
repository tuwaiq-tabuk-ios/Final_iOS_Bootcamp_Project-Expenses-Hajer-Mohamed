//
//  UIHelper.swift
//  ExpensesprojectH
//
//  Created by hajer . on 22/05/1443 AH.
//


import Toast_Swift

class UIHelper {
    

    class func makeToast(text: String, showInCenter: Bool = false) {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.keyWindow {
                if showInCenter {
                    window.makeToast(text, point: CGPoint(x: Constants.screenWidth / 2, y: Constants.screenHeight / 2), title: nil, image: nil, completion: nil)
                } else {
                    window.makeToast(text)
                }
            }
        }
    }
}
