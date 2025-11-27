//
//  LoginViewController.swift
//  ReactToNative
//
//  Created by Pierluigi Codella on 16/12/24.
//

import UIKit
import React
import React_RCTAppDelegate

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            guard let view = self.getRootView() else { return }
            view.frame = self.view.bounds
            self.view.addSubview(view)
        }

    }
    
    func getRootView() -> UIView? {
        guard let url = bundleURL() else { return nil }
        let view = RCTRootView(bundleURL: url, moduleName: "Login", initialProperties: nil)
        return view
    }
    
    func bundleURL() -> URL? {
#if DEBUG
        RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: "index")
#else
        Bundle.main.url(forResource: "main", withExtension: "jsbundle")
#endif
    }
    
}

