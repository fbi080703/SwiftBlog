//
//  SwiftTipsExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/27.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation
import UIKit

class SwiftTipsExample {
    
    func example() throws {
        let addTwo = addTo(2) // addTwo: Int -> Int
        _ = addTwo(6) // result = 8
        //print(result)
        
        let greaterThan10 = greaterThan(10);
        greaterThan10(13) // => true
        greaterThan10(9) // => false
        
        // MARK: ReverseSequence
        
        reverseSequenceTest()
        
        // MARK: autoclosure
        
        //logIfTrue(){2 > 1}
        //logIfTrue{2 > 1} //因为这个闭包是最后一个参数，所以可以使用尾随闭包 (trailing closure) 的方式 把大括号拿出来，然后省略括号
        //logIfTrue(2 > 1) //参数名前面加上 @autoclosure 关键字
        //@autoclosure 并不支持带有输入参数的写法，也就是说只有形如 () -> T 的参数才能使用这个特性进行简化
        //autoclosure 可以避免不必要的开销
        
        // MARK: 下标（subscript）
        
        var arr = [1,2,3,4,5]
        print(arr[[0,2,3]]) //[1,3,4]
        arr[[0,2,3]] = [-1,-3,-4]
        print(arr) //[-1, 2, -3, -4, 5]
        
        // MARK: 方法嵌套
        
        
        // MARK: 正则表达式
        
        let mailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher: RegexHelper
        do {
            matcher = try RegexHelper(mailPattern)
        }
        let maybeMailAddress = "fbi080703@sina.com"
        if matcher.match(maybeMailAddress) {
            print("有效的邮箱地址")
        }
        
        if "fbi080703@sina.com" =~ "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$" {
            print("有效的邮箱地址")
        }
        
        // MARK: AnyClass，元类型和 .self
        
        //通过 AnyObject.Type 这种方式所得到是一个元类型 (Meta)。
        //在声明时我们总是在类型的名称后面 加上 .Type ，比如 AAAA.Type 代表的是 AAAA 这个类型的类型
        //.self 可以用在类型后面取得类型本身，也可以用在某个实例后面取得 这个实例本身
        //.Type 表示的是某个类型的元类型
        let typeA: AAAA.Type = AAAA.self
        typeA.method()
        
        // 或者
        let anyClass: AnyClass = AAAA.self
        (anyClass as! AAAA.Type).method()
        
        let usingVCTypes: [AnyClass] = [MusicViewController.self, AlbumViewController.self]
        setupViewControllers(usingVCTypes)
        
        // MARK: 属性观察
        
        //get 首先被调用了一次。 这是因为我们实现了 didSet, didSet 中会用到 oldValue
        //如果我们不实现 didSet 的话，这次 get 操作也将 不存在。
        
        let b = BBBB()
        b.number = 0
        /*
         get
         willSet
         set
         didSet
        */
    }
    
    // MARK: 柯里化 (Currying)
    
    func addTo(_ adder: Int) -> (Int) -> Int {
        return {
          num in
            return num + adder
        }
    }
    
    func greaterThan(_ comparer: Int) -> (Int) -> Bool {
        return { $0 > comparer }
    }
    
    // MARK: ReverseSequence
    
    func reverseSequenceTest() {
        let arr = [0,1,2,3,4]
        // 对 Sequence 可以使用 for...in 来循环访问
        for i in ReverseSequence(array: arr) {
           print("Index \(i) is \(arr[i])")
        }
    }
    
    // MARK: autoclosure
    
    //_ predicate: @autoclosure () -> Bool logIfTrue(2 > 1)
    func logIfTrue(_ predicate: () -> Bool) {
        if predicate() {
           print("True")
        }
    }
    
    // MARK: Optional Chaining
    
    // MARK: 方法嵌套
    
