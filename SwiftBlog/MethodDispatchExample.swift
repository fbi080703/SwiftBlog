//
//  MethodDispatchExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/7/12.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation
//https://www.rightpoint.com/rplabs/switch-method-dispatch-table

class MethodDispatchExample {
    
    //var dddd : SomeEnumeration  = .small {
    //    didSet {
    //        dddd = .large
    //    }
    //}
    func example() {
        let myStruct = MyStruct()
        let proto: MyProtocol = myStruct

        myStruct.extensionMethod() // -> “In Struct”
        proto.extensionMethod() // -> “In Protocol”
        
        //print(Base().directProperty)
        //print(Sub().directProperty)
        //
        //print(Base().indirectProperty)
        //print(Sub().indirectProperty)
        //
        //Base().test()
        //Sub().test()
        
        let classIns = Base()
        _ = (classIns as AnyObject).perform?(NSSelectorFromString("test"))
        //_ = (classIns as AnyObject).perform?(NSSelectorFromString("baseTest"))
        //
        //let subClassIns = Sub()
        //_ = (subClassIns as AnyObject).perform?(NSSelectorFromString("test"))
        
        /**Protocol中的函数派发方式，在Swift Protocol中，
         如果该方法在定义中有声明，则采用动态派发，
         如果在定义中未声明该方法，则默认使用静态派发的方式*/
        let triangle1: Drawable = Triangle()
        let triangle2: Triangle = Triangle()
        let triangles: [Drawable] = [triangle1, triangle2]

        triangle1.draw() // *Triangle() Drawing triangle*
        triangle1.commit() // *Triangle() Commit something*
        triangle2.draw() // *Triangle() Drawing triangle*
        triangle2.commit() // *Triangle() Commit triangle*
        triangles.forEach {
            $0.draw();
            $0.commit()
        }
    }
}


protocol MyProtocol {
    //If the declaration for extensionMethod is moved into the protocol declaration, table dispatch is used, and results in the struct’s implementation being invoked.
    //func extensionMethod()
}
struct MyStruct: MyProtocol {
}
extension MyStruct {
    func extensionMethod() { //static / direct dispatch
        print("In Struct")
    }
}
extension MyProtocol {
    func extensionMethod() { //static / direct dispatch
        print("In Protocol")
    }
}

class MyClass {
    func mainMethod() {
        print("mainMethod")
    }
}
extension MyClass {
    func extensionMethod() {
        print("extensionMethod")
    }
}


//主体方法加上 @objc dynamic 子类的extension 可以重写
//父类的extension中的方法加 @objc 子类的主体可以重写

//
class Base : NSObject {
    //Overriding non-@objc declarations from extensions is not supported
    //Cannot override a non-dynamic class declaration from an extension
    //@objc dynamic
    @objc dynamic var directProperty:String { return "This is Base" }
    var indirectProperty:String { return directProperty }
    
    //Overriding non-@objc declarations from extensions is not supported
    //Cannot override a non-dynamic class declaration from an extension
    //@objc dynamic
    @objc dynamic public func test() {
        print("Base--test")
    }
    func mainMethod() {}
}

extension Base {
    //public func baseTest() {
    //    print("Base-baseTest")
    //}
    @objc dynamic func extensionMethod() {}
}

class Sub:Base {

}

extension Sub {
    //@objc dynamic 对应的属性需要加上
    override var directProperty: String {
        return "This is Sub"
    }
    //NSObject的extension是使用的Message dispatch，而Initial Declaration使用的是Table dispathextension重载的方法添加在了Message dispatch内，没有修改虚函数表，虚函数表内还是父类的方法，故会执行父类方法。
    //想在extension重载方法，需要在父类标明dynamic来使用Message dispatch
    override func test() {
        print("Sub--test")
    }
    
    override func extensionMethod() {
        print("Sub--extensionMethod")
    }
}


protocol Drawable {
    func draw()
}

extension Drawable {
    func draw() {
        print("\(self) Drawing something")
    }

    func commit() {
        print("\(self) Commit something")
    }
}

struct Triangle: Drawable {
    func draw() {
        print("\(self) Drawing triangle")
    }

    func commit() {
        print("\(self) Commit triangle")
    }
}
