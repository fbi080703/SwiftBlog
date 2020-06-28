//
//  SwiftClassDynamicExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/1.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

class SwiftClassDynamicExample {
    
    func dynamicTest() {
         let classIns = SwiftClass(110)
         let cls = objc_classes(of: object_getClass(classIns)!)
        //[SwiftBlog.SwiftClass, Swift._SwiftObject] 没有继承NSObject
        //[SwiftBlog.SwiftClass, NSObject] 继承NSObject
         print(cls)
        
         //let cl: AnyClass? = cls.last
         
         //print(objc_methods(of: cl!))
         // ["class", "isKindOfClass:", "release", "isEqual:", "self", "performSelector:", "performSelector:withObject:", "performSelector:withObject:withObject:", "isProxy", "isMemberOfClass:", "conformsToProtocol:", "respondsToSelector:", "retain", "autorelease", "retainCount", "zone", "hash", "superclass", "description", "debugDescription", "dealloc", "methodForSelector:", "doesNotRecognizeSelector:", "allowsWeakReference", "retainWeakReference", "isDeallocating", "tryRetain", "isNSArray", "isNSNumber", "isNSDictionary", "isNSSet", "isNSOrderedSet", "isNSString", "cfTypeID", "isNSValue", "isNSDate", "isNSData", "isNSObject", "copyDescription", "isNSCFConstantString", "isNSTimeZone"]

         //print(objc_properties(of: cl!))
         // ["hash", "superclass", "description", "debugDescription"]
         //print(objc_ivars(of: cl!))
         // ["isa", "refCounts"]
         //print(objc_protocols(of: cl!))
         // ["NSObject"]
         //print(objc_methods(of: object_getClass(classIns)!))
         
         //print(cl!)
         
         // print((classIns as AnyObject).perform?(NSSelectorFromString("class")) as Any)
         // print((classIns as AnyObject).perform?(NSSelectorFromString("echo:"), with: 110)) // Error.
        
        print((classIns as AnyObject).perform?(NSSelectorFromString("dynamicEcho:"), with: 10) as Any)
        //SwiftClass Extension
        print((classIns as AnyObject).perform?(NSSelectorFromString("echoExtension:"), with: 10) as Any)
         
         //let swiftObjectClass = objc_getClass("SwiftObject".withCString { $0 })
         //print(swiftObjectClass as Any)
         
         let structVal = SwiftStruct(val: 110)
         let stdIntVal = 110
         let stdBoolVal = false
         let stdArrVals = ["1", "2", "3"]
         let stdDicVals = ["1": 1, "2": 2]
         let stdSetVals: Set<Int> = [1, 2, 3]
         
         print(objc_classes(of: object_getClass(structVal)!))
         // [_SwiftValue, NSObject]
         print(objc_methods(of: object_getClass(structVal)!))
         // ["isEqual:", "hash", "description", "debugDescription", "dealloc", "copyWithZone:", "swiftTypeMetadata", "swiftTypeName", "_swiftValue"]
         print(objc_classes(of: object_getClass(SwiftEnum.a)!))
         print(objc_classes(of: object_getClass(stdIntVal)!))
         // [__NSCFNumber, NSNumber, NSValue, NSObject]
         print(objc_classes(of: object_getClass(stdBoolVal)!))
         // [__NSCFBoolean, NSNumber, NSValue, NSObject]
         print(objc_classes(of: object_getClass(stdArrVals)!))
         // [Swift.SwiftDeferredNSArray, Swift.SwiftNativeNSArrayWithContiguousStorage, Swift._SwiftNativeNSArray, _SwiftNativeNSArrayBase, NSArray, NSObject]
         print(objc_classes(of: object_getClass(stdDicVals)!))
         // [Swift.SwiftDeferredNSDictionary<Swift.String, Swift.Int>, Swift.SwiftNativeNSDictionary, _SwiftNativeNSDictionaryBase, NSDictionary, NSObject]
         print(objc_classes(of: object_getClass(stdSetVals)!))
         // [Swift.SwiftDeferredNSSet<Swift.Int>, Swift.SwiftNativeNSSet, _SwiftNativeNSSetBase, NSSet, NSObject]
    }
    
    func objc_classes(of cls: AnyClass) -> [AnyClass] {
        var clss: [AnyClass] = []
        var cls: AnyClass? = cls
        while let _cls = cls {
            clss.append(_cls)
            cls = class_getSuperclass(_cls)
        }
        return clss
    }
    
    public func objc_methods(of cls: AnyClass) -> [String] {
        var count: UInt32 = 0
        let methodList = class_copyMethodList(cls,&count)

        return (0..<count).compactMap { idx in
            methodList.map { method_getName($0.advanced(by: Int(idx)).pointee).description }
        }
    }

    public func objc_properties(of cls: AnyClass) -> [String] {
        var count: UInt32 = 0
        let propertyList = class_copyPropertyList(cls,&count)

        return (0..<count).compactMap { idx in
            propertyList.map { String(cString: property_getName($0.advanced(by: Int(idx)).pointee)) }
        }
    }

    public func objc_ivars(of cls: AnyClass) -> [String] {
        var count: UInt32 = 0
        let ivarList = class_copyIvarList(cls,&count)

        return (0..<count).compactMap { idx in
            ivarList.flatMap { ivar_getName($0.advanced(by: Int(idx)).pointee).map({ String(cString: $0) }) }
        }
    }

    public func objc_protocols(of cls: AnyClass) -> [String] {
        var count: UInt32 = 0
        let protocolList = class_copyProtocolList(cls,&count)

        return (0..<count).compactMap { idx in
            String(cString: protocol_getName(protocolList![Int(idx)]))
        }
    }
}
