//
//  SemiSingletonDesignPatterExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/2.
//  Copyright © 2020 Patrick Balestra. All rights reserved.
//

import Foundation

//In semi-singleton design pattern, marking the class as final is optional
final class SemiSingletonLogManager {
      //shared object
      static let logger: SemiSingletonLogManager = SemiSingletonLogManager(databaseURLEndpoint: "https://www.hitendrasolanki.com/logger/live")
      
      private var databaseURLEndpoint: String
      
      //not marked as private, anyone is allowed to access this initialiser outside of the class
      init(databaseURLEndpoint: String) {
        self.databaseURLEndpoint = databaseURLEndpoint
      }
      
      func log(_ value: String...){
        //complex code to connect to the databaseURLEndpoint and send the value to server directly
     }
}

/**
 init 没有设置private，可以继承
 
 使用
 1、第一种方式
 
 SemiSingletonLogManager.logger.log("main log from medium blog on live server endpoint") //this will log on "/live" endpoint
 
 2、第二种方式
 
 //we are allowed to create an instace of class LogManager,
 //because it follows the Semi-Singleton design patterns
 
 let logManagerTestObject = SemiSingletonLogManager(databaseURLEndpoint: "https://www.hitendrasolanki.com/logger/test")
 logManagerTestObject.log("test log from medium blog on test server endpoint") //this will log on "/test" endpoint
 
 */
