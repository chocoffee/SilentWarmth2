//
//  InviteSetIsEdgeInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/16.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation


class InviteSetIsEdgeInterfaceController: WKInterfaceController {
    @IBOutlet var edgeSwitch: WKInterfaceSwitch!
    var data = [String : Any]()
    var isEdge = true

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        data = (context as? [String : Any])!
        edgeSwitch.setTitle("端の席を\n希望する")
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
    
    @IBAction func switchChanged(_ value: Bool) {
        if value {
            isEdge = true
        }else {
            isEdge = false
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        data["isEdge"] = isEdge
        return data
    }

}
