//
//  MatchViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/22.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit
import CoreBluetooth


class MatchViewController: UIViewController, CBPeripheralDelegate, CBPeripheralManagerDelegate {
    var data = [String : Any]()
    var from = -1   // -1ならNotificationから、1なら発信時
    var isHeart = false
    var back:BackViewControllerDelegate?
    var peripheral: CBPeripheral!
    var peripheralManager: CBPeripheralManager!
    var characteristic: CBMutableCharacteristic!
    var vc: ViewControllerChangedDelegate?

    @IBOutlet weak var matchImage: UIImageView!
    @IBOutlet weak var helpLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        messageLabel.sizeToFit()
        helpLabel.isHidden = true
        
        var inviteStr = ""
        var sendStr = ""
        
        let heart = UIImage(named: "SWMatchImgHeart")
        let hand = UIImage(named: "SWMatchImgHand")
        
        switch from {
        case -1:
            inviteStr = "マッチング中。\n\(data["myColor"]!)色の服の\nゆずる人を探してください。"
            sendStr = "マッチング中。\n\(data["myColor"]!)色の服の\nゆずって人を探してください。"
        case 1:
            inviteStr = "思いやり募集中。"
            sendStr = "思いやり発信中。"
        default:
            break
        }
        
        
        switch data["type"] as! String {
        case "invite" :
            self.view.backgroundColor = #colorLiteral(red: 0.9760605693, green: 0.8092566133, blue: 1, alpha: 1)
            messageLabel.textColor = UIColor.black
            messageLabel.text = inviteStr
            if from == -1 {
                matchImage.image = heart
                isHeart = true
            }else {
                matchImage.image = hand
            }
        case "send":
            self.view.backgroundColor = #colorLiteral(red: 0.9760605693, green: 0.8092566133, blue: 1, alpha: 1)
            messageLabel.textColor = UIColor.black
            messageLabel.text = sendStr
            matchImage.image = UIImage(named: "SWMatchImgHand")
            if from == -1 {
                matchImage.image = hand
            }else {
                matchImage.image = heart
                isHeart = true
            }
        case "murmur":
            self.view.backgroundColor = #colorLiteral(red: 0.9760605693, green: 0.8092566133, blue: 1, alpha: 1)
            messageLabel.textColor = UIColor.black
            messageLabel.text = "メッセージ発信中。"
            matchImage.image = UIImage(named: "SWMatchImgMessage")
        default:
            self.view.backgroundColor = UIColor.black
            matchImage.image = UIImage(named: "SWMatchImgBoth")
            helpLabel.isHidden = false
            helpLabel.textColor = UIColor.white
            helpLabel.text = "HELP"
            messageLabel.textColor = UIColor.white
            messageLabel.text = "画面を他の人に見えやすい位置に置いてください。"
        }
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if isHeart {
            heartShrinking()
        }else {
            handShrinking()
        }
        
        if from == 1 {
            _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: false)
        }
        advertise()
    }
    
    func updateCounter() {
        dismiss(animated: true, completion: nil)
        back?.backViewController()
    }
    
    func heartExpansion() {
        UIView.animate(withDuration: 2.0, animations: {
            self.matchImage.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }) { _ in
            self.heartShrinking()
        }
    }
    
    func heartShrinking() {
        UIView.animate(withDuration: 0.5, animations: {
            self.matchImage.transform = CGAffineTransform(scaleX: 1 / 1.5, y: 1 / 1.5)
        }) { _ in
            self.heartExpansion()
        }
    }
    
    func handExpansion() {
        UIView.animate(withDuration: 2.0, animations: {
            self.matchImage.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { _ in
            self.handShrinking()
        }
    }
    
    func handShrinking() {
        UIView.animate(withDuration: 0.5, animations: {
            self.matchImage.transform = CGAffineTransform(scaleX: 1 / 0.75, y: 1 / 0.75)
        }) { _ in
            self.handExpansion()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func advertise() {
        data["uuid"] = UUID().uuidString
        guard let json = try? JSONSerialization.data(withJSONObject: data, options: .init(rawValue: 0)) else{
            return
        }
        let serviceUUID = CBUUID(string: Uuids.serviceUUID)
        let service = CBMutableService(type: serviceUUID, primary: true)
        let charactericUUID = CBUUID(string: Uuids.characteristicUUID)
        characteristic = CBMutableCharacteristic(type: charactericUUID, properties: CBCharacteristicProperties.read, value: json, permissions: CBAttributePermissions.readable)
        service.characteristics = [characteristic]
        self.peripheralManager.add(service)
        vc?.changedEvent(data)
        let advertisementData = [CBAdvertisementDataServiceUUIDsKey:[service.uuid]] as [String : Any]
        
        peripheralManager.startAdvertising(advertisementData)
        _ = Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(stopAdvertise), userInfo: nil, repeats: false)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("peripheralState: \(peripheral.state)")
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
        vc?.changedEvent(data)
        print("advertising success!")
    }
    
    func stopAdvertise() {
        vc?.stopAd()
        print("advertise stopped@help")
    }
}
