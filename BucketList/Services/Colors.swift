//
//  Colors.swift
//  BucketList
//
//  Created by ANKIT YADAV on 27/04/21.
//

import UIKit

enum ColorSet {
    case neonGreen
    case textFieldBg
    case gray
    case buttonBg
    case black
    case clear
    case white
    case neonPink
}

func getColor(color: ColorSet) -> UIColor{
    switch color {
    case .neonGreen:
        return UIColor(named: "greenAppColor")!
    case .textFieldBg:
        return UIColor(named: "textFieldBgColor")!
    case .gray:
        return UIColor(named: "grayTextColor")!
    case .buttonBg:
        return UIColor(named: "buttonColor")!
    case .black:
        return UIColor.black
    case .clear:
        return UIColor.clear
    case .white:
        return UIColor.white
    case .neonPink:
        return UIColor(named: "neonPinkColor")!
    }
}
