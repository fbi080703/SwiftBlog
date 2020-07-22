//
//  main.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/29.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

//import Foundation

import UIKit


class MyApplication: UIApplication {
    override func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
        if let host = url.host, host.contains("hackingwithswift.com") {
            super.open(url, options: options, completionHandler: completion)
        } else {
            completion?(false)
        }
    }
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        print("Event sent: \(event)");
    }
}

if #available(iOS 14.0, *) {
    UIApplicationMain(CommandLine.argc,
                      CommandLine.unsafeArgv,
                      NSStringFromClass(MyApplication.self),
                      NSStringFromClass(AppDelegate.self))
} else {
    
    UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))
}

