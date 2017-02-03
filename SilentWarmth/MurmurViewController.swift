//
//  MurmurViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/14.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit

class MurmurViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var messagePicker: UIPickerView!
    @IBOutlet weak var colorPicker: UIPickerView!
    
    var advertiseData = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messagePicker.delegate = self
        messagePicker.dataSource = self
        colorPicker.delegate = self
        colorPicker.dataSource = self
        self.title = "周囲に発信する"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return Values.message.count
        }else {
            return Values.color.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return Values.message[row]
        }else {
            return Values.color[row]
        }
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
        data["type"] = "murmur"
        data["message"] = Values.message[messagePicker.selectedRow(inComponent: 0)]
        data["myColor"] = Values.color[colorPicker.selectedRow(inComponent: 0)]
        let messageIndex = messagePicker.selectedRow(inComponent: 0)
        let colorIndex = colorPicker.selectedRow(inComponent: 0)
        var str = ""
        self.advertiseData = [[2], [messageIndex], [colorIndex]]
        str.append("\(Values.message[messageIndex]),\n服の色：\(Values.color[colorIndex])")
        setAlert(str)
    }    
}
