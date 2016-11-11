//
//  RefreshIterm.swift
//  自定义刷新动画
//
//  Created by Tesiro on 16/11/11.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

import UIKit

class RefreshIterm {
    
    private var centerStart: CGPoint
    private var centerEnd: CGPoint
    unowned var view: UIView
    
    //起始位置
    init(view: UIView, centerEnd: CGPoint, parallaxRatio: CGFloat, sceneHeight: CGFloat) {
        self.view = view
        self.centerEnd = centerEnd
        centerStart = CGPoint(x: centerEnd.x, y: centerEnd.y + (parallaxRatio * sceneHeight))
        self.view.center = centerStart
    }
    
    //跟据下拉的进度确定控件的位置
    func updateViewPositionForPercentage(percentage: CGFloat) {
        view.center = CGPoint(
            x: centerStart.x + (centerEnd.x - centerStart.x) * percentage,
            y: centerStart.y + (centerEnd.y - centerStart.y) * percentage)
    }
}
