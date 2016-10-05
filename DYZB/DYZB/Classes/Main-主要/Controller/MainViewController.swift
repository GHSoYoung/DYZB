//
//  MainViewController.swift
//  DYZB
//
//  Created by 古古辉 on 16/9/25.
//  Copyright © 2016年 古古辉. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addChildVc("Home")
        addChildVc("Live")
        addChildVc("Fllow")
        addChildVc("Porfile")
        setUpTabBarItemBg(UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1))
    }
    private func addChildVc(story:String){
        // 1. 通过storyboard获取控制器
        let childVc = UIStoryboard(name: story, bundle: nil).instantiateInitialViewController()!
        // 2. 将childVc作为自控制器
        addChildViewController(childVc)
    }
    /// 设置TabBarItem点击的背景图片
    private func setUpTabBarItemBg(color : UIColor) {
        // 重绘后的尺寸
        let rect=CGRectMake(0.0, 0.0, CGRectGetWidth(self.tabBar.frame) * 0.25, CGRectGetHeight(self.tabBar.frame));
        UIGraphicsBeginImageContext(rect.size);
        // 开启图形上下文
        let context = UIGraphicsGetCurrentContext();
        // 绘制颜色
        CGContextSetFillColorWithColor(context,color.CGColor)
        CGContextFillRect(context, rect);
        // 返回图形
        let theImage = UIGraphicsGetImageFromCurrentImageContext();
        // 关闭图形上下文
        UIGraphicsEndImageContext();

        self.tabBar.selectionIndicatorImage = theImage
        
        
        
    }

}
