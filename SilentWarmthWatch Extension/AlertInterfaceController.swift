//
//  AlertInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2017/01/26.
//  Copyright © 2017年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class AlertInterfaceController: BaseInterfaceController,WCSessionDelegate{

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        self.setTitle("")
        
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
    }
    
    @IBAction func onTapOkay() {
        dataSend()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("hi")
    }
    
    private func dataSend() {
        print("data set done")
        var newData:[String:Any] = [:]
        for (key,value) in data {
            if !key.contains("back") {
                newData[key] = value
            }
        }
        do {
            print("data = \(newData)")
            try WCSession.default().updateApplicationContext(newData)
        }catch {
            print("update application context error")
        }
        KeepData.keepData = newData
        dismiss()
        for i in 1 ..< 100 {
            if let back = data[String(format: "back%02d",i)] as? BackToRootDelegate {
                back.backToRoot()
                continue
            }
            break
        }
    }
}
