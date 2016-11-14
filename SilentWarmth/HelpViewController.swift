//
//  HelpViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/11.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userColor: UIPickerView!
    @IBOutlet weak var otherColor: UIPickerView!
    var user = ""
    var other = ""

    let colorArray = ["赤", "青", "黄", "黒", "白"]
    
    override func viewDidLoad() {
        closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
        
        userColor.delegate = self
        userColor.dataSource = self
        
        otherColor.delegate = self
        otherColor.dataSource = self
    }

    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return colorArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.colorArray[row]
    }

    @IBAction func sendHelp(_ sender: UIButton) {
        let userNumber = userColor.selectedRow(inComponent: 0)
        let otherNumber = otherColor.selectedRow(inComponent: 0)
        
        print("user = \(colorArray[userNumber]) / other = \(colorArray[otherNumber])")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
