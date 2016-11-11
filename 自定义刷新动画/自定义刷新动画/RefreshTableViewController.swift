//
//  RefreshTableViewController.swift
//  自定义刷新动画
//
//  Created by Tesiro on 16/11/11.
//  Copyright © 2016年 Tesiro. All rights reserved.
//

import UIKit

private let kRefreshviewHeight : CGFloat = 200

class RefreshTableViewController: UITableViewController ,RefreshViewDelegate{
    
    private var refreshView : RefreshView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshView = RefreshView(frame: CGRect(x: 0, y: -kRefreshviewHeight, width:view.bounds.width, height: kRefreshviewHeight), scrollView: tableView)
        refreshView.delegate = self
        view.insertSubview(refreshView, at: 0)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //把通知传递给refreshview，让他进行相应的变化
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    
    // MARK: - Refresh view delegate
    
    func refreshViewDidRefresh(refreshView: RefreshView) {
        sleep(3)
        refreshView.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mycell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = "第\(indexPath.row)行"
        return cell;
    }

}
