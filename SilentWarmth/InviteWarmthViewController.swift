//
//  InviteWarmthViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/14.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit
import CoreBluetooth

class InviteWarmthViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CBPeripheralDelegate, CBPeripheralManagerDelegate {
    @IBOutlet weak var attributePicker: UIPickerView!
    @IBOutlet weak var colorPicker: UIPickerView!
    @IBOutlet weak var isEdge: UISwitch!
    var data = [String : Any]()
    let alert = AleatBase()
    
    var peripheral: CBPeripheral!
    var peripheralManager: CBPeripheralManager!
    var characteristic: CBMutableCharacteristic!
    var vc:ViewControllerDelegate?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        attributePicker.delegate = self
        attributePicker.dataSource = self
        colorPicker.delegate = self
        colorPicker.dataSource = self
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        self.title = "ゆずってほしい"
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
        
        data["attribute"] = Values.attribute[attributePicker.selectedRow(inComponent: 0)]
        data["myColor"] = Values.color[colorPicker.selectedRow(inComponent: 0)]
        data["isEdge"] = isEdge.isOn
        
        str.append(Values.attribute[attributePicker.selectedRow(inComponent: 0)])
        str.append(" / \(Values.color[colorPicker.selectedRow(inComponent: 0)])")
        if isEdge.isOn {
            str.append(" / edge")
        }
        vc?.changedEvent(data)
        setAlert(str)
    }
    
    //  あらーと呼び出し
    func setAlert(_ str: String) {
        alert.alert("発信する", btn2: "キャンセル", title: "確認", subTitle: str, advertise: advertise)
    }
    
    
    //  以下CB用メソッド
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralState: \(peripheral.state)")
    }
    
    //  アドバタイズするデータ準備
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
}
