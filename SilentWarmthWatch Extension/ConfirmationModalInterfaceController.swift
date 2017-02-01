//
//  ConfirmationModalInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/15.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class ConfirmationModalInterfaceController: BaseInterfaceController {

    @IBOutlet var typeLabel: WKInterfaceLabel!
    @IBOutlet var detailLabel: WKInterfaceLabel!
    
    var str = ""
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        detailLabel.sizeToFitHeight()
        setLabels(data: data)
    }
    
    func setLabels(data: [String : Any]){
        switch data["type"] as! String {
        case "send":
            typeLabel.setText("ゆずります")
            if let target = data["target"] as? [String] {
                detailLabel.setText("\(target.joined(separator: ","))にゆずります！服は\(data["myColor"] ?? "")です。")
            }
        case "invite":
            typeLabel.setText("席を探しています")
            if data["isEdge"] as! Bool{
                str = "端の席を希望します。"
            }
            detailLabel.setText("私は\(data["attribute"] ?? "")、服は\(data["myColor"] ?? "")です。\(str)")
            break
        case "murmur":
            typeLabel.setText("メッセージを送信する")
            detailLabel.setText("\(data["myColor"] ?? "")の服で、「\(data["message"] ?? "")」と伝えます。")
            break
        case "help":
            typeLabel.setText("助けてください")
            detailLabel.setText("\(data["oColor"] ?? "")色の服の人に痴漢されています。私は\(data["myColor"] ?? "")色です。")
            break
        default:
            break
        }
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        setBackData()
        
        return data
    }
    
    override func backToRoot() {
        dismiss()
    }
}
