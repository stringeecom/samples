//
//  ViewController.swift
//  DemoVideoCall
//
//  Created by Thịnh Giò on 3/25/20.
//  Copyright © 2020 Stringee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // user1
//    let myToken = "eyJjdHkiOiJzdHJpbmdlZS1hcGk7dj0xIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJqdGkiOiJTS0Z1enZyQ3o0NUNoY0RZOEFOdkRKUnRCeG9oY3lCdmdoLTE1ODUxMzQ4MDQiLCJpc3MiOiJTS0Z1enZyQ3o0NUNoY0RZOEFOdkRKUnRCeG9oY3lCdmdoIiwiZXhwIjoxNTg3NzI2ODA0LCJ1c2VySWQiOiJ1c2VyMSIsImljY19hcGkiOnRydWV9.efYYqfCF7jv2p5XSaC8triqpTM2suJc_q76kGFGAOBs"
    
    // user2
    let myToken = "eyJjdHkiOiJzdHJpbmdlZS1hcGk7dj0xIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJqdGkiOiJTS0Z1enZyQ3o0NUNoY0RZOEFOdkRKUnRCeG9oY3lCdmdoLTE1ODUxMzQ4MzAiLCJpc3MiOiJTS0Z1enZyQ3o0NUNoY0RZOEFOdkRKUnRCeG9oY3lCdmdoIiwiZXhwIjoxNTg3NzI2ODMwLCJ1c2VySWQiOiJ1c2VyMiIsImljY19hcGkiOnRydWV9.y0cBCWtHAD6MXdKr9ASM_55IeqPJ2Ocfq2IIQ8IKMM4"
    
    
    var stringeeClient: StringeeClient!
    var stringeeCall: StringeeCall?
    
    @IBOutlet weak var localVideoView: UIView!
    @IBOutlet weak var remoteVideoView: UIView!
    
    @IBOutlet weak var toUserIdTextField: UITextField!
    
    @IBOutlet weak var videoCallButton: UIButton!
    @IBOutlet weak var answerButton: UIButton!
    
    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stringeeClient = StringeeClient(connectionDelegate: self)
        stringeeClient.connect(withAccessToken: myToken)
        stringeeClient.incomingCallDelegate = self
    }
    
    @IBAction func videoCallButtonHandler(_ sender: UIButton) {
        guard isConnected, let currentUserId = stringeeClient.userId else { return }
        stringeeCall = StringeeCall(stringeeClient: stringeeClient, from: currentUserId, to: toUserIdTextField.text)
        stringeeCall?.isVideoCall = true
        stringeeCall?.delegate = self
        stringeeCall?.make(completionHandler: { (status, code, message, data) in
            print(message ?? "")
        })
    }
    
    
    @IBAction func answerButtonHandler(_ sender: UIButton) {
        stringeeCall?.initAnswer()
        stringeeCall?.answer(completionHandler: { (status, code, message) in
            print(message ?? "")
        })
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

extension ViewController: StringeeConnectionDelegate {
    func requestAccessToken(_ stringeeClient: StringeeClient!) {
        
    }
    
    func didConnect(_ stringeeClient: StringeeClient!, isReconnecting: Bool) {
        print("didConnect with user: \(stringeeClient.userId ?? "")")
        isConnected = true
    }
    
    func didDisConnect(_ stringeeClient: StringeeClient!, isReconnecting: Bool) {
        
    }
    
    func didFailWithError(_ stringeeClient: StringeeClient!, code: Int32, message: String!) {
        
    }
}

extension ViewController: StringeeCallDelegate {
    func didChangeSignalingState(_ stringeeCall: StringeeCall!, signalingState: SignalingState, reason: String!, sipCode: Int32, sipReason: String!) {
        
    }
    
    func didChangeMediaState(_ stringeeCall: StringeeCall!, mediaState: MediaState) {
        
    }
    
    func didReceiveLocalStream(_ stringeeCall: StringeeCall!) {
        DispatchQueue.main.async {
            stringeeCall.localVideoView.frame = CGRect(origin: .zero, size: self.localVideoView.frame.size)
            self.localVideoView.addSubview(stringeeCall.localVideoView)
        }
    }
    
    func didReceiveRemoteStream(_ stringeeCall: StringeeCall!) {
        DispatchQueue.main.async {
            stringeeCall.remoteVideoView.frame = CGRect(origin: .zero, size: self.remoteVideoView.frame.size)
            self.remoteVideoView.addSubview(stringeeCall.remoteVideoView)
        }
    }
}

extension ViewController: StringeeIncomingCallDelegate {
    func incomingCall(with stringeeClient: StringeeClient!, stringeeCall: StringeeCall!) {
        self.stringeeCall = stringeeCall
        stringeeCall.delegate = self
        
        answerButton.isEnabled = true
        videoCallButton.isEnabled = false
    }
}
