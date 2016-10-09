//
//  PageTitleView.swift
//  DYZB
//
//  Created by 古古辉 on 16/9/25.
//  Copyright © 2016年 古古辉. All rights reserved.
//

import UIKit

protocol  PageTitleViewDelegate : class{
    func pageTitleView(_ titleView:PageTitleView,selectedIndex:Int)
}
private let gScrollLineH :CGFloat = 2
// 元祖常亮
private let gNormalColor :(CGFloat,CGFloat,CGFloat) = (85,85,85)
private let gSelectedColor :(CGFloat,CGFloat,CGFloat) = (255,128,0)
class PageTitleView: UIView {
    //MARK:- 定义属性
    fileprivate var titles:[String]
    fileprivate var currentIndex :Int = 0
    // 滑块初始位置
    fileprivate var scrollLineStart :CGFloat = 0
    weak var delegate : PageTitleViewDelegate?
    //MARK:- 懒加载属性
    fileprivate lazy var scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        // 隐藏水平滚动条
        scrollView.showsHorizontalScrollIndicator = false
        // 关闭点击状态栏回滚到顶部
        scrollView.scrollsToTop = false
        // 超出内容范围不允许滚动
        scrollView.bounces = false
        return scrollView
    }()
    fileprivate lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor(r: gSelectedColor.0, g: gSelectedColor.1, b: gSelectedColor.2)
        return scrollLine
    }()
    // 储存label的数组
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    init(frame: CGRect,titles:[String]) {
        self.titles = titles
        super.init(frame: frame)
        // 设置UI界面
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK:- 设置UI界面
extension PageTitleView{
    fileprivate func setUpUI() {
        // 添加UIScrollView
        addSubview(scrollView)
        scrollView.frame = bounds
        // 添加title对应的lable
        setUpLables()
        // 添加滑块和底部的线
        setUpBottomLineAndScorllLine()
    }
    /// 添加label
    fileprivate func setUpLables() {
        let lableY : CGFloat = 0
        let lableW : CGFloat = frame.width / CGFloat(Float(titles.count))
        let labelH : CGFloat = frame.height - gScrollLineH
        for (index,title) in titles.enumerated() {
            // 1.创建label
            let lable = UILabel()
            // 2.设置label的属性
            lable.text = title
            lable.tag = index
            lable.font = UIFont.systemFont(ofSize: 16.0)
            lable.textColor = UIColor(r: gNormalColor.0, g: gNormalColor.1, b: gNormalColor.2)
            lable.textAlignment = .center
            // 3.设置label的frame
            let lableX : CGFloat = CGFloat(Float(index)) * lableW
            lable.frame = CGRect(x: lableX, y: lableY, width: lableW, height: labelH)
            // 4.将lable添加到scrollView中
            scrollView.addSubview(lable)
            // 5.给lable添加手势
            lable.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(labelClick(_:)))
            lable.addGestureRecognizer(tapGes)
            // 将label添加到数组
            titleLabels.append(lable)
        }
    }
    /// 添加底线和滑块
    fileprivate func setUpBottomLineAndScorllLine () {
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: (frame.height-lineH), width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 获取第一个label
        guard let firstLabel = titleLabels.first else {return}
        firstLabel.textColor = UIColor(r: gSelectedColor.0, g: gSelectedColor.1, b: gSelectedColor.2)
        
        // 设置scrollLine的属性
        scrollLine.frame = CGRect(x: 0, y: frame.height - gScrollLineH, width: firstLabel.bounds.width * 0.6, height: gScrollLineH)
        scrollLine.center.x = firstLabel.center.x
        scrollLineStart = scrollLine.center.x
        scrollView.addSubview(scrollLine)
        
    }
}
//MARK:- 事件监听
extension PageTitleView{
    @objc func labelClick(_ tapGes:UITapGestureRecognizer){
        // 1.获取当前label
        guard let currentLabel = tapGes.view as? UILabel else{return}
        // 2.获取之前的label
        let oldLabel = titleLabels[currentIndex]
        // 3. 切换文字的颜色
        oldLabel.textColor = UIColor(r: gNormalColor.0, g: gNormalColor.1, b: gNormalColor.2)
        currentLabel.textColor = UIColor(r: gSelectedColor.0, g: gSelectedColor.1, b: gSelectedColor.2)
        // 4.保存最新Label的下标
        currentIndex = currentLabel.tag
        // 5.滚动条位置发生改变
        let scollLineCenterX = currentLabel.center.x
        UIView.animate(withDuration: 0.25, animations: {
            self.scrollLine.center.x = scollLineCenterX
        }) 
        // 6.通知代理
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
    }
}

//MARK:- 对外暴露方法
extension PageTitleView{
    func setPageTitleViewScollLineIndex(_ progess:CGFloat,sourceIndex:Int,targetIndex:Int){
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        let move = targetLabel.center.x - sourceLabel.center.x
        scrollLine.center.x = sourceLabel.center.x + move*progess
        // 颜色的渐变（复杂）
        // 1.颜色渐变的范围
        let colorDelta = (gSelectedColor.0 - gNormalColor.0,gSelectedColor.1 - gNormalColor.1,gSelectedColor.2 - gNormalColor.2)
        sourceLabel.textColor = UIColor(r:gSelectedColor.0 - colorDelta.0 * progess, g: gSelectedColor.1 - colorDelta.1 * progess, b: gSelectedColor.2 - colorDelta.2 * progess)
        targetLabel.textColor = UIColor(r: gNormalColor.0 + colorDelta.0 * progess, g: gNormalColor.1 + colorDelta.1 * progess, b: gNormalColor.2 + colorDelta.2 * progess)
      // 记录最新的index
        currentIndex = targetIndex
    }
}
