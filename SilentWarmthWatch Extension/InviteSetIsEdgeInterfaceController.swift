//
//  InviteSetIsEdgeInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/16.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation


class InviteSetIsEdgeInterfaceController: BaseInterfaceController{
    @IBOutlet var edgeSwitch: WKInterfaceSwitch!
    var isEdge = true

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        edgeSwitch.setTitle("端の席を\n希望する")
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
        setBackData()
        return data
    }
    
    override func backToRoot() {
        self.popToRootController()
    }
}
