//
//  PropertyExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/8.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

//https://docs.swift.org/swift-book/LanguageGuide/Properties.html

//全局变量和局部变量
//全局的常量或变量都是延迟计算的，跟延时加载存储属性相似，不同的地方在于，全局的常量或变量不需要标记 lazy 修饰符。
//局部范围的常量和变量从不延迟计算。
var globalProperty = "globalProperty"

class StepCounter {
    
    //跟实例的存储型属性不同，必须给存储型类型属性指定默认值，因为类型本身没有构造器，也就无法在初始化过程中使用构造器给类型属性赋值。
    //存储型类型属性是延迟初始化的，它们只有在第一次被访问的时候才会被初始化。
    //即使它们被多个线程同时访问，系统也保证只会对其进行一次初始化，并且不需要对其使用 lazy 修饰符。
    static var storedTypeProperty = "storedTypeProperty"
    
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("将 totalSteps 的值设置为 \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("增加了 \(totalSteps - oldValue) 步")
            }
        }
    }
}

/**
 属性包装器在管理属性如何存储和定义属性的代码之间添加了一个分隔层。
 举例来说，如果你的属性需要线程安全性检查或者需要在数据库中存储它们的基本数据，那么必须给每个属性添加同样的逻辑代码。
 当使用属性包装器时，你只需在定义属性包装器时编写一次管理代码，然后应用到多个属性上来进行复用
 
 */
@propertyWrapper
struct TwelveOrLess {
    private var number: Int
    init() { self.number = 0 }
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, 12) }
    }
}

struct SmallRectangle {
    //one
    @TwelveOrLess var height: Int
    @TwelveOrLess var width: Int
    
    //two
    /*
    private var _height = TwelveOrLess()
    private var _width = TwelveOrLess()
    var height: Int {
        get { return _height.wrappedValue }
        set { _height.wrappedValue = newValue }
    }
    var width: Int {
        get { return _width.wrappedValue }
        set { _width.wrappedValue = newValue }
    }*/
}

//https://juejin.im/post/5df05060518825122030809e

//1、必须使用属性@propertyWrapper进行定义。
//2、它必须具有wrappedValue属性。

/*
 Property wrappers并非没有限制。 他们强加了许多限制：

 带有包装器的属性不能在子类中覆盖。
 具有包装器的属性不能是lazy，@NSCopying，@NSManaged，weak或unowned。
 具有包装器的属性不能具有自定义的set或get方法。
 wrappedValue，init（wrappedValue :)和projectedValue必须具有与包装类型本身相同的访问控制级别
 不能在协议或扩展中声明带有包装器的属性。
 */

@propertyWrapper
struct SmallNumber {
    private var maximum: Int
    private var number: Int

//    var wrappedValue: Int {
//        get { return number }
//        set { number = min(newValue, maximum) }
//    }
    
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, maximum) }
    }
    
    init() {
        maximum = 12
        number = 0
    }
    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
    }
    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
    }
}

struct ZeroRectangle {
    @SmallNumber var height: Int
    @SmallNumber var width: Int
}

//var zeroRectangle = ZeroRectangle()
//print(zeroRectangle.height, zeroRectangle.width)
// 打印 "0 0"

struct UnitRectangle {
    @SmallNumber var height: Int = 1
    @SmallNumber var width: Int = 1
}

//var unitRectangle = UnitRectangle()
//print(unitRectangle.height, unitRectangle.width)
// 打印 "1 1"

struct NarrowRectangle {
    @SmallNumber(wrappedValue: 2, maximum: 5) var height: Int
    @SmallNumber(wrappedValue: 3, maximum: 4) var width: Int
}

/*
var narrowRectangle = NarrowRectangle()
print(narrowRectangle.height, narrowRectangle.width)
// 打印 "2 3"

narrowRectangle.height = 100
narrowRectangle.width = 100
print(narrowRectangle.height, narrowRectangle.width)
// 打印 "5 4"
*/

struct MixedRectangle {
    @SmallNumber var height: Int = 1
    @SmallNumber(maximum: 9) var width: Int = 2
}

/*var mixedRectangle = MixedRectangle()
print(mixedRectangle.height)
// 打印 "1"

mixedRectangle.height = 20
print(mixedRectangle.height)
// 打印 "12"
*/

//类型属性语法
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
    
    case small, large
}
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

/**
 print(SomeStructure.storedTypeProperty)
 // 打印“Some value.”
 SomeStructure.storedTypeProperty = "Another value."
 print(SomeStructure.storedTypeProperty)
 // 打印“Another value.”
 print(SomeEnumeration.computedTypeProperty)
 // 打印“6”
 print(SomeClass.computedTypeProperty)
 // 打印“27”
 
 */

struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel: Int = 0 {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {
                // 将当前音量限制在阈值之内
                currentLevel = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                // 存储当前音量作为新的最大输入音量
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}

