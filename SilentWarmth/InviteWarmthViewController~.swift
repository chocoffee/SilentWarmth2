//
//  InviteWarmthViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/14.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit

class InviteWarmthViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var attributePicker: UIPickerView!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var isEdge: UISwitch!
    
    let attribute = ["お年寄り", "妊婦さん", "子連れさん", "けが人", "体調不良"]
    let color = ["赤", "青", "黄", "白", "黒"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        attributePicker.delegate = self
        attributePicker.dataSource = self
        colorPicker.delegate = self
        colorPicker.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("tag = \(pickerView.tag)")
        if pickerView.tag == 1 {
            return self.attribute.count
        }else{
            return self.color.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return self.attribute[row]
        }else {
            return self.color[row]
        }
    }
    
    

    @IBAction func inviteWarmth(_ sender: UIButton) {
    }
}
