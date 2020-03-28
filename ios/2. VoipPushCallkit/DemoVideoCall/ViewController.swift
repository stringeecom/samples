//
//  ViewController.swift
//  DemoVideoCall
//
//  Created by Thịnh Giò on 3/25/20.
//  Copyright © 2020 Stringee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
   
    
    @IBOutlet weak var localVideoView: UIView!
    @IBOutlet weak var remoteVideoView: UIView!
    
    @IBOutlet weak var toUserIdTextField: UITextField!
    
    @IBOutlet weak var videoCallButton: UIButton!
    @IBOutlet weak var answerButton: UIButton!
    
    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func videoCallButtonHandler(_ sender: UIButton) {
       
    }
    
    
    @IBAction func answerButtonHandler(_ sender: UIButton) {
     
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}
