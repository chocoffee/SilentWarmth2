//
//  CheckButton.swift
//  SilentWarmth
//
//  Created by guest on 2017/01/23.
//  Copyright © 2017年 chocoffee. All rights reserved.
//

import UIKit

class CheckButton: UIButton {
    @IBInspectable var check:Bool = false {
        didSet{
            self.setImage(check ? checkOnImage : checkOffImage, for: .normal)
        }
    }
    @IBInspectable var checkOnImage:UIImage = UIImage()
    @IBInspectable var checkOffImage:UIImage = UIImage()
    
    func checkButtonInit(){
        self.setImage(check ? checkOnImage : checkOffImage, for: .normal)
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        self.addTarget(self, action: #selector(onCheckChange), for: .touchUpInside)
    }
    
    func onCheckChange(){
        self.check = !check
    }
}
