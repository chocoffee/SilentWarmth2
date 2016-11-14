//
//  MurmurViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/14.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit

class MurmurViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var messagePicker: UIPickerView!
    @IBOutlet weak var colorPicker: UIPickerView!
    
    let message = ["子供が泣いてごめんなさい", "寝てしまってごめんなさい", "荷物が多くてごめんなさい"]
    let color = ["赤", "青", "黄", "白", "黒"]
    override func viewDidLoad() {
        super.viewDidLoad()

        self.messagePicker.delegate = self
        self.messagePicker.dataSource = self
        self.colorPicker.delegate = self
        self.colorPicker.dataSource = self
        self.title = "周囲に発信する"
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
        if pickerView.tag == 1 {
            return self.message.count
        }else {
            return self.color.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return self.message[row]
        }else {
            return self.color[row]
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func sendMessage(_ sender: UIButton) {
    }

}
