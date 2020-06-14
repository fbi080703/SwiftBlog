//
//  ConstructExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/10.
//  Copyright © 2020 Patrick Balestra. All rights reserved.
//

import Foundation


struct Celsius {
    var temperatureInCelsius: Double
    init(fromFahrenheit fahrenheit: Double) {
        temperatureInCelsius = (fahrenheit - 32.0) / 1.8
    }
    init(fromKelvin kelvin: Double) {
        temperatureInCelsius = kelvin - 273.15
    }
    
    //不需要实参标签
    init(_ celsius: Double){
        temperatureInCelsius = celsius
    }
}

/**
 let boilingPointOfWater = Celsius(fromFahrenheit: 212.0)
 // boilingPointOfWater.temperatureInCelsius 是 100.0
 let freezingPointOfWater = Celsius(fromKelvin: 273.15)
 // freezingPointOfWater.temperatureInCelsius 是 0.0
 
 //不需要实参标签
 let bodyTemperature = Celsius(37.0)
 // bodyTemperature.temperatureInCelsius 为 37.0
 */
struct Color {
    let red, green, blue: Double
    init(red: Double, green: Double, blue: Double) {
        self.red   = red
        self.green = green
        self.blue  = blue
    }
    init(white: Double) {
        red   = white
        green = white
        blue  = white
    }
}

/**
 //通过实参标签传值
 let magenta = Color(red: 1.0, green: 0.0, blue: 1.0)
 let halfGray = Color(white: 0.5)
 */

//对于类的实例来说，它的常量属性只能在定义它的类的构造过程中修改；不能在子类中修改

class SurveyQuestion {
    let text: String
    var response: String?
    //构造过程中的任意时间点给常量属性赋值，只要在构造过程结束时它设置成确定的值。
    //一旦常量属性被赋值，它将永远不可更改。
    init(text: String) {
        self.text = text
    }
    func ask() {
        print(text)
    }
}

/*
let beetsQuestion = SurveyQuestion(text: "How about beets?")
beetsQuestion.ask()
// 打印“How about beets?”
beetsQuestion.response = "I also like beets. (But not with cheese.)"
 
*/

//结构体的逐一成员构造器
//结构体如果没有定义任何自定义构造器，它们将自动获得一个逐一成员构造器（memberwise initializer）
struct Size {
    var width = 0.0, height = 0.0
}
//let twoByTwo = Size(width: 2.0, height: 2.0)

//指定构造器和便利构造器的语法
//指定构造器
/*init(parameters) {
    statements
}*/

//便利构造器
/*convenience init(parameters) {
    statements
}*/

//
/*一个更方便记忆的方法是：
指定构造器必须总是向上代理
便利构造器必须总是横向代理 */


class Hoverboard: Vehicle {
    var color: String
    init(color: String) {
        self.color = color //子类特有的属性赋值，需要在调用父类构造函数之前初始化
        super.init() //在这里被隐式调用
        //self.currentSpeed = 5
    }
    override var description: String {
        return "\(super.description) in a beautiful \(color)"
    }
}

//子类可以在构造过程修改继承来的变量属性，但是不能修改继承来的常量属性。


/**

 规则 1
     如果子类没有定义任何指定构造器，它将自动继承父类所有的指定构造器。
 规则 2
     如果子类提供了所有父类指定构造器的实现——无论是通过规则 1 继承过来的，还是提供了自定义实现——它将自动继承父类所有的便利构造器。
 即使你在子类中添加了更多的便利构造器，这两条规则仍然适用。
 注意
 子类可以将父类的指定构造器实现为便利构造器来满足规则 2
 
*/
class Food {
    var name: String
    init(name: String) {
        self.name = name
    }

    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

//RecipeIngredient 将父类的指定构造器重写为了便利构造器，但是它依然提供了父类的所有指定构造器的实现。
//因此，RecipeIngredient 会自动继承父类的所有便利构造器
class RecipeIngredient: Food {
    var quantity: Int
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

/**
 let oneMysteryItem = RecipeIngredient()
 let oneBacon = RecipeIngredient(name: "Bacon")
 let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)
*/

//必要构造器
//在类的构造器前添加 required 修饰符表明所有该类的子类都必须实现该构造器

class SomeRequiredClass {
    required init() {
        // 构造器的实现代码
    }
    
    deinit {
        // 执行析构过程
    }
    
}

//如果子类继承的构造器能满足必要构造器的要求，则无须在子类中显式提供必要构造器的实现

//在子类重写父类的必要构造器时，必须在子类的构造器前也添加 required 修饰符，表明该构造器要求也应用于继承链后面的子类。
//在重写父类中必要的指定构造器时，不需要添加 override 修饰符
class SomeRequiredSubclass: SomeRequiredClass {
     required init() {
        // 构造器的实现代码
    }
    
    let someProperty: String = {
        // 在这个闭包中给 someProperty 创建一个默认值
        // someValue 必须和 SomeType 类型相同
        return "someProperty"
    }() //注意闭包结尾的花括号后面接了一对空的小括号。这用来告诉 Swift 立即执行此闭包。如果你忽略了这对括号，相当于将闭包本身作为值赋值给了属性，而不是将闭包的返回值赋值给属性
    
    deinit {
        // 执行析构过程
    }
}

//通过闭包或函数设置属性的默认值 someProperty

//如果你使用闭包来初始化属性，请记住在闭包执行时，实例的其它部分都还没有初始化。
//这意味着你不能在闭包里访问其它属性，即使这些属性有默认值。
//同样，你也不能使用隐式的 self 属性，或者调用任何实例方法。
