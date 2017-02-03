//
//  BaseViewController.swift
//  SilentWarmth
//
//  Created by guest on 2017/01/26.
//  Copyright © 2017年 chocoffee. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, BackViewControllerDelegate {

    let alert = AleatBase() //  Alertの親クラス
    var data = [String : Any]()
    var vc:ViewControllerChangedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  ゆずる対象者がいた時（入力に不備がない時）
    func setAlert(_ str: String) {
        alert.alert("発信する！", btn2: "キャンセル", title: "よろしいですか？", subTitle: str, advertise: preparetion)
    }
    
    //  ゆずる対象がいない場合
    func setAlert() {
        alert.alert("OK", title: "エラー", subTitle: "ゆずる相手がいません")
    }
    
    //  クロージャ用メソッド
    func preparetion() {
        let nextVC = self.storyboard!.instantiateViewController(withIdentifier: "MatchViewController")
        if let tmp = nextVC as? MatchViewController{
            tmp.data = data
            tmp.from = 1
            tmp.back = self
            tmp.vc = vc
        }
        present(nextVC, animated: true, completion: nil)
    }
    
    func backViewController() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
}