    func appendQuery(url: String, key: String, value: AnyObject) -> String {
        func appendQueryDictionary(url: String, key: String, value: [String: AnyObject]) -> String {
            //....
            return ""
        }
        
        func appendQueryArray(url: String, key: String, value: [AnyObject]) -> String {
            //...
            return ""
        }
        
        func appendQuerySingle(url: String, key: String, value: AnyObject) -> String {
            //..
            return ""
        }
        
        if let dictionary = value as? [String: AnyObject] {
            return appendQueryDictionary(url: url, key: key, value: dictionary)
        } else if let array = value as? [AnyObject] {
            return appendQueryArray(url: url, key: key, value: array)
        } else {
            return appendQuerySingle(url: url, key: key, value: value)
        }
    }
    
    // MARK: AnyClass，元类型和 .self
    
    func setupViewControllers(_ vcTypes: [AnyClass]) {
       for vcType in vcTypes {
           if vcType is UIViewController.Type {
              let vc = (vcType as! UIViewController.Type).init()
              print(vc)
           }
        }
    }
}


// MARK: Currying Begin

protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T: AnyObject> : TargetAction {
    weak var target: T?
    let action: (T) -> () -> ()

    func performAction() -> () {
        if let t = target {
            action(t)()
        }
    }
}

enum ControlEvent {
    case touchUpInside
    case valueChanged
}

class Control {
    var actions = [ControlEvent: TargetAction]()

    func setTarget<T: AnyObject>(_ target: T, action: @escaping (T) -> () -> (), controlEvent: ControlEvent) {
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
    }

    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }

    func performActionForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performAction()
    }
}

// MARK: Currying End

// MARK: ReverseSequence

// 先定义一个实现了 IteratorProtocol 协议的类型
// IteratorProtocol 需要指定一个 typealias Element
// 以及提供一个返回 Element? 的方法 next()
class ReverseIterator<T>: IteratorProtocol {
    typealias Element = T
    var array: [Element]
    var currentIndex = 0
    
    init(array: [Element]) {
        self.array = array
        currentIndex = array.count - 1
    }
    func next() -> Element? {
        if currentIndex < 0 {
            return nil
            
        }
        else {
           let element = array[currentIndex]
            currentIndex -= 1
           return element
        }
    }
}

// 然后我们来定义 Sequence
// 和 IteratorProtocol 很类似，不过换成指定一个 typealias Iterator
// 以及提供一个返回 Iterator? 的方法 makeIterator()
struct ReverseSequence<T>: Sequence {
    var array: [T]
    init (array: [T]) {
       self.array = array
    }
    
    typealias Iterator = ReverseIterator<T>
    
    func makeIterator() -> ReverseIterator<T> {
        return ReverseIterator(array: self.array)
    }
}

// MARK: 下标（subscript）

 extension Array {
    subscript(input: [Int]) -> ArraySlice<Element> {
        get {
            var result = ArraySlice<Element>()
            for i in input {
               assert(i < self.count, "Index out of range")
               result.append(self[i])
            }
            return result
        }
        set {
            for (index,i) in input.enumerated() {
                //print("---\(index)---\(i)")
                assert(i < self.count, "Index out of range")
                self[i] = newValue[index]
            }
        }
    }
}

// MARK: associatedtype

protocol FoodExample { }
protocol Animal {
    //func eat(_ food: FoodExample)
    
    associatedtype F : FoodExample
    func eat(_ food: F)
}

struct Meat: FoodExample { }
struct Grass: FoodExample { }

struct Tiger: Animal {
   /*func eat(_ food: FoodExample) {
       /*if let meat = food as? Meat { //转换没有意义，将责任扔给了运行时
          print("eat \(meat)")
       } else {
          fatalError("Tiger can only eat meat!")
       }*/
       
       //print("eat \(food)") //造成Tiger吃素食的情况
   }*/
    
   //在 Tiger 通过 typealias 具体指定 F 为 Meat 之前， Animal 协议中并不关心 F 的具体类型， 只需要满足协议的类型中的 F 和 eat 参数一致即可。如此一来，我们就可以避免在 Tiger 的eat 中进行判定和转换了
   typealias F = Meat
   func eat(_ food: Meat) {
      print("eat \(food)")
   }
}

// MARK: static 和 class

