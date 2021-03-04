//
//  MainViewController.swift
//  StringeeVideoCall
//
//  Created by HoangDuoc on 3/3/21.
//

import UIKit

let token = "eyJjdHkiOiJzdHJpbmdlZS1hcGk7dj0xIiwidHlwIjoiSldUIiwiYWxnIjoiSFMyNTYifQ.eyJqdGkiOiJTS2lidFVaakx0Yk5kdUMwMFJQM3hSWm5nQXBMRHVwZGNLLTE2MTQ3NDM3NDUiLCJpc3MiOiJTS2lidFVaakx0Yk5kdUMwMFJQM3hSWm5nQXBMRHVwZGNLIiwiZXhwIjoxNjE3MzM1NzQ1LCJ1c2VySWQiOiJ1c2VyMSJ9.sTVHbZNkYq1lVkYQJuVVI1yHMM6dO2JSulvTZEL3WeY"

class MainViewController: UIViewController {
    
    let client = StringeeClient()
    
    @IBOutlet weak var tfHotline: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Kết nối"
        view.backgroundColor = .white
        
        client.connectionDelegate = self;
        client.incomingCallDelegate = self;
        
        client.connect(withAccessToken: token)
    }
    
    @IBAction func callTapped(_ sender: Any) {
        if !client.hasConnected {
            return
        }
        
        guard let hotline = tfHotline.text, !hotline.isEmpty else {
            return
        }
        
        let callVC = CallViewController(from: client.userId, to: hotline, client: client)
        callVC.modalPresentationStyle = .fullScreen
        present(callVC, animated: true, completion: nil)
    }
    
}

extension MainViewController: StringeeConnectionDelegate {
    func requestAccessToken(_ stringeeClient: StringeeClient!) {
        
    }
    
    func didConnect(_ stringeeClient: StringeeClient!, isReconnecting: Bool) {
        print("KET NOI THANH CONG TOI STRINGE SERVER, userId: \(String(describing: stringeeClient.userId))")
        DispatchQueue.main.async {
            self.navigationItem.title = stringeeClient.userId
        }
    }
    
    func didDisConnect(_ stringeeClient: StringeeClient!, isReconnecting: Bool) {
        print("MAT KET NOI TOI STRINGEE SERVER...")
    }
    
    func didFailWithError(_ stringeeClient: StringeeClient!, code: Int32, message: String!) {
        
    }
}

extension MainViewController: StringeeIncomingCallDelegate {
    func incomingCall(with stringeeClient: StringeeClient!, stringeeCall: StringeeCall!) {
        
    }
}
