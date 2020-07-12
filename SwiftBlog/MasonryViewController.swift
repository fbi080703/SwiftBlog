//
//  MasonryViewController.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/22.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation
import UIKit
import Masonry
import SnapKit

//https://oleb.net/blog/2014/07/swift-instance-methods-curried-functions/?utm_campaign=iOS_Dev_Weekly_Issue_157&utm_medium=email&utm_source=iOS+Dev+Weekly

class MasonryViewController: UIViewController {
    
    let button = Control()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        
        //autoreleasepool {}
        masonryTest()
        snapTest()
        //柯里化 (Currying)
        //button.setTarget(self, action: MasonryViewController.onButtonTap, controlEvent: .touchUpInside)
        //button.performActionForControlEvent(controlEvent: .touchUpInside)
        
        //UIView.animateKeyframes(withDuration: 5.0, delay: 0.0, options: []) {
        //
        //} completion: {_ in
        //
        //}
        
        //UIView.animate(withDuration: 5.0, delay: 0.0, options: []) {
        //
        //} completion: { (isComplete) in
        //    if isComplete {
        //
        //    }
        //}
        
//        UIView.animate(withDuration: 0.3, delay: 0.0,
//       options: [.curveEaseIn, .allowUserInteraction], animations: {},
//       completion: nil)
    }
    
    func onButtonTap() {
        print("Button was tapped")
    }
    
    func masonryTest() {
        let columns = 4
        let w = self.view.frame.size.width / 4.0
        var index = 0
        let begin = CACurrentMediaTime()
        while index < 10000 {
            let v = UIView.init()
            v.backgroundColor = UIColor.init(red: CGFloat(arc4random() % 255)/255.0, green: CGFloat(arc4random() % 255)/255.0, blue: CGFloat(arc4random() % 255)/255.0, alpha: 1.0)
            self.view.addSubview(v)
            let leftWidth = CGFloat((index % columns)) * w
            let topWidth = CGFloat((index / columns)) * w
            v.mas_makeConstraints { (make) in
                make?.height.equalTo()(w)
                make?.width.equalTo()(w)
                make?.top.equalTo()(topWidth)
                make?.left.equalTo()(leftWidth)
            }
            index += 1
        }
        let end = CACurrentMediaTime()
        print(String(format:"%.6f",end - begin));
    }
    
    func snapTest() {
        let columns = 4
        let w = self.view.frame.size.width / 4.0
        var index = 0
        let begin = CACurrentMediaTime()
        while index < 1000 {
            let v = UIView.init()
            v.backgroundColor = UIColor.init(red: CGFloat(arc4random() % 255)/255.0, green: CGFloat(arc4random() % 255)/255.0, blue: CGFloat(arc4random() % 255)/255.0, alpha: 1.0) //colors[Int(arc4random()) % 13]
            self.view.addSubview(v)
            let leftWidth = CGFloat((index % columns)) * w
            let topWidth = CGFloat((index / columns)) * w
            v.snp.makeConstraints { (make) in
                make.height.equalTo(w)
                make.right.equalTo(w)
                make.top.equalTo(topWidth)
                make.left.equalTo(leftWidth)
            }
            index += 1
        }
        let end = CACurrentMediaTime()
        print(String(format:"%.6f",end - begin));
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
