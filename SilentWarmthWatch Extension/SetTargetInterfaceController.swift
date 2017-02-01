//
//  SetTargetInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/13.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation


class SetTargetInterfaceController: BaseInterfaceController {
    var switches = [false, false, false, false, false]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    @IBAction func elderlyChanged(_ value: Bool) {
        if value {
            switches[0] = true
        }else {
            switches[0] = false
        }
    }
    
    @IBAction func matanityChanged(_ value: Bool) {
        if value {
            switches[1] = true
        }else {
            switches[1] = false
        }
    }
    @IBAction func loneChanged(_ value: Bool) {
        if value {
            switches[2] = true
        }else {
            switches[2] = false
        }
    }
    @IBAction func injuredChanged(_ value: Bool) {
        
        if value {
            switches[3] = true
        }else {
            switches[3] = false
        }
    }
    @IBAction func sickChanged(_ value: Bool) {
        if value {
            switches[4] = true
        }else {
            switches[4] = false
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        var ary = [String]()
        for i in 0...4 {
            if switches[i] {
                ary.append(Values.attribute[i])
            }
        }
        
        if ary == [] {
            let buttonAction = WKAlertAction(title:"OK", style: .default) {}
            presentAlert(withTitle: "エラー", message:"ゆずる相手がいません。\nゆずる相手を設定し直してください。", preferredStyle: .alert, actions: [buttonAction])
        }else {
            data["target"] = ary
            data["type"] = "send"
            return data
        }
        return []
    }
}
