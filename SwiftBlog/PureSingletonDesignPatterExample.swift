//
//  PureSingletonDesignPatterExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/2.
//  Copyright © 2020 Patrick Balestra. All rights reserved.
//

import Foundation

final class LogManager {
     //shared and only one available object
      static let logger: LogManager = LogManager(databaseURLEndpoint: "https://www.hitendrasolanki.com/logger/live")
      
      private var databaseURLEndpoint: String
      
      //marked as private, no one is allowed to access this initialiser outside of the class
      private init(databaseURLEndpoint: String) {
        self.databaseURLEndpoint = databaseURLEndpoint
      }
        
      func log(_ value: String...){
        //complex code to connect to the databaseURLEndpoint and send the value to server directly
      }
}

/**
 In this pattern, a programmer who is using the functionality of a pure-singleton class is not allowed to create an instance of the class. A programmer can only call methods and access properties available for the singleton class by using the predefined instance of that class.
 
 The object of a pure-singleton class is automatically created during application launch with pre-defined parameters mentioned by the developer who created that class.
 
 Pure-singleton classes must be marked as final to avoid inheritance confusion. In swift, you can use structure also to achieve the same concept.
 
 A programmer cannot inherit the pure-singleton class. When you try to inherit any class in swift, you must call the constructor of the superclass. Calling the constructor of the superclass is not possible in pure-singleton class because all constructors of the pure-singleton class are always marked as private.
 
 */
/**
 不允许自己创建实例，不允许继承
 
 Swift中的final修饰符
 Swift中的final修饰符可以防止类（class）被继承，还可以防止子类重写父类的属性、方法以及下标。需要注意的是，final修饰符只能用于类，不能修饰结构体（struct）和枚举（enum），因为结构体和枚举只能遵循协议（protocol）。虽然协议也可以遵循其他协议，但是它并不能重写遵循的协议的任何成员，这就是结构体和枚举不需要final修饰的原因。

 final修饰符的几点使用原则
 final修饰符只能修饰类，表明该类不能被其他类继承，也就是它没资格当父类。
 final修饰符也可以修饰类中的属性、方法和下标，但前提是该类并没有被final修饰过。
 final不能修饰结构体和枚举
 
 https://swifter.tips/final/
 
 */
