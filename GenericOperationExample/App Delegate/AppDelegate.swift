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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let navigation = UINavigationController(rootViewController: MainViewController())
        navigation.view.backgroundColor = .white
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        return true
    }

}
