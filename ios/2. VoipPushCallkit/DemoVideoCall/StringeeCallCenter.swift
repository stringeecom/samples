//
//  StringeeCallCenter.swift
//  DemoVideoCall
//
//  Created by Thịnh Giò on 3/27/20.
//  Copyright © 2020 Stringee. All rights reserved.
//

import Foundation
import PushKit
import CallKit

class StringeeCallCenter: NSObject {
    static var shared = StringeeCallCenter()
    
    private override init() {
        super.init()
        
        stringeeClient = StringeeClient(connectionDelegate: self)
        stringeeClient.incomingCallDelegate = self
    }
    
    // user1
    let myToken = "eyJjdHkiOiJzdHJpbmdlZS1hcGk7dj0xIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJqdGkiOiJTS0Z1enZyQ3o0NUNoY0RZOEFOdkRKUnRCeG9oY3lCdmdoLTE1ODUxMzQ4MDQiLCJpc3MiOiJTS0Z1enZyQ3o0NUNoY0RZOEFOdkRKUnRCeG9oY3lCdmdoIiwiZXhwIjoxNTg3NzI2ODA0LCJ1c2VySWQiOiJ1c2VyMSIsImljY19hcGkiOnRydWV9.efYYqfCF7jv2p5XSaC8triqpTM2suJc_q76kGFGAOBs"
    
    // user2
    //    let myToken = "eyJjdHkiOiJzdHJpbmdlZS1hcGk7dj0xIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJqdGkiOiJTS0Z1enZyQ3o0NUNoY0RZOEFOdkRKUnRCeG9oY3lCdmdoLTE1ODUxMzQ4MzAiLCJpc3MiOiJTS0Z1enZyQ3o0NUNoY0RZOEFOdkRKUnRCeG9oY3lCdmdoIiwiZXhwIjoxNTg3NzI2ODMwLCJ1c2VySWQiOiJ1c2VyMiIsImljY19hcGkiOnRydWV9.y0cBCWtHAD6MXdKr9ASM_55IeqPJ2Ocfq2IIQ8IKMM4"
    
    
    var stringeeClient: StringeeClient!
    var stringeeCall: StringeeCall?
    
    var fromCallerName: String?
    var currentCallID: UUID?
    
    private lazy var provider: CXProvider? = {
        let config = CXProviderConfiguration(localizedName: "Stringee")
        config.supportsVideo = true
        config.maximumCallGroups = 1
        config.maximumCallsPerCallGroup = 1
        config.supportedHandleTypes = [.generic]
        config.includesCallsInRecents = true
        
        let provider = CXProvider(configuration: config)
        provider.setDelegate(self, queue: DispatchQueue.main)
        
        return provider
    }()
    
    func connectToStringeeServer() {
        stringeeClient.connect(withAccessToken: myToken)
    }
    
    func registerPush(with pushCredentials: PKPushCredentials) {
        let deviceId = pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined()
        stringeeClient.registerPush(forDeviceToken: deviceId, isProduction: false, isVoip: true) { (status, code, message) in
            print(message ?? "")
        }
    }
    
    func reportNewIncommingCall(with user: String) {
        let userName: String = fromCallerName ?? user
        
        let updater = CXCallUpdate()
        updater.remoteHandle = CXHandle(type: .generic, value: userName)
        
        let uuid = UUID()
        currentCallID = uuid
        provider?.reportNewIncomingCall(with: uuid, update: updater, completion: { (error) in
            print(error.debugDescription)
        })
    }
    
    private func updateInforCall() {
        guard let id = currentCallID else { return }
        DispatchQueue.main.async {
            let callUpdater = CXCallUpdate()
            callUpdater.remoteHandle = CXHandle(type: .generic, value: self.fromCallerName ?? "")
            self.provider?.reportCall(with: id, updated: callUpdater)
        }
    }
}


extension StringeeCallCenter: StringeeConnectionDelegate {
    func requestAccessToken(_ stringeeClient: StringeeClient!) {
        
    }
    
    func didConnect(_ stringeeClient: StringeeClient!, isReconnecting: Bool) {
        print("didConnect with user: \(stringeeClient.userId ?? "")")
        
    }
    
    func didDisConnect(_ stringeeClient: StringeeClient!, isReconnecting: Bool) {
        
    }
    
    func didFailWithError(_ stringeeClient: StringeeClient!, code: Int32, message: String!) {
        
    }
}

extension StringeeCallCenter: StringeeCallDelegate {
    func didChangeSignalingState(_ stringeeCall: StringeeCall!, signalingState: SignalingState, reason: String!, sipCode: Int32, sipReason: String!) {
        
    }
    
    func didChangeMediaState(_ stringeeCall: StringeeCall!, mediaState: MediaState) {
        
    }
    
    func didReceiveLocalStream(_ stringeeCall: StringeeCall!) {
        
    }
    
    func didReceiveRemoteStream(_ stringeeCall: StringeeCall!) {
        
    }
}

extension StringeeCallCenter: StringeeIncomingCallDelegate {
    func incomingCall(with stringeeClient: StringeeClient!, stringeeCall: StringeeCall!) {
        self.stringeeCall = stringeeCall
        self.fromCallerName = stringeeCall.fromAlias
        
        if currentCallID != nil {
            updateInforCall()
        }
    }
}

extension StringeeCallCenter: CXProviderDelegate {
    func providerDidReset(_ provider: CXProvider) {
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        stringeeCall?.initAnswer()
        stringeeCall?.answer(completionHandler: { (status, code, message) in
            print(message ?? "")
        })
    }
}
