//
//  SwiftGrandCentralDispatchExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/30.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

typealias Task = (_ cancel : Bool) -> Void

class SwiftGrandCentralDispatchExample {
    
    func grandCentralDispatchTest() {
        _ =  delay(2) {
            print("2 秒后输出")
        }
        
        let task2 = delay(5) {
            print("5 秒后输出")
        }
        let t = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: t) {
            print("3 秒后取消")
            self.cancel(task2)
        }
    }
    
    // MARK: GCD延时调用
    
    func delay(_ time: TimeInterval, task:@escaping ()->()) -> Task? {
        
        func dispatch_later(block: @escaping ()->()) {
            let t = DispatchTime.now() + time
            DispatchQueue.main.asyncAfter(deadline: t, execute: block)
        }
        var closure: (()->Void)? = task
        var result: Task?
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    DispatchQueue.main.async(execute: internalClosure)
                }
            }
            closure = nil
            result = nil
        }
        result = delayedClosure
        dispatch_later {
            //if let delayedClosure = result {
                delayedClosure(false)
            //}
        }
        return result;
    }
    
    func cancel(_ task: Task?) {
        task?(true)
    }
    
    deinit {
        print("SwiftGrandCentralDispatchExample deinit")
    }
}
