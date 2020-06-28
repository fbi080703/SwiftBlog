//
//  SwiftNewFeatures.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/2.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

class NetworkManager {
    class var maximumActiveRequests: Int {
        return 4
    }

    func printDebugData() {
         // NetworkManager override can not work
        //print("Maximum network requests: \(NetworkManager.maximumActiveRequests).")
        // Self override can work
        print("Maximum network requests: \(Self.maximumActiveRequests).")
    }
    
    // 单行可以省略 return 关键字
    func double(_ number: Int) -> Int {
        // return number * 2
        number * 2
    }
}

//全局的 Self
class ThrottledNetworkManager: NetworkManager {
    override class var maximumActiveRequests: Int {
        return 1
    }
}

public enum OldSettings {
    private static var values = [String: String]()

    static func get(_ name: String) -> String? {
        return values[name]
    }

    static func set(_ name: String, to newValue: String?) {
        print("Adjusting \(name) to \(newValue ?? "nil")")
        values[name] = newValue
    }
}

//OldSettings.set("Captain", to: "Gary")
//OldSettings.set("Friend", to: "Mooncake")
//print(OldSettings.get("Captain") ?? "Unknown")


public enum NewSettings {
    private static var values = [String: String]()

    public static subscript(_ name: String) -> String? {
        get {
            return values[name]
        }
        set {
            print("Adjusting \(name) to \(newValue ?? "nil")")
            values[name] = newValue
        }
    }
}

//NewSettings["Captain"] = "Gary"
//NewSettings["Friend"] = "Mooncake"
//print(NewSettings["Captain"] ?? "Unknown")

//静态或类可以变成下标


@frozen
public struct Point {
  public var x: Double
  private var y: Double
  //ThrottledNetworkManager need set public
  //var logger: ThrottledNetworkManager
  public init(_ x: Double, _ y: Double) {
    self.x = x
    self.y = y
    //self.logger = ThrottledNetworkManager()
  }
}

public struct NewPoint {
  public var x: Double
  private var y: Double
  //ThrottledNetworkManager need set public
  //var logger: ThrottledNetworkManager
  public init(_ x: Double, _ y: Double) {
    self.x = x
    self.y = y
    //self.logger = ThrottledNetworkManager()
  }
}

/**
 {
     willSet(newTotalSteps) {
         print("将 totalSteps 的值设置为 \(newTotalSteps)")
     }
     didSet {
       if y > oldValue  {
             print("增加了 \(y - oldValue) 步")
         }
     }
 }
 
 */
