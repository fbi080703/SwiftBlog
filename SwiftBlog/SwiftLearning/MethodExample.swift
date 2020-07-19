//
//  MethodExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/9.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

struct MethodExample {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        //Left side of mutating operator isn't mutable: 'self' is immutable
        //Mark method 'mutating' to make 'self' mutable
        x += deltaX
        y += deltaY
    }
}
/*
var somePoint = MethodExample(x: 1.0, y: 1.0)
somePoint.moveBy(x: 2.0, y: 3.0)
print("The point is now at (\(somePoint.x), \(somePoint.y))")
// 打印“The point is now at (3.0, 4.0)”
*/

/*
let fixedPoint = MethodExample(x: 3.0, y: 3.0)
fixedPoint.moveBy(x: 2.0, y: 3.0)
// 这里将会报告一个错误
//Change 'let' to 'var' to make it mutable
*/

//类型方法
//实例方法是被某个类型的实例调用的方法。你也可以定义在类型本身上调用的方法，这种方法就叫做类型方法。
//在方法的 func 关键字之前加上关键字 static，来指定类型方法。类还可以用关键字 class 来指定，从而允许子类重写父类该方法的实现

struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1

    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel { highestUnlockedLevel = level }
    }

    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }

    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}
