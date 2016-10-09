//
//  PageContentView.swift
//  DYZB
//
//  Created by 古古辉 on 16/9/28.
//  Copyright © 2016年 古古辉. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate:class{
    func pageContentView(_ contenyView:PageContentView,progress:CGFloat,sourceIndex:Int,targetIndex:Int)
}

private let cellID = "collectionViewCell"
class PageContentView: UIView {
    //MARK:- 定义属性
    fileprivate var childVcs : [UIViewController] = [UIViewController]()
    fileprivate weak var parentVc : UIViewController? = UIViewController()
    fileprivate var startOffsetX : CGFloat = 0
    // 设置是否禁止ScrollDelegate
    fileprivate var isForDidScrollDelegate : Bool = false
    weak var delegate:PageContentViewDelegate?
    //MARK:- 定义懒加载属性
    fileprivate lazy var collectionView : UICollectionView = {[weak self] in
        let collectionViewF = self!.frame
        // 1.创建layout 
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = self!.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2.设置UICollectionView
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        // 注册cell
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        return collectionView
    }()
    //MARK:- 自定义构造函数
    init(frame: CGRect,childVcs : [UIViewController],parentVc : UIViewController?) {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        // 设置UI
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
//MARK:- 设置UI
extension PageContentView{
    func setUpUI(){
        // 1.将所有的子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc?.addChildViewController(childVc)
        }
        // 2.创建collectionView
        addSubview(collectionView)
        collectionView.frame = bounds
        
    }
}
//MARK:- 实现collectionView的数据源
extension PageContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return childVcs.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 创建cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        // 设置内容
        // 移除添加的View
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        let childVc = childVcs[(indexPath as NSIndexPath).item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}
//MARK:- 遵守collectionView代理
extension PageContentView : UICollectionViewDelegate{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForDidScrollDelegate = false
        startOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForDidScrollDelegate{return}
        // 1.获取需要的数据
        var progress:CGFloat = 0
        // 原来的下标
        var sourceIndex = 0
        // 目标下标
        var targetIndex = 0
        
        
        // 2.判断左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scorllViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { //左滑
            // 计算progress
            progress = currentOffsetX / scorllViewW - floor(currentOffsetX/scorllViewW)
            // 计算sourceIndex
            sourceIndex = Int(currentOffsetX/gScreenW)
            // 计算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count {
                targetIndex = childVcs.count - 1
            }
            // 如果完全滑过去
            if currentOffsetX - startOffsetX == scorllViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{// 右滑
            progress = 1.0 -  (currentOffsetX / scorllViewW - floor(currentOffsetX/scorllViewW))
            
            targetIndex = Int(currentOffsetX/gScreenW)
            sourceIndex = targetIndex + 1
            
            if sourceIndex >= childVcs.count {
                sourceIndex = childVcs.count - 1
            }
           
        }
        delegate?.pageContentView(self, progress: progress,sourceIndex: sourceIndex,targetIndex: targetIndex)
    }
}
//MARK:- 对外暴露的方法
extension PageContentView{
    func setCurrentIndex(_ currentIndex:Int){
        // 记录需要禁止
        isForDidScrollDelegate = true
        // 滚到正确的位置
        let offsetX =  CGFloat(Float(currentIndex)) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
