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
    convenience init(imageName:String,highImageName:String = "", size:CGSize = CGSize.zero,target:AnyObject?,action:Selector) {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:imageName), for: UIControlState())
        if highImageName == "" {
            btn.setImage(UIImage(named:imageName + "HL"), for: .highlighted)
            btn.addTarget(target, action: action, for: .touchUpInside)
        }else{
            btn.setImage(UIImage(named:imageName), for: .highlighted)
        }
        
        if size == CGSize.zero {
            btn.sizeToFit()
        }else{
            btn.bounds.size = size
        }
        
        self.init(customView:btn)
    }
}
