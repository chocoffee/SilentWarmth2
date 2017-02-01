//
//  HelpViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/11.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit

class HelpViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userColor: UIPickerView!
    @IBOutlet weak var otherColor: UIPickerView!
    
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
        return Values.color.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Values.color[row]
    }

    @IBAction func sendHelp(_ sender: UIButton) {
        data["type"] = "help"
        var str = ""
        
        data["myColor"] = Values.color[userColor.selectedRow(inComponent: 0)]
        data["oColor"] = Values.color[otherColor.selectedRow(inComponent: 0)]
        
        str.append("あなたの服の色：\(Values.color[userColor.selectedRow(inComponent: 0)])")
        str.append("\n相手の服の色：\(Values.color[otherColor.selectedRow(inComponent: 0)])")
        setAlert(str)
    }
    
    override func preparetion() {
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "MatchViewController")
        if let tmp = nextVC as? MatchViewController{
            tmp.data = data
            tmp.back = self
            tmp.vc = vc
        }
        present(nextVC, animated: true, completion: nil)
    }
}
