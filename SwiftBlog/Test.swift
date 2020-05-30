//
//  Test.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/5/7.
//  Copyright © 2020 Patrick Balestra. All rights reserved.
//

import Foundation

@objc public protocol SwiftProtocol {
    static func someTypeMethod()
}


class TestSample : NSObject ,SwiftProtocol {
    static func someTypeMethod() {
        print("someTypeMethod")
    }
    
    static func dddd() {
        
    }
    
    func printName() {
        print("Type 'TestSample' does not conform to protocol 'NSObjectProtocol'")
        
//        let instance = Test.instance()
//        if let dd = instance as? TestProtocol {
//            dd.printName()
//        }
        //
        //if let dddd = instance as? TestProtocol.Type {
        //    dddd.dddd()
        //}
    }
    
}
