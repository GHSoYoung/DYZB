//
//  UIColor-Exntension.swift
//  DYZB
//
//  Created by 古古辉 on 16/9/28.
//  Copyright © 2016年 古古辉. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r:CGFloat,g : CGFloat,b : CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1)
    }
}
