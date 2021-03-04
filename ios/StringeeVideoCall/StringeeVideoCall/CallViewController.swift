//
//  CallViewController.swift
//  StringeeVideoCall
//
//  Created by HoangDuoc on 3/3/21.
//

import UIKit

class CallViewController: UIViewController {

    @IBOutlet weak var localView: UIView!
    
    var from: String!
    var to: String!
    var client: StringeeClient!
    var call: StringeeCall2!
    
    init(from: String, to: String, client: StringeeClient) {
        super.init(nibName: "CallViewController", bundle: nil)
        self.from = from
        self.to = to
        self.client = client
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        call = StringeeCall2(stringeeClient: client, from: from, to: to)
        call?.isVideoCall = true
        call?.delegate = self
        call?.make(completionHandler: { (status, code, message, data) in
            if !status {
                self.dismissVC()
            }
        })
    }
    
    @IBAction func endTapped(_ sender: Any) {
        call.hangup { (status, code, message) in
            if !status {
                self.dismissVC()
            }
        }
    }
    
    private func dismissVC() {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension CallViewController: StringeeCall2Delegate {
    func didChangeSignalingState2(_ stringeeCall2: StringeeCall2!, signalingState: SignalingState, reason: String!, sipCode: Int32, sipReason: String!) {
        print("didChangeSignalingState2: \(signalingState)")
        if signalingState == .ended || signalingState == .busy {
            dismissVC()
        }
    }
    
    func didChangeMediaState2(_ stringeeCall2: StringeeCall2!, mediaState: MediaState) {
        print("didChangeMediaState2: \(mediaState)")
    }
    
    func didReceiveLocalStream2(_ stringeeCall2: StringeeCall2!) {
        DispatchQueue.main.async {
            stringeeCall2.localVideoView.frame = CGRect(origin: .zero, size: self.localView.frame.size)
            self.localView.addSubview(stringeeCall2.localVideoView)
        }
    }
    
    func didReceiveRemoteStream2(_ stringeeCall2: StringeeCall2!) {
        DispatchQueue.main.async {
            stringeeCall2.remoteVideoView.frame = CGRect(origin: .zero, size: self.view.frame.size)
            self.view.insertSubview(stringeeCall2.remoteVideoView, at: 0)
        }
    }
}

