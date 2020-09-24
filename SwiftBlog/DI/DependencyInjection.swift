//
//  DependencyInjection.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/9/17.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation
import Swinject

//https://yoichitgy.github.io/
//https://www.youtube.com/watch?v=h6iikGy7dk0
//https://github.com/Swinject/Swinject

protocol APIClientProtocol {
    //
    var fullName: String { get }
}

protocol LoggerProtocol {
    //
    func random() -> Double
}

class Logger: LoggerProtocol {
    func random() -> Double {
        200.0
    }
}

class APIClient: APIClientProtocol {
    var fullName: String {
        return "APIClient"
    }
    
    //
}

class MyViewModel {
    //Example 1
    let apiClient: APIClientProtocol
    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
        
        //忽略
        self.id = ""
        (apiClientDi, logger) = (APIClient(), Logger())
    }
    
    //Example 2
    typealias Dependency = (APIClientProtocol, LoggerProtocol)
    let (apiClientDi, logger) : Dependency
    let id: String
    
    init(dependency: Dependency, id: String) {
        (apiClientDi, logger) = dependency
        self.id = id
        
        //忽略
        self.apiClient = APIClient()
    }
    
}
//apiClient abstract type APIClientProtocol => APIClient Inject concrete type
let vm = MyViewModel(apiClient: APIClient())

//Error : Expressions are not allowed at the top level
//https://blog.csdn.net/weichuang_1/article/details/50516147
/*
 Swift中，直接在类的外面调用类内部的方法，会出现Bug：Expressions are not allowed at the top level。
 
 原因是：
 在App工程里， .swift文件都是编译成模块的，不能有top level code。
 
 先明确一个概念，一个.swift文件执行是从它的第一条非声明语句（表达式、控制结构）开始的，同时包括声明中的赋值部分，所有这些语句，构成了该.swift文件的top_level_code()函数。而所有的声明，包括结构体、类、枚举及其方法，都不属于 top_level_code()代码部分，其中的代码逻辑，包含在其他区域，top_level_code()可以直接调用他们。程序的入口是隐含的一个 main(argc, argv)函数，该函数执行逻辑是设置全局变量C_ARGC C_ARGV，然后调用 top_level_code()。不是所有的 .swift 文件都可以作为模块，目前看，任何包含表达式语句和控制语句的 .swift 文件都不可以作为模块。正常情况下模块可以包含全局变量(var)、全局常量(let)、结构体(struct)、类(class)、枚举(enum)、协议(protocol)、扩展(extension)、函数(func)、以及全局属性(var { get set })。这里的全局，指的是定义在 top level 。这里说的表达式指expression，语句指 statement ，声明指declaration 。因此，如果代码中直接在类的外面调用类内部的方法，则该.swift 文件是编译不成的模块的，所以会编译报错
 */
//let container = Swinject.Container()
//container.register(APIClientProtocol.self) { _ in
//    APIClient()
//}

//https://github.com/Swinject/Swinject/blob/master/Documentation/DIContainer.md

class DIContainer {
    static func example() {
        //获取容器
        let container = Swinject.Container()
        //注册APIClientProtocol
        _ = container.register(APIClientProtocol.self) { _ in
            APIClient()
        }
        //注册具体的实现
        container.register(MyViewModel.self) { resolver in
            let apiClient = resolver.resolve(APIClientProtocol.self)!
            return MyViewModel(apiClient: apiClient)
        }
        //使用
        let djVm = container.resolve(MyViewModel.self)!
        print(djVm.apiClient.fullName)
        
        //注册LoggerProtocol
        container.register(LoggerProtocol.self) { _ in
            Logger()
        }
        
        container.register(MyViewModel.self) { (resolver, id: String) in
            let dependency = (resolver.resolve(APIClientProtocol.self)!,
                              resolver.resolve(LoggerProtocol.self)!
            )
            return MyViewModel(dependency: dependency, id: id)
        }
        
        //使用
        let myViewModel = container.resolve(MyViewModel.self,argument: "test")
        print(myViewModel!.id as String)
        
        
        
        //MARK: Registration in a DI Container
        
        container.register(PersonDI.self) { r in
            PetOwner(name: "Stephen", pet: r.resolve(AnimalDI.self)!)
        }
        container.register(AnimalDI.self) { _ in CatDI(name: "Mimi") }
        
        let animal = container.resolve(AnimalDI.self)!
        let person = container.resolve(PersonDI.self)!
        let pet = (person as! PetOwner).pet
        
        print(animal.name) // prints "Mimi"
        print(animal is Cat) // prints "true"
        print(person.name) // prints "Stephen"
        print(person is PetOwner) // prints "true"
        print(pet.name) // prints "Mimi"
        print(pet is Cat) // prints "true"
        
        //MARK: Named Registration in a DI Container
        
        container.register(AnimalDI.self, name: "cat") { _ in CatDI(name: "Mimi") }
        container.register(AnimalDI.self, name: "dog") { _ in DogDI(name: "Hachi") }
        
        let catNamed = container.resolve(AnimalDI.self, name:"cat")!
        let dogNamed = container.resolve(AnimalDI.self, name:"dog")!

        print(catNamed.name) // prints "Mimi"
        print(catNamed is CatDI) // prints "true"
        print(dogNamed.name) // prints "Hachi"
        print(dogNamed is DogDI) // prints "true"
        
        //MARK: Registration with Arguments in a DI Container
        
        container.register(AnimalDI.self) { _, name in
            Horse(name: name)
        }
        container.register(AnimalDI.self) { _, name, running in
            Horse(name: name, running: running)
        }
        
        //传递一个参数
        let animal1 = container.resolve(AnimalDI.self, argument: "Spirit")!

        print(animal1.name) // prints "Spirit"
        print((animal1 as! Horse).running) // prints "false"
        //传递两个参数
        let animal2 = container.resolve(AnimalDI.self, arguments: "Lucky", true)!

        print(animal2.name) // prints "Lucky"
        print((animal2 as! Horse).running) // prints "true"
    }
}



protocol AnimalDI {
    var name: String { get }
}
protocol PersonDI {
    var name: String { get }
}

class CatDI: AnimalDI {
    let name: String
    
    init() {
        self.name = ""
    }
    
    init(name: String) {
        self.name = name
    }
    
    func sound() -> String {
        return "Meow"
    }
}

class PetOwner: PersonDI {
    let name: String
    let pet: AnimalDI
    
    convenience init(pet: AnimalDI) {
        self.init(name: "", pet: pet)
    }
    
    init(name: String, pet: AnimalDI) {
        self.name = name
        self.pet = pet
    }
}

class DogDI: AnimalDI {
    let name: String
    
    init(name : String) {
        self.name = name
    }
    
}

class Horse: AnimalDI {
    let name: String
    let running: Bool

    convenience init(name: String) {
        self.init(name: name, running: false)
    }

    init(name: String, running: Bool) {
        self.name = name
        self.running = running
    }
}
