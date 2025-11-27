//
//  LoginViewEventManager.swift
//  ReactToNative
//
//  Created by Pierluigi Codella on 16/12/24.
//

import Foundation

@objc(LoginViewEventManager)
public class LoginViewEventManager: NSObject {
    
    
    @objc(onLoginSuccess:)
    func onLoginSuccess(event: NSDictionary) {
        UserManager.shared.isLoggedIn = true
    }
    
    @objc(onLogoutSuccess)
    func onLogoutSuccess() {
        UserManager.shared.isLoggedIn = false
    }
    
}
