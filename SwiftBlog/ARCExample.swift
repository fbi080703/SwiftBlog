//
//  ARCExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/15.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

//引用计数仅仅应用于类的实例。结构体和枚举类型是值类型，不是引用类型，也不是通过引用的方式存储和传递

//解决实例之间的循环强引用
//Swift 提供了两种办法用来解决你在使用类的属性时所遇到的循环强引用问题：弱引用（weak reference）和无主引用（unowned reference）
//当其他的实例有更短的生命周期时，使用弱引用，也就是说，当其他实例析构在先时。在上面公寓的例子中，很显然一个公寓在它的生命周期内会在某个时间段没有它的主人，所以一个弱引用就加在公寓类里面，避免循环引用。相比之下，当其他实例有相同的或者更长生命周期时，请使用无主引用

class PersonARC {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    //weak ARC 会在引用的实例被销毁后自动将其弱引用赋值为 nil。并且因为弱引用需要在运行时允许被赋值为 nil，所以它们会被定义为可选类型变量，而不是常量
    weak var tenant: PersonARC?
    //'weak' must be a mutable variable, because it may change at runtime，运行时自动设置为nil
    //'weak' variable should have optional type 'PersonARC?'
    deinit { print("Apartment \(unit) is being deinitialized") }
}

//当 ARC 设置弱引用为 nil 时，属性观察不会被触发

//无主引用

//无主引用通常都被期望拥有值。不过 ARC 无法在实例被销毁后将无主引用设为 nil，因为非可选类型的变量不允许被赋值为 nil
//使用无主引用，你必须确保引用始终指向一个未销毁的实例。
//如果你试图在实例被销毁后，访问该实例的无主引用，会触发运行时错误。


class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    //一个客户可能有或者没有信用卡，但是一张信用卡总是关联着一个客户
    //由于信用卡总是关联着一个客户，因此将 customer 属性定义为无主引用
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}


//Person 和 Apartment 的例子展示了两个属性的值都允许为 nil，并会潜在的产生循环强引用。这种场景最适合用弱引用来解决。
//Customer 和 CreditCard 的例子展示了一个属性的值允许为 nil，而另一个属性的值不允许为 nil，这也可能会产生循环强引用。这种场景最适合通过无主引用来解决。


//第三种场景：
//两个属性都必须有值，并且初始化完成后永远不会为 nil。在这种场景中，需要一个类使用无主属性，而另外一个类使用隐式解包可选值属性

//每个国家必须有首都，每个城市必须属于一个国家
class Country {
    let name: String
    var capitalCity: CityARC! //声明为隐式解包可选值类型的属性
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = CityARC(name: capitalName, country: self)
    }
}

class CityARC {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}


//闭包的循环强引用

class HTMLElement {

    let name: String
    let text: String?

    //闭包强引用
    //如果被捕获的引用绝对不会变为 nil，应该用无主引用，而不是弱引用
    lazy var asHTML: () -> String = {
        [unowned self] in //闭包解决强引用
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }

    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }

    deinit {
        print("\(name) is being deinitialized")
    }

}

//解决闭包的循环强引用

//有参数版本
//lazy var someClosure = {
//    [unowned self, weak delegate = self.delegate]
//    (index: Int, stringToProcess: String) -> String in
//    // 这里是闭包的函数体
//}

//无参数版本
//lazy var someClosure = {
//    [unowned self, weak delegate = self.delegate] in
//    // 这里是闭包的函数体
//}

//在闭包和捕获的实例总是互相引用并且总是同时销毁时，将闭包内的捕获定义为 无主引用。
//相反的，在被捕获的引用可能会变为 nil 时，将闭包内的捕获定义为 弱引用。弱引用总是可选类型，并且当引用的实例被销毁后，弱引用的值会自动置为 nil。这使我们可以在闭包体内检查它们是否存在。

//如果被捕获的引用绝对不会变为 nil，应该用无主引用，而不是弱引用
