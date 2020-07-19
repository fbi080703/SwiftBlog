//
//   GenericExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/14.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

//泛型（Generic）

class  GenericExample {
    
    func swapTwoStrings(_ a: inout String, _ b: inout String) {
        let temporaryA = a
        a = b
        b = temporaryA
    }

    func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    //泛型
    func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
}

struct IntStack {
    var items = [Int]()
    mutating func push(_ item: Int) {
        items.append(item)
    }
    mutating func pop() -> Int {
        return items.removeLast()
    }
}

//泛型版本
struct Stack<Element> {
    var items = [Element]()
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
}

//泛型扩展

extension Stack {
    var topItem: Element? {
        return items.isEmpty ? nil : items[items.count - 1]
    }
}

//类型约束
//类型约束语法
/*
 func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
     // 这里是泛型函数的函数体部分
 }
 */

//类型约束实践

/*
 func findIndex(ofString valueToFind: String, in array: [String]) -> Int? {
     for (index, value) in array.enumerated() {
         if value == valueToFind {
             return index
         }
     }
     return nil
 }
 
 //Swift 标准库中定义了一个 Equatable 协议，该协议要求任何遵循该协议的类型必须实现等式符（==）及不等符（!=），从而能对该类型的任意两个值进行比较。所有的 Swift 标准类型自动支持 Equatable 协议
 func findIndex<T>(of valueToFind: T, in array:[T]) -> Int? {
     for (index, value) in array.enumerated() {
         if value == valueToFind { //函数无法通过编译，不是所有的 Swift 类型都可以用等式符（==）进行比较
             return index
         }
     }
     return nil
 }
 
 func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
     for (index, value) in array.enumerated() {
         if value == valueToFind {
             return index
         }
     }
     return nil
 }
 
 */

//关联类型
//关联类型通过 associatedtype 关键字来指定

//关联类型实践
protocol Container {
    associatedtype Item
    //关联类型 Item 必须遵循 Equatable 协议
    //associatedtype Item: Equatable
    mutating func append(_ item: Item)
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

//泛型 Where 语句


func allItemsMatch<C1: Container, C2: Container>
    (_ someContainer: C1, _ anotherContainer: C2) -> Bool
    where C1.Item == C2.Item, C1.Item: Equatable {
        // 检查两个容器含有相同数量的元素
        if someContainer.count != anotherContainer.count {
            return false
        }
        // 检查每一对元素是否相等
        for i in 0..<someContainer.count {
            if someContainer[i] != anotherContainer[i] {
                return false
            }
        }
        // 所有元素都匹配，返回 true
        return true
}

//具有泛型 Where 子句的扩展
extension Stack where Element: Equatable {
    func isTop(_ item: Element) -> Bool {
        guard let topItem = items.last else {
            return false
        }
        return topItem == item
    }
}

//不透明类型解决的问题

//具有不透明返回类型的函数或方法会隐藏返回值的类型信息。函数不再提供具体的类型作为返回类型，而是根据它支持的协议来描述返回值。在处理模块和调用代码之间的关系时，隐藏类型信息非常有用，因为返回的底层数据类型仍然可以保持私有。而且不同于返回协议类型，不透明类型能保证类型一致性 —— 编译器能获取到类型信息，同时模块使用者却不能获取到。


//不透明类型和协议类型的区别

//虽然使用不透明类型作为函数返回值，看起来和返回协议类型非常相似，但这两者有一个主要区别，就在于是否需要保证类型一致性。一个不透明类型只能对应一个具体的类型，即便函数调用者并不能知道是哪一种类型；协议类型可以同时对应多个类型，只要它们都遵循同一协议。总的来说，协议类型更具灵活性，底层类型可以存储更多样的值，而不透明类型对这些底层类型有更强的限定

//不透明类型
//https://swiftgg.gitbook.io/swift/swift-jiao-cheng/23_opaque_types
