//
//  ClosureExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/6.
//  Copyright © 2020 Patrick Balestra. All rights reserved.
//

import Foundation

/**
 { (parameters) -> return type in
     statements
 }
 */

class ClosureExample {
    
    var completionHandlers: [() -> Void] = []
    
    func sortNames() {
        let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        
        // 1
        var reversedNames = names.sorted(by: backward)
        
        // 2
        reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
            return s1 > s2
        })
        
        //或者
        reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in return s1 > s2 } )
        
        // 3
        reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )
        
        // 4
        reversedNames = names.sorted(by: {s1, s2 in s1 > s2})
        
        // 5
        reversedNames = names.sorted(by: { $0 > $1 } )
        
        // 6
        reversedNames = names.sorted(by: >)
        
        //尾随闭包，当你使用尾随闭包时，你甚至可以把 () 省略掉：
        reversedNames = names.sorted() { $0 > $1 }
        reversedNames = names.sorted { $0 > $1 }
        
        print(reversedNames)
        
        
        
    }
    
    //尾随闭包是一个书写在函数圆括号之后的闭包表达式，函数支持将其作为最后一个参数调用
    func takesAClosure() {
        // 以下是不使用尾随闭包进行函数调用
        someFunctionThatTakesAClosure(closure: {
            // 闭包主体部分
            print("以下是不使用尾随闭包进行函数调用")
        })
        // 以下是使用尾随闭包进行函数调用，当你使用尾随闭包时，你甚至可以把 () 省略掉
        someFunctionThatTakesAClosure() {
            // 闭包主体部分
            print("以下是使用尾随闭包进行函数调用")
        }
        
        
        let digitNames = [
            0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
            5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
        ]
        let numbers = [16, 58, 510]
        //通过尾随闭包语法，优雅地在函数后封装了闭包的具体功能，而不再需要将整个闭包包裹在 map(_:) 方法的括号内
        let strings = numbers.map {
            (number) -> String in
            var number = number
            var output = ""
            repeat {
                output = digitNames[number % 10]! + output
                number /= 10
            } while number > 0
            return output
        }
        print(strings)
    }
    
    func backward(_ s1: String, _ s2: String) -> Bool {
        return s1 > s2
    }
    
    func someFunctionThatTakesAClosure(closure: () -> Void) {
        // 函数体部分
        closure()
    }
    
    func captureValue() {
       let incrementByTen = makeIncrementer(forIncrement: 10)
        // 返回的值为10
       var result = incrementByTen()
        // 返回的值为20
        result = incrementByTen()
       // 返回的值为30
        result = incrementByTen()
        print(result)
        
        let alsoIncrementByTen = incrementByTen
        // 返回的值为40
        result = alsoIncrementByTen()
        //闭包是引用类型，将闭包赋值给了两个不同的常量或变量，两个值都会指向同一个闭包
        
    }
    
    //外围函数捕获了 runningTotal 和 amount 变量的引用。捕获引用保证了 runningTotal 和 amount 变量在调用完 makeIncrementer 后不会消失
    /**
     为了优化，如果一个值不会被闭包改变，或者在闭包创建后不会改变，Swift 可能会改为捕获并保存一份对值的拷贝。
     Swift 也会负责被捕获变量的所有内存管理工作，包括释放不再需要的变量。
     */
    func makeIncrementer(forIncrement amount: Int) -> () -> Int {
        var runningTotal = 0
        func incrementer() -> Int {
            print(Unmanaged.passUnretained(runningTotal as AnyObject).toOpaque())
            runningTotal += amount
             /*let address = String(format: "-%p", runningTotal)
             print(address)*/
             print(Unmanaged.passUnretained(runningTotal as AnyObject).toOpaque())
            return runningTotal
        }
        return incrementer
    }
    
    //当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸。
    //当你定义接受闭包作为参数的函数时，你可以在参数名之前标注 @escaping，用来指明这个闭包是允许“逃逸”出这个函数的
    //@escaping
    //Converting non-escaping parameter 'completionHandler' to generic parameter 'Element' may allow it to escape
    func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
        completionHandlers.append(completionHandler)
    }
    
    //非逃逸闭包
    func someFunctionWithNonescapingClosure(closure: () -> Void) {
        closure()
    }
    
    var x = 10
    func doSomething() {
        //将一个闭包标记为 @escaping 意味着你必须在闭包中显式地引用 self
        someFunctionWithEscapingClosure { self.x = 100 }
        //传递到 someFunctionWithNonescapingClosure(_:) 中的闭包是一个非逃逸闭包，
        //这意味着它可以隐式引用 self
        someFunctionWithNonescapingClosure { x = 200 }
    }
    //自动闭包
    //过度使用 autoclosures 会让你的代码变得难以理解。
    //上下文和函数名应该能够清晰地表明求值是被延迟执行的
    func autoclosures() {
        var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        print(customersInLine.count)
        // 打印出“5”

        let customerProvider = { customersInLine.remove(at: 0) }
        print(customersInLine.count)
        // 打印出“5”

        print("Now serving \(customerProvider())!")
        // Prints "Now serving Chris!"
        print(customersInLine.count)
        // 打印出“4”
        
        serve(customer: customersInLine.remove(at: 0))
        // 打印“Now serving Ewa!”
        
        //同时使用 @autoclosure 和 @escaping 属性
        collectCustomerProviders(customersInLine.remove(at: 0))
        collectCustomerProviders(customersInLine.remove(at: 0))

        print("Collected \(customerProviders.count) closures.")
        // 打印“Collected 2 closures.”
        for customerProvider in customerProviders {
            print("Now serving \(customerProvider())!")
        }
        // 打印“Now serving Barry!”
        // 打印“Now serving Daniella!”
    }
    
    // customersInLine is ["Ewa", "Barry", "Daniella"]
    func serve(customer customerProvider: @autoclosure () -> String) {
        print("Now serving \(customerProvider())!")
    }
    
    // customersInLine i= ["Barry", "Daniella"]
    var customerProviders: [() -> String] = []
    func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
        customerProviders.append(customerProvider)
    }
}
