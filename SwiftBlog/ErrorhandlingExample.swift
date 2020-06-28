//
//  ErrorhandlingExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/11.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

//错误处理

enum VendingMachineError: Error {
    case invalidSelection                     //选择无效
    case insufficientFunds(coinsNeeded: Int) //金额不足
    case outOfStock                             //缺货
}

struct Item {
    var price: Int
    var count: Int
}

class VendingMachine {
    var inventory = [
        "Candy Bar": Item(price: 12, count: 7),
        "Chips": Item(price: 10, count: 4),
        "Pretzels": Item(price: 7, count: 11)
    ]
    var coinsDeposited = 0

    func vend(itemNamed name: String) throws {
        guard let item = inventory[name] else {
            throw VendingMachineError.invalidSelection
        }

        guard item.count > 0 else {
            throw VendingMachineError.outOfStock
        }

        guard item.price <= coinsDeposited else {
            throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
        }

        coinsDeposited -= item.price

        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem

        print("Dispensing \(name)")
    }
    
    //func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
    //    let snackName = favoriteSnacks[person] ?? "Candy Bar"
    //    try vendingMachine.vend(itemNamed: snackName)
    //}
}

//用 throwing 函数传递错误
//一个 throwing 函数可以在其内部抛出错误，并将错误传递到函数被调用时的作用域
//只有 throwing 函数可以传递错误。任何在某个非 throwing 函数内部抛出的错误只能在函数内部处理
/**

 func canThrowErrors() throws -> String

 func cannotThrowErrors() -> String
 
*/

/*
var vendingMachine = VendingMachine()
vendingMachine.coinsDeposited = 8
do {
    try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
    print("Success! Yum.")
} catch VendingMachineError.invalidSelection {
    print("Invalid Selection.")
} catch VendingMachineError.outOfStock {
    print("Out of Stock.")
} catch VendingMachineError.insufficientFunds(let coinsNeeded) {
    print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
} catch {
    print("Unexpected error: \(error).")
}
*/
// 打印“Insufficient funds. Please insert an additional 2 coins.”


//禁用错误传递 try!


/*

 func processFile(filename: String) throws {
     if exists(filename) {
         let file = open(filename)
         defer {
             close(file)
         }
         while let line = try file.readline() {
             // 处理文件。
         }
         // close(file) 会在这里被调用，即作用域的最后。
     }
}

 */
