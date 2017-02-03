//
//  BaseInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2017/01/26.
//  Copyright © 2017年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation


class BaseInterfaceController: WKInterfaceController,BackToRootDelegate{
    var data:[String : Any] = [:]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let data = context as? [String : Any] {
            self.data = data
        }
        // Configure interface objects here.
    }
    
    func setBackData(){
        for i in 1 ..< 100 {
            let name = String(format: "back%02d",i)
            if data[name] == nil {
                data[name] = self
                break
            }
        }
    }
    
    func backToRoot() {
        
    }
}
