//
//  SwiftClass.swift
//  Test
//
//  Created by wulongwang on 2020/5/23.
//  Copyright © 2020 wulongwang. All rights reserved.
//

import Foundation

//class MyClass {
//  dynamic func foo() { }       // error: 'dynamic' method must be '@objc'
//  //@objc dynamic func bar() { } // okay
//}

public class SwiftClass : NSObject {
    public var val: Int

    public init(
        _ val: Int)

    {
        self.val = val
    }

    public func echo(
        _ val: Int) -> Int

    {
        return val
    }

    @objc
    public dynamic func dynamicEcho(
        _ val: Int) -> Int
    {
        return val
    }
}


public struct SwiftStruct {
    public let val: Int
    
    public func echo(
        _ val: Int) -> Int
    {
        return val
    }

    // @objc // Error: @objc can only be used with members of classes, @objc protocols, and concrete extensions of classes
    // public dynamic func dynamicEcho( // Error: Only members of classes may be dynamic
    //     _ val: Int) -> Int
    // {
    //     return val
    // }
}

public enum SwiftEnum {
    case a, b, c
}
