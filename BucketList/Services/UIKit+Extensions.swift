//
//  UIKit+Extensions.swift
//  Bucketly
//
//  Created by ANKIT YADAV on 02/06/21.
//

import Foundation
import UIKit


extension String {
    func saveToUserDefaults(forKey: String) {
        userDefaults?.setValue(self, forKey: forKey)
    }
    func fetchUserDefault() -> String {
        return userDefaults?.object(forKey: self) as! String
    }
}
