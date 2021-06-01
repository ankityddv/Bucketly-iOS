//
//  LoginState.swift
//  Bucketly
//
//  Created by ANKIT YADAV on 01/06/21.
//

import Foundation

enum LoginState {
    case isLoggedIn
    case isLoggedOut
}

func getLoginState() -> LoginState {
    if userDefaults?.object(forKey: UserDefaultsManager.login) == nil {
        return .isLoggedOut
    } else {
        return .isLoggedIn
    }
}

