//
//  SendWarmthViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/10.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit

class SendWarmthViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var bElderly: CheckButton!
    @IBOutlet weak var bInjured: CheckButton!
    @IBOutlet weak var bMatarnity: CheckButton!
    @IBOutlet weak var bLone: CheckButton!
    @IBOutlet weak var bSick: CheckButton!
    @IBOutlet weak var switchBg: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var checkBoxs:[CheckButton] = []
    var str = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.switchBg.layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.1374401427, blue: 0.3137254902, alpha: 1).cgColor
        self.switchBg.layer.borderWidth = 2
        self.switchBg.layer.cornerRadius = 15
        
        self.bElderly.checkButtonInit()
        self.bInjured.checkButtonInit()
        self.bMatarnity.checkButtonInit()
        self.bLone.checkButtonInit()
        self.bSick.checkButtonInit()
        
        checkBoxs.removeAll()
        
        checkBoxs.append(bElderly)
        checkBoxs.append(bInjured)
        checkBoxs.append(bMatarnity)
        checkBoxs.append(bLone)
        checkBoxs.append(bSick)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.title = "ゆずる"
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //  pickerの横列
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //  pickerの縦列
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Values.color.count
    }
    
    //  pickerに値をセット
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Values.color[row]
    }
    
    //  あらーと挟んでアドバタイズ
    @IBAction func sendWarmth(_ sender: UIButton) {
        data["type"] = "send"
        var ary = [String]()
        str = ""
        for i in 0 ..< checkBoxs.count {
            if checkBoxs[i].check {
                str.append(Values.attribute[i] + " ")
                ary.append(Values.attribute[i])
            }
        }
        data["target"] = ary
        data["myColor"] = Values.color[pickerView.selectedRow(inComponent: 0)]
        
        if str != "" {
            setAlert("ゆずる対象：\(str)\n服の色：\(data["myColor"]!)")
        }else {
            setAlert()
        }
    }
}
