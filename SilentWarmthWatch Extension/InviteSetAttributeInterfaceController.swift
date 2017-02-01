//
//  InviteSetAttributeInterfaceController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/16.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import WatchKit
import Foundation

class InviteSetAttributeInterfaceController: BaseInterfaceController {
    @IBOutlet var picker: WKInterfacePicker!

    var attribute = "お年寄り"

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        setPicker()
    }

    func setPicker() {
        var pickerItems = [WKPickerItem]()
        for i in Values.attribute {
            let pickerItem = WKPickerItem()
            pickerItem.title = i
            pickerItems.append(pickerItem)
        }
        picker.setItems(pickerItems)
    }
    
    @IBAction func pickerChanged(_ value: Int) {
        attribute = Values.attribute[value]
    }
    
    override func contextForSegue(withIdentifier segueIdentifier: String) -> Any? {
        data["attribute"] = attribute
        data["type"] = "invite"
        return data
    }
}
