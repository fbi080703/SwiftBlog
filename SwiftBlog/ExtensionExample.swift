//
//  ExtensionExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/12.
//  Copyright © 2020 Patrick Balestra. All rights reserved.
//

import Foundation

//扩展

extension Double {
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
    
    //var ddd : Double  Extensions must not contain stored properties
}

//扩展可以添加新的计算属性，但是它们不能添加存储属性，或向现有的属性添加属性观察者。

/*
 let oneInch = 25.4.mm
 print("One inch is \(oneInch) meters")
 // 打印“One inch is 0.0254 meters”
 let threeFeet = 3.ft
 print("Three feet is \(threeFeet) meters")
 // 打印“Three feet is 0.914399970739201 meters”
*/


//扩展可以给一个类添加新的便利构造器，但是它们不能给类添加新的指定构造器或者析构器。指定构造器和析构器必须始终由类的原始实现提供


struct ExtensionSize {
    var width = 0.0, height = 0.0
}
struct ExtensionPoint {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = ExtensionPoint()
    var size = ExtensionSize()
}


extension Rect {
    //如果你通过扩展提供一个新的构造器，你有责任确保每个通过该构造器创建的实例都是初始化完整的。
    init(center: ExtensionPoint, size: ExtensionSize) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: ExtensionPoint(x: originX, y: originY), size: size)
    }
}


//可变实例方法
//通过扩展添加的实例方法同样也可以修改（或 mutating（改变））实例本身。
//结构体和枚举的方法，若是可以修改 self 或者它自己的属性，则必须将这个实例方法标记为 mutating，就像是改变了方法的原始实现。


extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}
