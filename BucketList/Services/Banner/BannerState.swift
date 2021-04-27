//
//  BannerState.swift
//  BucketList
//
//  Created by ANKIT YADAV on 27/04/21.
//

import UIKit

enum BannerState {
    case success
    case error
    case warning
}

func getBannerDetails(state: BannerState) -> (UIColor, String){
    switch state {
    case .success:
        return (UIColor(named: "greenAppColor")!, "SUCCESS")
    case .error:
        return (UIColor.red, "ERROR")
    case .warning:
        return (UIColor.yellow, "WARNING")
    }
}
