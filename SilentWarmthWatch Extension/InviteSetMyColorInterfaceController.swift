//
//  InviteSetMyColorInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/16.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation

class InviteSetMyColorInterfaceController: BaseInterfaceController {
    @IBOutlet var colorPicker: WKInterfacePicker!
    var color = "赤"

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
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
    
    @IBAction func pickerChanged(_ value: Int) {
        color = Values.color[value]
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        data["myColor"] = color
        return data
    }

}
