//
//  ViewController.swift
//  WaveAnimationDemo
//
//  Created by Jacqui on 2016/11/11.
//  Copyright © 2016年 Jugg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tableview: UITableView!
    var waveView: FFWaveView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200))
        headerView.backgroundColor = UIColor.cyan
        
        tableview = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.tableHeaderView = headerView
        tableview.tableFooterView = UIView()
        view.addSubview(tableview)
        
        // FFWaveView setup
        waveView = FFWaveView.addTo(view: tableview.tableHeaderView!, frame: CGRect(x: 0, y: headerView.frame.size.height - 10, width: view.frame.size.width, height: 10))
        
        // optional
        waveView.waveColor = UIColor.white
        waveView.waveSpeed = 10
        waveView.angularSpeed = 1.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - UIScrollViewDelegate
extension ViewController : UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //拖拽时，开始执行
        if waveView.startWave() {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                //延时结束动画
                self.waveView.stopWave()
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension ViewController : UITableViewDelegate {
    
}


// MARK: - UITableViewDataSource
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableview.dequeueReusableCell(withIdentifier: "cell")
        if  cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = "\(indexPath.row)"
        return cell!
    }
}
