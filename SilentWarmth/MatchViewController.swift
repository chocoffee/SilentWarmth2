//
//  MatchViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/12/22.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {
    var data = [String : Any]()
    var from = -1   // -1ならNotificationから、1なら発信時
    var isHeart = false

    @IBOutlet weak var matchImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.sizeToFit()
        
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
            messageLabel.textColor = UIColor.white
            messageLabel.text = "落ち着いて助けを待ってください。\n画面を他の人に見えやすい位置に置いてください。"
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
    }
    
    func updateCounter() {
        self.dismiss(animated: true, completion: nil)
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
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}
