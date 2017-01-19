//
//  MurmurSetMessageInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/16.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation

class MurmurSetMessageInterfaceController: WKInterfaceController {
    @IBOutlet var table: WKInterfaceTable!
    let messages = ["子供が泣いて\nごめんなさい", "寝てしまって\nごめんなさい", "荷物が多くて\nごめんなさい"]
    var message = "子供が泣いてごめんなさい"
    var data = [String : Any]()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        table.setNumberOfRows(messages.count, withRowType: "tableRow")
        for i in 0...2{
            let controller = table.rowController(at: i) as! TableRowController
            controller.messageLabel.setText(messages[i])
            message = Values.message[i]
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
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        data["type"] = "murmur"
        data["message"] = message
        return data
    }
}
