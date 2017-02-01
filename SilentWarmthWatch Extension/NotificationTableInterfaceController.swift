//
//  NotificationTableInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2017/01/20.
//  Copyright © 2017年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation


class NotificationTableInterfaceController: WKInterfaceController {

    var data = [[String : Any]]()
    @IBOutlet var notiTable: WKInterfaceTable!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        data = context as! [[String : Any]]
        
        self.notiTable.setNumberOfRows(data.count, withRowType: "TestRow")
        for index in 0..<self.data.count {
            let theRow = self.notiTable.rowController(at: index) as! TestRow
            
            let tmp = data[index]
            var str = ""
            
            if tmp["type"] != nil {
                switch tmp["type"] as! String {
                case "send":
                    theRow.row.setText("ゆずります")
                    if let target = tmp["target"] as? [String] {
                        theRow.detailLabel.setText("\(target.joined(separator: ","))にゆずります！服は\(tmp["myColor"] ?? "")です。")
                    }
                case "invite":
                    theRow.row.setText("席を探しています")
                    if tmp["isEdge"] as! Bool{
                        str = "端の席を希望します。"
                    }
                    theRow.detailLabel.setText("私は\(tmp["attribute"] ?? "")、服は\(tmp["myColor"] ?? "")です。\(str)")
                case "murmur":
                    theRow.row.setText("メッセージを受信しました")
                    theRow.detailLabel.setText("\(tmp["myColor"] ?? "")の服の人が「\(tmp["message"] ?? "")」と言っています。")
                case "help":
                    theRow.row.setText("助けてください")
                    theRow.detailLabel.setText("\(tmp["oColor"] ?? "")色の服の人に痴漢されています。私は\(tmp["myColor"] ?? "")色です。")
                default:
                    break
                }
            }
        }
    }
}
