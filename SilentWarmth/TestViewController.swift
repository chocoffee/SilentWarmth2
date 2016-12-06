//
//  TestViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/25.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol DataEncode {
    
}

//protocol DataDecode {   //  Int　→　String
//    
//}
//extension DataDecode {
//    func decode(_ data: [String : Any]) -> [String]{
//        var title = ""
//        var str = ""
//        
//        let type = data["type"]
//        
//        
////        switch data["type"] {
////        case "send":
////            title = "マッチしました"
////            str = "\(data["mColor"])色の人が席を譲ってくれそうです"
////        case "invite":
////            title = "マッチしました"
////            str = "\(Values.color[data[2][0]])色の服の\(Values.attribute[data[1][0]])が席を探しています"
////        case "murmur":
////            title = "メッセージを受信しました"
////            str = "\(Values.message[data[1][0]])"
////        default:
////            title = "hoge"
////            str = "hogehoge"
////        }
//        let ary = [title, str]
//        return ary
//    }
//}

class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var ary = [[String : Any]]()    //  dataが入ってくる
    var nowAry = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.estimatedRowHeight = 90
        self.tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! NotifyListTableViewCell
        let tmp = ary[indexPath.row]
        cell.titleLabel?.text = tmp["type"] as! String?
        cell.strLabel?.text = tmp["myColor"] as! String?
        return cell
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
