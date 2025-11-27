//
//  UserManager.swift
//  ReactToNative
//
//  Created by Pierluigi Codella on 16/12/24.
//

import Foundation
import Combine

public class UserManager: ObservableObject {
    
    static let shared = UserManager()
    
    @Published var isLoggedIn = false
    
}
