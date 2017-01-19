//
//  SendWarmthViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/10.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit
import CoreBluetooth
import SwiftyJSON

extension UIView {
    
    // 枠線の色
    @IBInspectable var borderColor: UIColor? {
        get {
            return layer.borderColor.map { UIColor(cgColor: $0) }
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    // 枠線のWidth
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // 角丸設定
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}

class SendWarmthViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CBPeripheralDelegate, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var sElderly: UISwitch!
    @IBOutlet weak var sMaternity: UISwitch!
    @IBOutlet weak var sLone: UISwitch!
    @IBOutlet weak var sInjured: UISwitch!
    @IBOutlet weak var sSick: UISwitch!
    @IBOutlet weak var pickerView: UIPickerView!
    let alert = AleatBase() //  Alertの親クラス
    var data = [String : Any]()
    var str = ""
    var vc:ViewControllerDelegate?
    
    var peripheral: CBPeripheral!
    var peripheralManager: CBPeripheralManager!
    var characteristic: CBMutableCharacteristic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        self.title = "ゆずる"
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationItem.backBarButtonItem = backButton
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
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
        let switches = [sElderly, sMaternity, sLone, sInjured, sSick]  //  該当者を配列に入れる
        var ary = [String]()
        str = ""
        for i in 0...4 {
            if switches[i]!.isOn {
                str.append(Values.attribute[i] + "、")
                ary.append(Values.attribute[i])
            }
        }
        data["target"] = ary
        data["myColor"] = Values.color[pickerView.selectedRow(inComponent: 0)]
        
        if str != "" {
            setAlert("ゆずる対象\(str)\n服：\(data["myColor"]!)")
        }else {
            setAlert()
        }
    }
    
    //  ゆずる対象者がいた時（入力に不備がない時）
    func setAlert(_ str: String) {
        alert.alert("発信する！", btn2: "キャンセル", title: "確認", subTitle: str, advertise: advertise)
    }
    
    //  ゆずる対象がいない場合
    func setAlert() {
        alert.alert("OK", title: "エラー", subTitle: "ゆずる相手がいません")
    }
    
    //  必須メソッド
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("state: \(peripheral.state)")
    }

    //  クロージャ用メソッド
    func advertise() {
        guard let json = try? JSONSerialization.data(withJSONObject: data, options: .init(rawValue: 0)) else{
            return
        }
        let serviceUUID = CBUUID(string: Uuids.serviceUUID)
        let service = CBMutableService(type: serviceUUID, primary: true)
        let charactericUUID = CBUUID(string: Uuids.characteristicUUID)
        characteristic = CBMutableCharacteristic(type: charactericUUID, properties: CBCharacteristicProperties.read, value: json, permissions: CBAttributePermissions.readable)
        service.characteristics = [characteristic]
        self.peripheralManager.add(service)
        
        let advertisementData = [CBAdvertisementDataServiceUUIDsKey:[service.uuid]] as [String : Any]
        peripheralManager.startAdvertising(advertisementData)
        _ = Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(stopAdvertise), userInfo: nil, repeats: false)
        
        vc?.changedEvent(data)
        
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "MatchViewController")
        if let viewController = nextVC as? MatchViewController{
            viewController.data = data
            viewController.from = 1
        }
        present(nextVC, animated: true, completion: nil)
    }
    
    //  service add result
    func peripheralManager(_ peripheral: CBPeripheralManager, didAdd service: CBService, error: Error?) {
        if error != nil {
           print("service add failed...")
            return
        }
        print("service add success!")
    }
    
    //  advertise result
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if error != nil {
            print("advertising error...")
            return
        }
        print("advertising success!")
    }
    
    func stopAdvertise() {
        peripheralManager.stopAdvertising()
        print("advertise stopped")
    }
    
}
