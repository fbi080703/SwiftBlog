//
//  InheritExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/10.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

class Vehicle {
    var currentSpeed = 0.0
    var description: String {
        return "traveling at \(currentSpeed) miles per hour"
    }
    func makeNoise() {
        // 什么也不做——因为车辆不一定会有噪音
    }
    // get property
    /*var defaultType : String {
        return "Vehicle"
    }*/
    
    var defaultType : String = ""
    
}

class Bicycle: Vehicle {
    var hasBasket = false
}

/**
 你可以将一个继承来的只读属性重写为一个读写属性，只需要在重写版本的属性里提供 getter 和 setter 即可。但是，你不可以将一个继承来的读写属性重写为一个只读属性。
 */

class Train: Vehicle {
    private var _defaultType: String = ""
    override init() {
        super.init()
        _defaultType = super.defaultType
    }
    
    override func makeNoise() {
        print("Choo Choo")
    }
    
    //var gear : Int = 0
    
    //Cannot override mutable property with read-only property 'defaultType'
    //不可以将一个继承来的读写属性重写为一个只读属性。
    override var defaultType: String {
        get { return _defaultType }
        set { _defaultType = newValue}
    }
}

/*
 你不可以为继承来的常量存储型属性或继承来的只读计算型属性添加属性观察器。
 这些属性的值是不可以被设置的，所以，为它们提供 willSet 或 didSet 实现也是不恰当。
 此外还要注意，你不可以同时提供重写的 setter 和重写的属性观察器。
 如果你想观察属性值的变化，并且你已经为那个属性提供了定制的 setter，那么你在 setter 中就可以观察到任何值变化了
 */

class AutomaticCar: Vehicle {
    var gear : Int = 0
    override var currentSpeed: Double {
        didSet {
            gear = Int(currentSpeed / 10.0) + 1
        }
    }
}

//防止重写
//可以通过把方法，属性或下标标记为 final 来防止它们被重写
//可以通过在关键字 class 前添加 final 修饰符（final class）来将整个类标记为 final 。
//这样的类是不可被继承的，试图继承这样的类会导致编译报错
