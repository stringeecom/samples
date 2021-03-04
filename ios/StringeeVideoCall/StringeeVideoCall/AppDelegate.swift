//
//  AppDelegate.swift
//  StringeeVideoCall
//
//  Created by HoangDuoc on 3/3/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = MainViewController(nibName: "MainViewController", bundle: nil)
        let navi = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = navi
        window?.makeKeyAndVisible()

        return true
    }
}

