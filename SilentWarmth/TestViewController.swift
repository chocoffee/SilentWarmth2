//
//  TestViewController.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/25.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit
import SwiftyJSON

class TestViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var ary = [[String : Any]]()    //  dataが入ってくる
    var str = ""
    
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
        
        switch tmp["type"] as! String {
        case "send":
            cell.titleLabel.text = "ゆずります"
            if let target = tmp["target"] as? [String] {
                cell.strLabel.text = "\(target.joined(separator: ","))にゆずります！服は\(tmp["myColor"] ?? "")です。"
            }
            break
        case "invite":
            cell.titleLabel.text = "席を探しています"
            if tmp["isEdge"] as! Bool{
                str = "端の席を希望します。"
            }
            cell.strLabel.text = "私は\(tmp["attribute"] ?? "")、服は\(tmp["myColor"] ?? "")です。\(str)"
            break
        case "murmur":
            cell.titleLabel.text = "メッセージを受信しました"
            cell.strLabel.text = "\(tmp["myColor"] ?? "")の服の人が「\(tmp["message"] ?? "")」と言っています。"
            break
        case "help":
            cell.titleLabel.text = "助けてください"
            cell.strLabel.text = "\(tmp["oColor"] ?? "")色の服の人に痴漢されています。私は\(tmp["myColor"] ?? "")色です。"
            break
        default:
            break
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MatchDetailViewController {
            if let indexPath = tableView.indexPathForSelectedRow{
                vc.data = ary[indexPath.row]
            }
        }
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
