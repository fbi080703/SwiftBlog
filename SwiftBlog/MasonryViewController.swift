//
//  MasonryViewController.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/22.
//  Copyright © 2020 Patrick Balestra. All rights reserved.
//

import Foundation
import UIKit
import Masonry
import SnapKit


class MasonryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray
        //var rows = 0
        let columns = 4
        let w = self.view.frame.size.width / 4.0
        var index = 0
        //var views : [UIView] = []
        //print(Date.init())
//        let begin = CACurrentMediaTime()
//        while index < 10000 {
//            let v = UIView.init()
//            v.backgroundColor = UIColor.init(red: CGFloat(arc4random() % 255)/255.0, green: CGFloat(arc4random() % 255)/255.0, blue: CGFloat(arc4random() % 255)/255.0, alpha: 1.0)
//            self.view.addSubview(v)
//            let leftWidth = CGFloat((index % columns)) * w
//            let topWidth = CGFloat((index / columns)) * w
//            v.mas_makeConstraints { (make) in
//                make?.height.equalTo()(w)
//                make?.width.equalTo()(w)
//                make?.top.equalTo()(topWidth)
//                //make?.right.and()?.left()?.equalTo()(leftWidth)
//                make?.left.equalTo()(leftWidth)
//                //make?.top.equalTo()(self.view)
//            }
//            index += 1
//        }
//        let end = CACurrentMediaTime()
        //print(String(format:"%.6f",end - begin));
        //print(Date.init()) */
        
        /*
         make.top.mas_equalTo(self.view.mas_height).offset(64);
                make.bottom.mas_equalTo(self.view.mas_bottom);
                make.left.mas_equalTo(self.view.mas_left);
                make.right.mas_equalTo(self.view.mas_right);
         */
        
        //print(Date.init())
        let begin = CACurrentMediaTime()
        while index < 100 {
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
        //print(Date.init())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