struct PointTips {
    let x: Double
    let y: Double
    // 存储属性
    static let zero = PointTips(x: 0, y: 0) //static适用场景
    // 计算属性
    static var ones: [PointTips] { //static适用场景
       return [PointTips(x: 1, y: 1),
               PointTips(x: -1, y: 1),
               PointTips(x: 1, y: -1),
               PointTips(x: -1, y: -1)]
    }
    // 类型方法
    static func add(p1: PointTips, p2: PointTips) -> PointTips {
        return PointTips(x: p1.x + p2.x, y: p1.y + p2.y)
    }
}


// MARK: 正则表达式

 struct RegexHelper {
    let regex: NSRegularExpression
    init(_ pattern: String) throws {
      try regex = NSRegularExpression(pattern: pattern,options: .caseInsensitive)
    }
    func match(_ input: String) -> Bool {
         let matches = regex.matches(in: input,options: [],range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
}


precedencegroup MatchPrecedence {
    associativity: none
    higherThan: DefaultPrecedence
}

infix operator =~: MatchPrecedence
func =~(lhs: String, rhs: String) -> Bool {
    do {
       return try RegexHelper(rhs).match(lhs)
    } catch _ {
       return false
    }
}

// MARK: 模式匹配


// MARK: AnyClass，元类型和 .self

//typealias AnyClass = AnyObject.Type
//.Type 表示的是某个类型的元类型

class AAAA {
    class func method() {
       print("Hello")
    }
}

class MusicViewController: UIViewController {
}
class AlbumViewController: UIViewController {
}


// MARK: 协议和类方法中的 Self

//Self 不仅指代的是实现该协议的类型本身，也包括了这个类型的子类


// MARK: 动态类型和多方法

//Swift 默认情况下是不采用动态 派发的，因此方法的调用只能在编译时决定，要想绕过这个限制，我们可能需要进行通过对输入类型做判断和转换

class Pet {}
class Cat: Pet {}
class Dog: Pet {}
/*

func printPet(_ pet: Pet) {
   print("Pet")
}
 
func printPet(_ cat: Cat) {
   print("Meow")
}

func printPet(_ dog: Dog) {
   print("Bark")
}
 
printPet(Cat()) // Meow
printPet(Dog()) // Bark
printPet(Pet()) // Pet
 
func printThem(_ pet: Pet, _ cat: Cat) {
   printPet(pet)
   printPet(cat)
}

printThem(Dog(), Cat())
// 输出:
// Pet
// Meow
 
func printThem(_ pet: Pet, _ cat: Cat) {
    if let aCat = pet as? Cat {
        printPet(aCat)
    } else if let aDog = pet as? Dog {
       printPet(aDog)
    }
    printPet(cat)
}
 
 // 输出:
 // Bark
 // Meow

 */

// MARK: 属性观察

class AAAAA {
    var number :Int {
        get {
            print("get")
            return 1
        }
        set {
            print("set")
        }
    }
}
class BBBB: AAAAA {
    override var number: Int {
        willSet {print("willSet")}
        didSet {print("didSet")}
    }
}

// MARK: final

//1、权限控制
//2、类或者方法的功能确实已经完备了
//3、子类继承和修改是一件危险的事情
//4、为了父类中某些代码一定会被执行

class Parent {
    final func method() {
        print("开始配置")
        // ..必要的代码
        methodImpl()
        // ..必要的代码
       print("结束配置")
    }
    
    func methodImpl() {
        fatalError("子类必须实现这个方法")
        // 或者也可以给出默认实现
    }
}

class Child: Parent {
    override func methodImpl() {
     //..子类的业务逻辑
    }
}

//5、性能考虑 //编译器能够从 final 中获取额外的信 息，因此可以对类或者方法调用进行额外的优化处理


// MARK: lazy 修饰符和 lazy 方法

/*

 let data = 1...3
 let result = data.lazy.map { //lazy 来进行性能优化效果会非常有效
      (i: Int) -> Int in
      print("正在处理 \(i)")
      return i * 2
 }
 print("准备访问结果")
 for i in result {
 print("操作后结果为 \(i)")
 }
 print("操作完毕")
 
*/

// MARK: Reflection 和 Mirror
