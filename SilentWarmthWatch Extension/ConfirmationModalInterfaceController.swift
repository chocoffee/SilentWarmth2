//
//  ConfirmationModalInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/15.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class ConfirmationModalInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var typeLabel: WKInterfaceLabel!
    @IBOutlet var detailLabel: WKInterfaceLabel!
    
    var data = [String : Any]()
    var str = ""
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        detailLabel.sizeToFitHeight()
        data = (context as? [String : Any])!
        setLabels(data: data)
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func startAdvertise() {
        print("data set done")
        do {
            let message:[String: Any] = data
            print("data = \(message)")
            try WCSession.default().updateApplicationContext(message)
        }catch {
            print("update application context error")
        }
    }
    
    func setLabels(data: [String : Any]){
        switch data["type"] as! String {
        case "send":
            typeLabel.setText("ゆずります")
            if let target = data["target"] as? [String] {
                detailLabel.setText("\(target.joined(separator: ","))にゆずります！服は\(data["myColor"] ?? "")です。")
            }
        case "invite":
            typeLabel.setText("席を探しています")
            if data["isEdge"] as! Bool{
                str = "端の席を希望します。"
            }
            detailLabel.setText("私は\(data["attribute"] ?? "")、服は\(data["myColor"] ?? "")です。\(str)")
            break
        case "murmur":
            typeLabel.setText("メッセージを送信する")
            detailLabel.setText("\(data["myColor"] ?? "")の服で、「\(data["message"] ?? "")」と伝えます。")
            break
        case "help":
            typeLabel.setText("助けてください")
            detailLabel.setText("\(data["oColor"] ?? "")色の服の人に痴漢されています。私は\(data["myColor"] ?? "")色です。")
            break
        default:
            break
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("hi")
    }
    
    
    
    
}
