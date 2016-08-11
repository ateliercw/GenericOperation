//
//  AppDelegate.swift
//  GenericOperationExample
//
//  Created by Michael Skiba on 8/10/16.
//  Copyright © 2016 Atelier Clockwork. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let navigation = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        return true
    }

}
