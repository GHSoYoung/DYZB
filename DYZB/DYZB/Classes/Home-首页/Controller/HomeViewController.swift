//
//  HomeViewController.swift
//  DYZB
//
//  Created by 古古辉 on 16/9/25.
//  Copyright © 2016年 古古辉. All rights reserved.
//

import UIKit

//MARK:- 定义属性
private let gTitleViewH : CGFloat = 40
class HomeViewController: UIViewController {
//MARK:- 懒加载属性
    private lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: gStatusBarH + gNavigationBarH, width: gScreenW, height: gTitleViewH)
        let titles = ["推荐","游戏","娱乐","趣玩"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContentView : PageContentView = {[weak self] in
        let contentH = gScreenH - gStatusBarH - gNavigationBarH - gTitleViewH
        let contentF = CGRect(x: 0, y: gStatusBarH + gNavigationBarH + gTitleViewH, width: gScreenW, height:contentH)
        // 创建控制器
        var childVcs = [UIViewController]()
        
        for _ in 0..<4{
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r:  CGFloat (Float(arc4random_uniform(255))), g: CGFloat (Float(arc4random_uniform(255))), b: CGFloat (Float(arc4random_uniform(255))))
            childVcs.append(vc)
        }
        
        let pageContentView = PageContentView(frame: contentF, childVcs: childVcs, parentVc: self)
        pageContentView.delegate = self
        return pageContentView
//
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // 不调整UIScorllView的内边距
        automaticallyAdjustsScrollViewInsets = false
    // 设置UI界面
     setUpUI()
        // Do any additional setup after loading the view.
    }
}
//MARK:- 设置UI界面
extension HomeViewController {
    private func setUpUI() {
        // 设置导航栏
        setUpNavBar()
        // 添加标题栏
        view.addSubview(pageTitleView)
        // 添加内容View
        view.addSubview(pageContentView)
        pageContentView.backgroundColor = UIColor.blueColor()
    }
    /// 设置导航栏
    private func setUpNavBar() {
        let size = CGSize(width: 40, height: 40)
        // 设置左侧的btn
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "homeLogoIcon",highImageName: "homeLogoIcon",target:nil,action: nil)
        // 设置右侧的btn
        let historyBtn = UIBarButtonItem(imageName: "viewHistoryIcon", size:size,target:self,action:#selector(historyBtnClick))
        let scanBtn = UIBarButtonItem(imageName: "scanIcon", size:size,target:self,action:#selector(scanBtnClick) )
        let searchBtn = UIBarButtonItem(imageName: "searchBtnIcon", size:size,target:self,action:#selector(searchBtnClick))
        navigationItem.rightBarButtonItems = [searchBtn,scanBtn,historyBtn]
    }
}
//MARK:- 事件监听
extension HomeViewController{
    /// historyBtn点击方法
    @objc private func historyBtnClick() {
        print("historyBtnClick")
    }
    /// scanBtn点击方法
    @objc private func scanBtnClick() {
        print("scanBtnClick")
    }
    /// searchBtn点击方法
    @objc private func searchBtnClick() {
        print("searchBtnClick")
    }
}
//MARK:- 遵守协议PageTitleView代理
extension HomeViewController:PageTitleViewDelegate{
    func pageTitleView(titleView: PageTitleView, selectedIndex: Int) {
        pageContentView.setCurrentIndex(selectedIndex)
    }
}
//MARK:- 遵守协议PageContentView代理
extension HomeViewController:PageContentViewDelegate{
    func pageContentView(contenyView:PageContentView,progress:CGFloat,sourceIndex:Int,targetIndex:Int){
      pageTitleView.setPageTitleViewScollLineIndex(progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}



