//
//  Extensions.swift
//  ExpensesprojectH
//
//  Created by hajer . on 03/06/1443 AH.
//

import Foundation


extension String {
    func localize() -> String {
        return NSLocalizedString(self, tableName: "Localization", bundle: .main, value: self, comment: self)
    }
}
