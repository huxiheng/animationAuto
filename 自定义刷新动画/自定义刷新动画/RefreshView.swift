//
//  RefreshView.swift
//  自定义刷新动画
//
//  Created by Tesiro on 16/11/11.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

import UIKit

private let kSceneHeight : CGFloat = 120.0

protocol RefreshViewDelegate: class {
    func refreshViewDidRefresh(refreshView: RefreshView)
}
class RefreshView: UIView,UIScrollViewDelegate {
    
    private unowned var scrollView : UIScrollView
    private var progress : CGFloat = 0.0
    var refreshItems = [RefreshIterm]()
    
    
    weak var delegate: RefreshViewDelegate?
    
    var isRefreshing = false
    
    init(frame : CGRect, scrollView : UIScrollView) {
        self.scrollView = scrollView;
        super.init(frame: frame)
//        backgroundColor = UIColor.green
        updateBackgroundColor()
         setupRefreshItems()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
      func setupRefreshItems()   {
        let groundImageView = UIImageView(image: UIImage(named: "ground"))
        let buildingsImageView = UIImageView(image: UIImage(named: "buildings"))
        
        refreshItems = [
            RefreshIterm(view: buildingsImageView, centerEnd: CGPoint(x: bounds.midX,
                                                                      y: bounds.height - groundImageView.bounds.height - buildingsImageView.bounds.height / 2), parallaxRatio: 1.5, sceneHeight: kSceneHeight),
            RefreshIterm (view: groundImageView,
                                     centerEnd: CGPoint(x: bounds.midX,
                                                        y: bounds.height - groundImageView.bounds.height/2),
                                     parallaxRatio: 0.5, sceneHeight: kSceneHeight),
            
        ]
        
        for refreshItem in refreshItems {
            addSubview(refreshItem.view)
        }
    }
    
    func updateRefreshItemPositions() {
        for refreshItem in refreshItems {
            refreshItem.updateViewPositionForPercentage(percentage: progress)
        }
    }
    
    func updateBackgroundColor()  {
        backgroundColor = UIColor(white: 0.7*progress + 0.2, alpha: 1.0)
    }
    
    func beginRefreshing() {
        isRefreshing = true
        
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: { () -> Void in
            self.scrollView.contentInset.top += kSceneHeight
        }) { (_) -> Void in
        }
    }
    
    func endRefreshing() {
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseInOut, animations: { () -> Void in
            self.scrollView.contentInset.top -= kSceneHeight
        }) { (_) -> Void in
            self.isRefreshing = false
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !isRefreshing && progress == 1 {
            beginRefreshing()
//            -scrollView.contentInset.top
            delegate?.refreshViewDidRefresh(refreshView: self)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isRefreshing {
            return
        }
        
        //刷新视图可见的区域
        let refreshHeight = max(0,  -scrollView.contentOffset.y - scrollView.contentInset.top)
        //场景的高度
        progress = min(1, refreshHeight/kSceneHeight)
        
        //根据进度来改变背景色
        updateBackgroundColor()
        //4. 根据进度来更新图片位置
        updateRefreshItemPositions()
    }
}
