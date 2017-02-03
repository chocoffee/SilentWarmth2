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
import WatchConnectivity
import UserNotifications

protocol ViewControllerChangedDelegate {
    func changedEvent(_ data: [String : Any])
    func stopAd()
}

protocol BackViewControllerDelegate {
    var vc:ViewControllerChangedDelegate?{
        get set
    }
    func backViewController()
}

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, CBCentralManagerDelegate, CBPeripheralDelegate, UIPopoverPresentationControllerDelegate, CBPeripheralManagerDelegate, ViewControllerChangedDelegate, WCSessionDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var transitionButton: UIButton!
    @IBOutlet weak var notifyButton: UIButton!
    @IBOutlet weak var bStopScan: UIButton!
    
    var centralManager: CBCentralManager!
    var discoverPeripheral: CBPeripheral!
    var serviceUUID:[CBUUID] = []
    var ary = [[String : Any]]()
    var data = [String : Any]()
    let alert = AleatBase()
    
    var peripheral: CBPeripheral!
    var peripheralManager: CBPeripheralManager!
    var characteristic: CBMutableCharacteristic!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let back = UIBarButtonItem()
        back.title = ""
        self.navigationItem.backBarButtonItem = back
        self.title = "てれぱしあ"
        
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
        
        bStopScan.isHidden = true
        
        let ud = UserDefaults.standard
        if ud.bool(forKey: "firstLaunch") {
            presentAnnotation()
            ud.set(false, forKey: "firstLaunch")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let transition = BubbleTransition()
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        if var vc = controller as? BackViewControllerDelegate {
            vc.vc = self
        }
        if controller is HelpViewController {
            controller.transitioningDelegate = self
            controller.modalPresentationStyle = .custom
        }
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
        centralManager.scanForPeripherals(withServices: serviceUUID, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])   //  同一端末からのアレ無し？
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
                    let uuid = json["uuid"] as? String ?? ""
                    let bool = ary.contains{ v in
                        if let str = v["uuid"] as? String {
                            if str == uuid {
                                return true
                            }
                        }
                        return false
                    }
                    if !bool {
                        ary.append(json)
                        setPush(data: json)
                        let sendData:[String: Any] = json
                        print("data = \(sendData)")
                        WCSession.default().transferUserInfo(sendData)
                        print(json)
                    }
                }
            }else{
                print("json decode")
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
        contentVC.modalPresentationStyle = .popover
        contentVC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: 300)
        contentVC.popoverPresentationController?.sourceView = view
        contentVC.popoverPresentationController?.sourceRect = sender.frame
        contentVC.popoverPresentationController?.permittedArrowDirections = .up
        contentVC.popoverPresentationController?.delegate = self
        contentVC.ary = ary
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
                    str.append("\(target.joined(separator: " "))")
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
            case "help":
                typeLabel.text = "助けてください"
                detailLabel.text = "あなたの服の色：\(data["myColor"]!)\n相手の服の色：\(data["oColor"]!)"
            default:
                break
            }
            self.bStopScan.setTitle("発信を中止する", for: .normal)
            self.bStopScan.isHidden = false
        }
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("application context:::\(applicationContext)")
        data = applicationContext
        stopAd()
        if (data["stop"] == nil) {
            advertise()
        }
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
            print("advertising error...\(error)")
            self.detailLabel.text = "他のデータを発信中のため、\nこのデータを発信できません。"
            return
        }
        print("advertising success!")
        changedEvent(data)
    }
    
    func stopAdvertise() {
        peripheralManager.stopAdvertising()
        print("advertise stopped")
    }

    @IBAction func bStopScanTapped(_ sender: UIButton) {
        alert.alert("中止する", btn2: "キャンセル", title: "確認", subTitle: "発信を中止してよろしいですか？", advertise: stopAd)
    }
    
    func stopAd() {
        self.peripheralManager.stopAdvertising()
        self.titleLabel.text = ""
        self.detailLabel.text = ""
        self.typeLabel.text = ""
        self.bStopScan.isHidden = true
        print("advertise stopped")
    }
    
    func setPush(data: [String : Any]) {
        let type = data["type"]
        var str = ""
        
        var title = ""
        var body = ""
        
        switch type as! String {
        case "send":
            title = "ゆずります"
            if let target = data["target"] as? [String] {
                body = "\(target.joined(separator: ","))にゆずります！服は\(data["myColor"] ?? "")です。"
            }
        case "invite":
            title = "席を探しています"
            if data["isEdge"] as! Bool{
                str = "端の席を希望します。"
            }
            body = "私は\(data["attribute"] ?? "")、服は\(data["myColor"] ?? "")です。\(str)"
        case "murmur":
            title = "メッセージを受信しました"
            body = "\(data["myColor"] ?? "")の服の人が「\(data["message"] ?? "")」と言っています。"
        case "help":
            title = "助けてください"
            body = "\(data["oColor"] ?? "")色の服の人に痴漢されています。私は\(data["myColor"] ?? "")色です。"
        default:
            break
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = "Subtitle"
        content.body = body
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "notify",
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func presentAnnotation() {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Annotation") as! AnnotationViewController
        viewController.alpha = 0.5
        viewController.barHeight = navigationController?.navigationBar.frame.height ?? 0
        present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func onTapTutorial(_ sender: UIButton) {
        presentAnnotation()
    }
}

