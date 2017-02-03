//
//  InterfaceController.swift
//  SilentWarmthWatch Extension
//
//  Created by guest on 2016/12/13.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

protocol BackToRootDelegate {
    func backToRoot()
}

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var ary = [[String : Any]]()
    var data = [String : Any]()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        ary.append(userInfo)
        print(ary)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("hi")
        if error != nil {
            print("error ::: \(error)")
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        if segueIdentifier == "NotifySegue" {
            print("before segue ::: \(ary)")
            return ary
        }
        return nil
    }
}
