//
//  SwiftClass.swift
//  Test
//
//  Created by wulongwang on 2020/5/23.
//  Copyright © 2020 wulongwang. All rights reserved.
//

import Foundation

//Swift 运行时

//纯 Swift 类的函数调用已经不再是 Objective-c 的运行时发消息，而是类似 C++ 的 vtable，在编译时就确定了 调用哪个函数，所以没法通过 runtime 获取方法、属性。
//而 Swift 为了兼容 Objective-C，凡是继承自 NSObjec t的类都会保留其动态性，所以我们能通过 runtime 拿 到他的方法。这里有一点说明:老版本的 Swift(如2.2)是编译期隐式的自动帮你加上了@objc，而4.0以后版 本的 Swift 编译期去掉了隐式特性，必须使用显式添加。
//不管是纯 Swift 类还是继承自 NSObject 的类只要在属性和方法前面添加 @objc 关键字就可以使用 runtime

//class MyClass {
//  dynamic func foo() { }       // error: 'dynamic' method must be '@objc'
//  //@objc dynamic func bar() { } // okay
//}

//: NSObject
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
    
    //@nonobjc
    @objc public func dynamicEcho(
        _ val: Int) -> Int
    {
        return val
    }
    
//   @objc dynamic public func test() {
//        print("test")
//    }
}

extension SwiftClass {
    @objc dynamic public func echoExtension(
        _ val: Int) -> Int {
        return val
    }
    
    public func test() {
        print("test")
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
