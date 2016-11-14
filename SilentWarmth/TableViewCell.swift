//
//  TableViewCell.swift
//  SilentWarmth
//
//  Created by guest on 2016/11/10.
//  Copyright © 2016年 chocoffee. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var attributeSwitch: UISwitch!
    
    let attribute = ["お年寄り", "妊婦さん", "子連れさん", "けが人", "体調不良"]

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(attribute: String) {
        attributeLabel.text = attribute
    }
    
    

}
