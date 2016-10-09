//
//  RecommendViewController.swift
//  DYZB
//
//  Created by 古古辉 on 16/10/7.
//  Copyright © 2016年 古古辉. All rights reserved.
//

import UIKit

private let gItemMagrin:CGFloat = 10
private let gItemW:CGFloat = (gScreenW - gItemMagrin * 3) * 0.5
private let gNormalItemH:CGFloat = gItemW * 3 / 4
private let gPrettyItemH:CGFloat = gItemW * 4 / 3
private let gHeadViewH:CGFloat = 50
private let gNomalCellID = "gNomalCellID"
private let gPrettyCellID = "gPrettyCellID"
private let gHeadViewID = "gHeadViewID"

class RecommendViewController: UIViewController {
//MARK:- 懒加载属性
    fileprivate lazy var collectionView : UICollectionView = {[unowned self] in
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: gItemW, height: gNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = gItemMagrin
        layout.sectionInset = UIEdgeInsets(top: 0, left: gItemMagrin, bottom: 0, right: gItemMagrin)
        // 设置头部View
        layout.headerReferenceSize = CGSize(width: gScreenW, height: gHeadViewH)
        
        // 2.创建UICollectionView
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        // 注册普通cell
collectionView.register(UINib(nibName:"CollectionViewNormalCell",bundle: nil),forCellWithReuseIdentifier: gNomalCellID)
        // 注册颜值cell
collectionView.register(UINib(nibName:"CollectionPrettyViewCell",bundle: nil),forCellWithReuseIdentifier:gPrettyCellID)
        // 注册头部视图
collectionView.register(UINib(nibName:"CollectionHeadView",bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: gHeadViewID)
        //随父控件的缩小而缩小
        collectionView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        
        return collectionView
        }()

//MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        // 设置UI界面
        setUpUI()

    }
    
}
//MARK:- 设置UI界面
extension RecommendViewController{
    /// 设置UI界面
    fileprivate func setUpUI(){
        view.addSubview(collectionView)
    }
}
//MARK:- 实现collectionView的数据源
extension RecommendViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    // 返回组
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    // 返回每组的item的个数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }
        return 4
    }
    // 返回cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell!
        if (indexPath as NSIndexPath).section == 1 {
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: gPrettyCellID, for: indexPath)
        }else{
        cell =  collectionView.dequeueReusableCell(withReuseIdentifier: gNomalCellID, for: indexPath)
        }
        return cell
    }
    // 返回头部视图
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // 1.取出section的HeadView
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: gHeadViewID, for: indexPath)
        return headView
    }
    // 判断item尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (indexPath as NSIndexPath).section == 1 {
            return CGSize(width: gItemW, height: gPrettyItemH)
        }
        return CGSize(width: gItemW, height: gNormalItemH)
    }
}



