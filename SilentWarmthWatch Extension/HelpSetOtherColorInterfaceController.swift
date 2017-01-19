//
//  HelpSetOtherColorInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/15.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation


class HelpSetOtherColorInterfaceController: WKInterfaceController {
    @IBOutlet var colorPicker: WKInterfacePicker!

    var data = [String : Any]()
    var color = "赤"
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        data = (context as? [String : Any])!
        print("colorVC\(data)")
        setPicker()
        // Configure interface objects here.
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
        data["oColor"] = color
        return data
    }
    
}
