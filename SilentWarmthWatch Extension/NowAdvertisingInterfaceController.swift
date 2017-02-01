//
//  NowAdvertisingInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2017/01/23.
//  Copyright © 2017年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class NowAdvertisingInterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var typeLabel: WKInterfaceLabel!
    @IBOutlet var detailLabel: WKInterfaceLabel!
    
    var stop:[String : Bool] = [:]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if (WCSession.isSupported()) {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        
        let data = KeepData.keepData
        let type = data["type"] as? String ?? ""
        typeLabel.setText(type)
        print(data)
        switch type {
        case "send":
            var str = ""
            typeLabel.setText("ゆずります")
            if let target = data["target"] as? [String] {
                str = target.joined(separator: ",")
            }
            detailLabel.setText("ゆずる人：\n\(str)\n服の色：\(data["myColor"] ?? "")")
        case "invite" :
            typeLabel.setText("席を探しています")
            var str = ""
            if data["isEdge"] as? Bool ?? false {
                str.append("端の席を希望する")
            }
            detailLabel.setText("\(data["attribute"] ?? "")\n服の色：\(data["myColor"] ?? "")\n\(str)")
        case "murmur":
            typeLabel.setText("メッセージを送信する")
            detailLabel.setText("メッセージ：\(data["message"] ?? "")\n服の色：\(data["myColor"] ?? "")")
        case "help":
            typeLabel.setText("助けてください")
            detailLabel.setText("あなたの服の色：\(data["myColor"] ?? "")\n相手の服の色：\(data["oColor"] ?? "")")
        default:
            typeLabel.setText("現在未発信")
            detailLabel.setText("発信していません")
            break
        }
    }

    override func willActivate() {
        super.willActivate()
    }

    override func didDeactivate() {
        super.didDeactivate()
    }

    @IBAction func bCancelTapped() {
        let buttonAction = WKAlertAction(title:"キャンセル", style: .cancel) {}
        let buttonAction2 = WKAlertAction(title: "OK", style: .default, handler: stopSession)
        presentAlert(withTitle: "確認", message:"発信を終了しますか？", preferredStyle: .alert, actions: [buttonAction, buttonAction2])
    }
    
    func stopSession() {
        do {
            stop["stop"] = true
            print("stopsession begin")
            typeLabel.setText("")
            detailLabel.setText("")
            try WCSession.default().updateApplicationContext(stop)
        }catch {
            print("update application context error")
        }
        pop()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("hi")
    }
}
