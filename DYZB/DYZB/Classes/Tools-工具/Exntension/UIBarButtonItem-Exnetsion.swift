//
//  UIBarButtonItem-Exnetsion.swift
//  DYZB
//
//  Created by 古古辉 on 16/9/25.
//  Copyright © 2016年 古古辉. All rights reserved.
//

import UIKit
extension UIBarButtonItem {
    // 便利构造函数
    convenience init(imageName:String,highImageName:String = "", size:CGSize = CGSizeZero,target:AnyObject?,action:Selector) {
        let btn = UIButton(type: .Custom)
        btn.setImage(UIImage(named:imageName), forState: .Normal)
        if highImageName == "" {
            btn.setImage(UIImage(named:imageName + "HL"), forState: .Highlighted)
            btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        }else{
            btn.setImage(UIImage(named:imageName), forState: .Highlighted)
        }
        
        if size == CGSizeZero {
            btn.sizeToFit()
        }else{
            btn.bounds.size = size
        }
        
        self.init(customView:btn)
    }
}
