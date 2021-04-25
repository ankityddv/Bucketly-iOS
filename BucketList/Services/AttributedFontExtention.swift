//
//  AttributedFontExtention.swift
//  BucketList
//
//  Created by ANKIT YADAV on 21/04/21.
//

import Foundation
import UIKit


extension NSMutableAttributedString {
    
    var regular14Font: UIFont { return UIFont(name: Fonts.regular, size: 14) ?? UIFont.boldSystemFont(ofSize: 14)}
    var regular20Font: UIFont { return UIFont(name: Fonts.regular, size: 20) ?? UIFont.boldSystemFont(ofSize: 20)}
    var bold14Font: UIFont { return UIFont(name: Fonts.bold, size: 14) ?? UIFont.boldSystemFont(ofSize: 14)}
    var extraBold40Font: UIFont { return UIFont(name: Fonts.extraBold, size: 40) ?? UIFont.boldSystemFont(ofSize: 40)}
    
    func regular14(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : regular14Font,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func regular20(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : regular20Font,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func bold14(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : bold14Font,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func extraBold40(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : extraBold40Font,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func extraBold40Green(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : extraBold40Font,
            .foregroundColor : UIColor(named: "greenAppColor") as Any,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
}

extension Date {
    
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    
}
