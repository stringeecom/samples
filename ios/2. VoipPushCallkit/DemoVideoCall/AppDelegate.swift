//
//  AppDelegate.swift
//  DemoVideoCall
//
//  Created by Thịnh Giò on 3/25/20.
//  Copyright © 2020 Stringee. All rights reserved.
//

import UIKit
import PushKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        StringeeCallCenter.shared.connectToStringeeServer()
        voipRegistration()
        
        return true
    }
    
    
    func voipRegistration() {
        let pushRegistry = PKPushRegistry(queue: DispatchQueue.main)
        pushRegistry.delegate = self
        pushRegistry.desiredPushTypes = [.voIP]
    }
}

extension AppDelegate: PKPushRegistryDelegate {
    func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        StringeeCallCenter.shared.registerPush(with: pushCredentials)
    }
    
    func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        StringeeCallCenter.shared.reportNewIncommingCall(with: "Connecting...")
    }
    
}

