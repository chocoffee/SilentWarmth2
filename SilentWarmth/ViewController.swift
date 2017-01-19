//
//  ViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/10.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit
import BubbleTransition
import CoreBluetooth
import SwiftyJSON
import WatchConnectivity
import AVFoundation

protocol ViewControllerDelegate {
    func changedEvent(_ data: [String : Any])
}


class ViewController: UIViewController, UIViewControllerTransitioningDelegate, CBCentralManagerDelegate, CBPeripheralDelegate, UIPopoverPresentationControllerDelegate, CBPeripheralManagerDelegate, ViewControllerDelegate, WCSessionDelegate, AVAudioPlayerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var transitionButton: UIButton!
    @IBOutlet weak var notifyButton: UIButton!
    
    var centralManager: CBCentralManager!
    var discoverPeripheral: CBPeripheral!
    var serviceUUID:[CBUUID] = []
    var ary = [[String : Any]]()
    var data = [String : Any]()
    
    var peripheral: CBPeripheral!
    var peripheralManager: CBPeripheralManager!
    var characteristic: CBMutableCharacteristic!
    
    var player: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem()
        back.title = ""
        self.navigationItem.backBarButtonItem = back
        self.title = "Silent Warmth"
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager.delegate = self
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        serviceUUID.append(CBUUID(string: Uuids.serviceUUID))
        if WCSession.isSupported() {
            let session = WCSession.default()
            session.delegate = self
            session.activate()
        }
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: false)
        _ = Timer.scheduledTimer(timeInterval: 1800.0, target: self, selector: #selector(stopScan), userInfo: nil, repeats: false)
        // Do any additional setup after loading the view, typically from a nib.
        
        let soundFilePath : String = Bundle.main.path(forResource: "no_sound", ofType: "wav")!
        let fileURL : URL = URL(fileURLWithPath: soundFilePath)
        do{
            player = try AVAudioPlayer(contentsOf: fileURL)
            player.delegate = self
            player.numberOfLoops = -1
        }
        catch{
            print(error)
        }
        _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryAmbient)
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch  {
            fatalError("カテゴリ設定失敗")
        }
        
        do {
            try session.setActive(true)
        } catch {
            fatalError("session有効化失敗")
        }
        
        player.play()
        print("music play")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let transition = BubbleTransition()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SendWarmthViewController {
            vc.vc = self
            return
        }else if let vc = segue.destination as? InviteWarmthViewController {
            vc.vc = self
            return
        }else if let vc = segue.destination as? MurmurViewController {
            vc.vc = self
            return
        }
        
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
        
        
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = transitionButton.backgroundColor!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = transitionButton.center
        transition.bubbleColor = transitionButton.backgroundColor!
        return transition
    }

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("centralState: \(central.state.rawValue)")
    }

    func startScan() {
        centralManager.scanForPeripherals(withServices: serviceUUID, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
        print("scan start")
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("discover peripheral! ")
        self.discoverPeripheral = peripheral
        self.centralManager.connect(discoverPeripheral, options: nil)
    }
    
    //   ペリフェラルに接続した後
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connect success")
        discoverPeripheral.delegate = self
        discoverPeripheral.discoverServices(serviceUUID)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("connect failed")
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        let services = peripheral.services
        print("\(services?.count)個のサービスを発見。\(services)")
        
        for obj in services! {
            //  キャラクタリスティック検索開始
            peripheral.discoverCharacteristics(nil, for: obj)   //  obj = CBService
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        let characteristics = service.characteristics
        print("\(characteristics?.count)のキャラクタリスティックを発見。\(characteristics)")
        
        if characteristics != nil {
            for obj in characteristics! {
                if obj.properties == CBCharacteristicProperties.read {
                    peripheral.readValue(for: obj)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.value != nil {
            let value = characteristic.value!
            print("let's reading")
            if let tmpJSON = try? JSONSerialization.jsonObject(with: value, options: .mutableContainers){
                if let json = tmpJSON as? [String:Any]{
                    ary.append(json)
                    print(json)
                }
            }else{
                print("json decode")
            }
        
            if let string = String(data: value, encoding: .utf8){
                print(string)
            }else{
                print("string decode")
            }
        
            print("読み出し成功！service UUID = \(characteristic.service.uuid), characteristic UUID = \(characteristic.uuid), value = \(characteristic.value!)")
        }
    }
        
    func updateCounter() {
        startScan()
    }
    
    func stopScan() {
        centralManager.stopScan()
        print("scan stopped")
    }

    @IBAction func notification(_ sender: UIButton) {
        guard let storyboard = self.storyboard else {
            return
        }
        guard let contentVC = storyboard.instantiateViewController(withIdentifier: "TestViewController") as? TestViewController else{
            return
        }
        //define use of popover
        contentVC.modalPresentationStyle = .popover
        //set size
        contentVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        //set origin
        contentVC.popoverPresentationController?.sourceView = view
        contentVC.popoverPresentationController?.sourceRect = sender.frame
        //set arrow direction
        contentVC.popoverPresentationController?.permittedArrowDirections = .up
        //set delegate
        contentVC.popoverPresentationController?.delegate = self
        contentVC.ary = ary
        //contentVC.nowAry = advertising
        //present
        present(contentVC, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyle(for coxntroller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func changedEvent(_ data: [String : Any]) {
        var str = ""
        titleLabel.text = "現在発信中"
        detailLabel.sizeToFit()

        if data["type"] != nil {
            switch data["type"] as! String {
                case "send":
                typeLabel.text = "ゆずります"
                if let target = data["target"] as? [String] {
                    str.append("\(target.joined(separator: ","))")
                }
                detailLabel.text = "ゆずる人：\n\(str)\n服の色：\(data["myColor"]!)"
            case "invite" :
                typeLabel.text = "席を探しています"
                if data["isEdge"] as! Bool {
                    str.append("端の席を希望する")
                }
                detailLabel.text = "\(data["attribute"]!)\n服の色：\(data["myColor"]!)\n\(str)"
            case "murmur":
                typeLabel.text = "メッセージを送信する"
                detailLabel.text = "メッセージ：\(data["message"]!)\n服の色：\(data["myColor"]!)"
            default:
                break
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("message ::: \(message)")
        data = message
        advertise()
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("application context:::\(applicationContext)")
        data = applicationContext
        advertise()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("hi")
        if error != nil {
            print("error ::: \(error)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("deactivate")
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        print("state: \(peripheral.state)")
    }
    
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

