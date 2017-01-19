//
//  MatchDetailViewController.swift
//  SilentWarmth
//
//  Created by guest on 2017/01/16.
//  Copyright © 2017年 chocoffee. All rights reserved.
//

import UIKit


class MatchDetailViewController: UIViewController {
    var data = [String : Any]()

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var startAnimation: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        decode(data: data)
        detailLabel.sizeToFit()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func goToAnimation(_ sender: UIButton) {
        
    }
    
    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func decode(data: [String : Any]) {
        let type = data["type"]
        var str = ""
        switch type as! String {
        case "send":
            self.startAnimationIsHidden(false)
            titleLabel.text = "ゆずります"
            if let target = data["target"] as? [String] {
                detailLabel.text = "\(target.joined(separator: ","))にゆずります！服は\(data["myColor"] ?? "")です。"
            }
        case "invite":
            self.startAnimationIsHidden(false)
            titleLabel.text = "席を探しています"
            if data["isEdge"] as! Bool{
                str = "端の席を希望します。"
            }
            detailLabel.text = "私は\(data["attribute"] ?? "")、服は\(data["myColor"] ?? "")です。\(str)"
        case "murmur":
            titleLabel.text = "メッセージを受信しました"
            detailLabel.text = "\(data["myColor"] ?? "")の服の人が「\(data["message"] ?? "")」と言っています。"
            self.startAnimationIsHidden(true)
        case "help":
            titleLabel.text = "助けてください"
            detailLabel.text = "\(data["oColor"] ?? "")色の服の人に痴漢されています。私は\(data["myColor"] ?? "")色です。"
            self.startAnimationIsHidden(true)
        default:
            break
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MatchViewController {
            vc.data = data
        }
    }
    
    private func startAnimationIsHidden(_ bool:Bool){
        DispatchQueue.main.async {
            self.startAnimation.isHidden = bool
        }
    }

}
