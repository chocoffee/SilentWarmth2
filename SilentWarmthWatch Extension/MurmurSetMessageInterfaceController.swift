//
//  MurmurSetMessageInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/16.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation

class MurmurSetMessageInterfaceController: BaseInterfaceController {
    @IBOutlet var table: WKInterfaceTable!
    var message = "子供が泣いてごめんなさい"
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        table.setNumberOfRows(Values.message.count, withRowType: "tableRow")
        for i in 0 ..< Values.message.count{
            let controller = table.rowController(at: i) as! TableRowController
            controller.messageLabel.setText(Values.message[i])
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
       
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String, in table: WKInterfaceTable, rowIndex: Int) -> Any? {
        data["type"] = "murmur"
        data["message"] = Values.message[rowIndex]
        return data
    }
}
