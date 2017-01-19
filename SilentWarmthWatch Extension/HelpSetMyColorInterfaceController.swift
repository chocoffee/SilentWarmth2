//
//  HelpSetMyColorInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/15.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation


class HelpSetMyColorInterfaceController: WKInterfaceController {
    @IBOutlet var colorPicker: WKInterfacePicker!

    var color = "赤"
    var data = [String : Any]()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        data["type"] = "help"
        setPicker()
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
    
    func setPicker() {
        var pickerItems = [WKPickerItem]()
        for i in Values.color {
            let pickerItem = WKPickerItem()
            pickerItem.title = i
            pickerItems.append(pickerItem)
        }
        colorPicker.setItems(pickerItems)
    }
    
    @IBAction func pickerChanged(_ value: Int) {
        color = Values.color[value]
        print(color)
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        data["myColor"] = color
        return data
    }
}
