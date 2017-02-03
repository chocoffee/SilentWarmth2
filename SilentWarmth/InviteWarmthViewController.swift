//
//  InviteWarmthViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/14.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit


class InviteWarmthViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var isEdge: UISwitch!
    
    @IBOutlet weak var bElderly: UIButton!
    @IBOutlet weak var bInjured: UIButton!
    @IBOutlet weak var bMatarnity: UIButton!
    @IBOutlet weak var bLone: UIButton!
    @IBOutlet weak var bSick: UIButton!
    
    @IBOutlet weak var backView: UIView!
    
    var selected = [true, false, false, false, false]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.backView.layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.1374401427, blue: 0.3137254902, alpha: 1).cgColor
        self.backView.layer.borderWidth = 2
        self.backView.layer.cornerRadius = 15
        
        colorPicker.delegate = self
        colorPicker.dataSource = self
        
        self.bElderly.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.bInjured.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.bMatarnity.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.bLone.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.bSick.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        
        self.title = "座席を要請する"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //  pickerの横列のアレ
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //  pickerの縦列のアレ
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return Values.attribute.count
        }else{
            return Values.color.count
        }
    }
    
    //  pickerに値をセット
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return Values.attribute[row]
        }else {
            return Values.color[row]
        }
    }
    
    //  あらーと挟んでアドバタイズ
    @IBAction func inviteWarmth(_ sender: UIButton) {
        data["type"] = "invite"
        var str = ""
        
        var index = -1
        for i in 0...4 {
            if selected[i] {
                index = i
            }
        }
        
        data["attribute"] = Values.attribute[index]
        data["myColor"] = Values.color[colorPicker.selectedRow(inComponent: 0)]
        data["isEdge"] = isEdge.isOn
        print("data@invite\(data)")
        
        str.append("あなたは\(Values.attribute[index])\n")
        str.append("服の色：\(Values.color[colorPicker.selectedRow(inComponent: 0)])")
        if isEdge.isOn {
            str.append("\n端の席を希望する")
        }
        setAlert(str)
    }
    
    func setSelected() {
        let buttons = [bElderly, bInjured, bMatarnity, bLone, bSick]
        let pict: [UIImage] = [UIImage(named:"pictgram_01-x1.png")!, UIImage(named:"pictgram_02-x1.png")!,
                               UIImage(named:"pictgram_03-x1.png")!, UIImage(named:"pictgram_04-x1.png")!,
                               UIImage(named:"pictgram_05-x1.png")!]
        let pictGray: [UIImage] = [UIImage(named:"pictgram_gray_1.png")!, UIImage(named:"pictgram_gray_2.png")!,
                                   UIImage(named:"pictgram_gray_3.png")!, UIImage(named:"pictgram_gray_4.png")!,
                                   UIImage(named:"pictgram_gray_5.png")!]
        for i in 0...4 {
            if self.selected[i] {
                buttons[i]?.setImage(pict[i], for: UIControlState.normal)
            }else {
                buttons[i]?.setImage(pictGray[i], for: UIControlState.normal)
            }
        }
    }
    
    @IBAction func bElderlyTapped(_ sender: UIButton) {
        self.selected = [true, false, false, false, false]
        setSelected()
    }
    
    @IBAction func bInjuredTapped(_ sender: UIButton) {
        self.selected = [false, true, false, false, false]
        setSelected()
    }
    
    @IBAction func bMatarnityTapped(_ sender: UIButton) {
        self.selected = [false, false, true, false, false]
        setSelected()
    }
    
    @IBAction func bLoneTapped(_ sender: UIButton) {
        self.selected = [false, false, false, true, false]
        setSelected()
    }
    
    @IBAction func bSickTapped(_ sender: UIButton) {
        self.selected = [false, false, false, false, true]
        setSelected()
    }
}
