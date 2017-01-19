//
//  HelpViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/11.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit
import CoreBluetooth

class HelpViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CBPeripheralDelegate, CBPeripheralManagerDelegate {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var userColor: UIPickerView!
    @IBOutlet weak var otherColor: UIPickerView!
    var user = ""
    var other = ""
    var data = [String : Any]()
    let alert = AleatBase()
    var peripheral: CBPeripheral!
    var peripheralManager: CBPeripheralManager!
    var characteristic: CBMutableCharacteristic!
    var vc:ViewControllerDelegate?

    let colorArray = ["赤", "青", "黄", "黒", "白"]
    
    override func viewDidLoad() {
        closeButton.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_4))
        
        userColor.delegate = self
        userColor.dataSource = self
        
        otherColor.delegate = self
        otherColor.dataSource = self
        
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
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
//        let userNumber = userColor.selectedRow(inComponent: 0)
//        let otherNumber = otherColor.selectedRow(inComponent: 0)
//        
//        print("user = \(colorArray[userNumber]) / other = \(colorArray[otherNumber])")
        
        data["type"] = "help"
        var str = ""
        
        data["myColor"] = Values.color[userColor.selectedRow(inComponent: 0)]
        data["oColor"] = Values.color[otherColor.selectedRow(inComponent: 0)]
        
        str.append("あなたの服：\(Values.color[userColor.selectedRow(inComponent: 0)])")
        str.append("/n相手の服：\(Values.color[otherColor.selectedRow(inComponent: 0)])")
        setAlert(str)
    }
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
        _ = Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(stopAdvertise), userInfo: nil, repeats: false)
        vc?.changedEvent(data)
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "MatchViewController")
        if let vc = nextVC as? MatchViewController{
            vc.data = data
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
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
