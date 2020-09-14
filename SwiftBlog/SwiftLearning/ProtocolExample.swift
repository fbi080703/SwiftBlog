//
//  ProtocolExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/14.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

//协议

//协议的语法
protocol SomeProtocolExample {
    // 这里是协议的定义部分
}


protocol SomeProtocol {
    var mustBeSettable: Int { get set }
    var doesNotNeedToBeSettable: Int { get }
    
    static func someTypeMethod()
    
    func random() -> Double
    
    init(someParameter: Int)
}


//定义类型属性时，总是使用 static 关键字作为前缀。
//当类类型遵循协议时，除了 static 关键字，还可以使用 class 关键字来声明类型属性
protocol AnotherProtocol {
    static var someTypeProperty: Int { get set }
}


protocol FullyNamed {
    var fullName: String { get }
}

//var example = PersonExample(fullName: "PersonExample")
//example.fullName = "ExtensionPoint"
//print(example.fullName)
//

struct PersonExample: FullyNamed {
    var fullName: String
}
//let john = PersonExample(fullName: "John Appleseed")


class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}
// var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
// ncc1701.fullName 为 "USS Enterprise"


//实现协议中的 mutating 方法时，若是类类型，则不用写 mutating 关键字。
//而对于结构体和枚举，则必须写 mutating 关键字。


protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

/*
 
 var lightSwitch = OnOffSwitch.off
 lightSwitch.toggle()
 // lightSwitch 现在的值为 .on
 
*/

//协议构造器要求的类实现
/*
 protocol SomeProtocol {
     init(someParameter: Int)
 }
 
 class SomeClassExample: SomeProtocol {
     required init(someParameter: Int) {
         // 这里是构造器的实现部分
     }
 }
 
 protocol SomeProtocol {
     init()
 }

 class SomeSuperClass {
     init() {
         // 这里是构造器的实现部分
     }
 }

 class SomeSubClass: SomeSuperClass, SomeProtocol {
     // 因为遵循协议，需要加上 required
     // 因为继承自父类，需要加上 override
     required override init() {
         // 这里是构造器的实现部分
     }
 }
 
 */

//如果类已经被标记为 final，那么不需要在协议构造器的实现中使用 required 修饰符
//因为 final 类不能有子类。关于 final 修饰符的更多内容

//协议作为类型
/*
作为函数、方法或构造器中的参数类型或返回值类型
作为常量、变量或属性的类型
作为数组、字典或其他容器中的元素类型
 */

//协议是一种类型，因此协议类型的名称应与其他类型（例如 Int，Double，String）的写法相同
//使用大写字母开头的驼峰式写法，例如（FullyNamed 和 RandomNumberGenerator）

protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}

/*

let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// 打印 “Here's a random number: 0.37464991998171”
print("And another one: \(generator.random())")
// 打印 “And another one: 0.729023776863283”

*/

class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

/**
 var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
 for _ in 1...5 {
     print("Random dice roll is \(d6.roll())")
 }
 // Random dice roll is 3
 // Random dice roll is 5
 // Random dice roll is 4
 // Random dice roll is 5
 // Random dice roll is 4

 */

protocol DiceGame {
    var dice: Dice { get }
    func play()
}
protocol DiceGameDelegate {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}

//实现了 DiceGame 和 DiceGameDelegate 协议
class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    //因为 DiceGameDelegate 协议是类专属的，可以将 delegate 声明为 weak，从而避免循环引用
    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}

//let tracker = DiceGameTracker()
//let game = SnakesAndLadders()
//game.delegate = tracker
//game.play()

//定义了 DiceGameTracker 类，它遵循了 DiceGameDelegate 协议

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

/*
 let tracker = DiceGameTracker()
 let game = SnakesAndLadders()
 game.delegate = tracker
 game.play()
 // Started a new game of Snakes and Ladders
 // The game is using a 6-sided dice
 // Rolled a 3
 // Rolled a 5
 // Rolled a 4
 // Rolled a 5
 // The game lasted for 4 turns
*/

//在扩展里添加协议遵循
//通过扩展令已有类型遵循并符合协议时，该类型的所有实例也会随之获得协议中定义的各项功能

protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}

extension SnakesAndLadders: TextRepresentable {
    var textualDescription: String {
        return "A game of Snakes and Ladders with \(finalSquare) squares"
    }
}
//print(game.textualDescription)

//有条件地遵循协议
extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}

//let myDice = [d6, d12]
//print(myDice.textualDescription)

//在扩展里声明采纳协议
struct Hamster {
    var name: String
       var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}
//即使满足了协议的所有要求，类型也不会自动遵循协议，必须显式地遵循协议。


//协议的继承

protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
    // 这里是协议的定义部分
}

protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}

extension SnakesAndLadders: PrettyTextRepresentable {
    var prettyTextualDescription: String {
        var output = textualDescription + ":\n"
        for index in 1...finalSquare {
            switch board[index] {
            case let ladder where ladder > 0:
                output += "▲ "
            case let snake where snake < 0:
                output += "▼ "
            default:
                output += "○ "
            }
        }
        return output
    }
}

//print(game.prettyTextualDescription)
// A game of Snakes and Ladders with 25 squares:
// ○ ○ ▲ ○ ○ ▲ ○ ○ ▲ ▲ ○ ○ ○ ▼ ○ ○ ○ ○ ▼ ○ ○ ▼ ○ ▼ ○


//类专属的协议
//你通过添加 AnyObject 关键字到协议的继承列表，就可以限制协议只能被类类型采纳（以及非结构体或者非枚举的类型）
//当协议定义的要求需要遵循协议的类型必须是引用语义而非值语义时，应该采用类类型专属协议

protocol SomeClassOnlyProtocol: AnyObject, InheritingProtocol {
    // 这里是类专属协议的定义部分
}


//协议合成

protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct PersonCombine: Named, Aged {
    var name: String
    var age: Int
}

//func wishHappyBirthday(to celebrator: Named & Aged) {
//    print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
//}
//let birthdayPerson = PersonCombine(name: "Malcolm", age: 21)
//wishHappyBirthday(to: birthdayPerson)
// 打印 “Happy birthday Malcolm - you're 21!”


class Location {
    var latitude: Double
    var longitude: Double
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
class City: Location, Named {
    var name: String
    init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        super.init(latitude: latitude, longitude: longitude)
    }
}
func beginConcert(in location: Location & Named) {
    print("Hello, \(location.name)!")
}

//let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
//beginConcert(in: seattle)
// 打印 "Hello, Seattle!"


//检查协议一致性

//is 用来检查实例是否遵循某个协议，若遵循则返回 true，否则返回 false；
//as? 返回一个可选值，当实例遵循某个协议时，返回类型为协议类型的可选值，否则返回 nil；
//as! 将实例强制向下转换到某个协议类型，如果强转失败，将触发运行时错误


//在协议中使用 optional 关键字作为前缀来定义可选要求。
//可选要求用在你需要和 Objective-C 打交道的代码中。
//协议和可选要求都必须带上 @objc 属性。
//标记 @objc 特性的协议只能被继承自 Objective-C 类的类或者 @objc 类遵循，其他类以及结构体和枚举均不能遵循这种协议。


//协议扩展

extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}

//提供默认实现
//可以通过协议扩展来为协议要求的方法、计算属性提供默认的实现。如果遵循协议的类型为这些要求提供了自己的实现，那么这些自定义实现将会替代扩展中的默认实现被使用。

//通过协议扩展为协议要求提供的默认实现和可选的协议要求不同。虽然在这两种情况下，遵循协议的类型都无需自己实现这些要求，但是通过扩展提供的默认实现可以直接调用，而无需使用可选链式调用

extension PrettyTextRepresentable  {
    var prettyTextualDescription: String {
        return textualDescription
    }
}

//为TextRepresentable协议提供默认实现
extension TextRepresentable {
    var textualDescription : String {
        return "textualDescription"
    }
}

//为协议扩展添加限制条件

extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}

//如果一个遵循的类型满足了为同一方法或属性提供实现的多个限制型扩展的要求， Swift 会使用最匹配限制的实现。


