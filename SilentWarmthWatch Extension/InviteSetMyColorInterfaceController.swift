//
//  InviteSetMyColorInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/16.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation


class InviteSetMyColorInterfaceController: WKInterfaceController {
    @IBOutlet var colorPicker: WKInterfacePicker!
    var color = "赤"
    var data = [String : Any]()

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        data = (context as? [String : Any])!
        setPicker()
    }
    
    func setPicker() {
        var pickerItems = [WKPickerItem]()
        for i in Values.color {
            let pickerItem = WKPickerItem()
            pickerItem.title = i
            pickerItems.append(pickerItem)
        }
        colorPicker.setItems(pickerItems)
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    @IBAction func pickerChanged(_ value: Int) {
        color = Values.color[value]
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        data["myColor"] = color
        return data
    }

}
