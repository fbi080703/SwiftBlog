//
//    Runtime.swift
//    Swift Runtime [Swift 4]
//
//    The MIT License (MIT)
//
//    Copyright (c) 2016 Electricwoods LLC, Kaz Yoshikawa.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//    WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
//
//    Usage:
//
//        (find classes conform to objc protocol)
//        @objc protocol ThatProtocol {}
//        class ThatClass1: NSObject, ThatProtocol {}
//        Runtime.classes(conformToProtocol: ThatProtocol.Type.self) // [ThatClass1]
//
//        (find classes conform to swift protocol)
//        protocol ThisProtocol {}
//        class ThisClass1: ThisProtool {}
//        class ThisClass2: ThisClass1 {}
//        struct ThisStruct: ThisProtocol {}
//        Runtime.classes(conformTo: ThisProtocol.Type.self) // [ThisClass1, ThisClass2]
//
//        (find subclasses of a specified class)
//        class HerClass1 {}
//        class HerClass2: HerClass1 {}
//        class HerClass3: HerClass2 {}
//        Runtime.subclasses(of: HerClass1.self) // [HerClass1, HerClass2, HerClass3]
//        Runtime.subclasses(of: HerClass2.self) // [HerClass2, HerClass3]
//        Runtime.subclasses(of: HerClass3.self) // [HerClass3]
//
//    Caution:
//        You may not be able to use `as?` operator to filter AnyClass from `allClasses()`.
//        Because there are some classes such as `CNZombie` which causees crash with `as?`
//        operator.
//
//            for type in Runtime.allClasses() {
//                if let type = type as? NSView.self {  // could cause crash
//                }
//            }
//
import Foundation

class Runtime {
    
    public static func allClasses() -> [AnyClass] {
        let numberOfClasses = Int(objc_getClassList(nil, 0))
        if numberOfClasses > 0 {
            let classesPtr = UnsafeMutablePointer<AnyClass>.allocate(capacity: numberOfClasses)
            let autoreleasingClasses = AutoreleasingUnsafeMutablePointer<AnyClass>(classesPtr)
            let count = objc_getClassList(autoreleasingClasses, Int32(numberOfClasses))
            assert(numberOfClasses == count)
            defer { classesPtr.deallocate() }
            let classes = (0 ..< numberOfClasses).map { classesPtr[$0] }
            return classes
        }
        return []
    }

    public static func subclasses(of `class`: AnyClass) -> [AnyClass] {
        return self.allClasses().filter {
            var ancestor: AnyClass? = $0
            while let type = ancestor {
                if ObjectIdentifier(type) == ObjectIdentifier(`class`) { return true }
                ancestor = class_getSuperclass(type)
            }
            return false
        }
    }

    public static func classes(conformToProtocol `protocol`: Protocol) -> [AnyClass] {
        let classes = self.allClasses().filter { aClass in
            var subject: AnyClass? = aClass
            while let aClass = subject {
                if class_conformsToProtocol(aClass, `protocol`) { print(String(describing: aClass)); return true }
                subject = class_getSuperclass(aClass)
            }
            return false
        }
        return classes
    }

    public static func classes<T>(conformTo: T.Type) -> [AnyClass] {
        return self.allClasses().filter { $0 is T }
    }
}


/****
 I am trying to implement the multicast delegate functionality in Swift. In Objective C, we have this excellent implementation
 https://github.com/robbiehanson/XMPPFramework/blob/master/Utilities/GCDMulticastDelegate.m
 And I have just created this basic functionality:
 protocol MyProtocol : class{
 func testString()-> String;
 }
 class MulticastDelegateNode <T:AnyObject> {
 weak var delegate : T?
 init(object : T){
 self.delegate = object;
 }
 }
 class MulticastDelegate <T:AnyObject> {
 var delegates = Array<MulticastDelegateNode<T>>()
 func addDelegate(delegate : T){
 var newNode = MulticastDelegateNode(object : delegate);
 delegates.append(newNode);
 }
 func removeDelegate(delegate : AnyObject){
 self.delegates = self.delegates.filter({ (node : MulticastDelegateNode) -> Bool in
 return node.delegate !== delegate;
 });
 }
 }
 class OP {
 var delegate = MulticastDelegate<MyProtocol>();
 func process(){
 //...
 //make actions
 //notify the objects!
 }
 }
 My problem is that it seems I cannot figure out a way to do this:
 delegate.testString()
 In order to give the command 'testString()' to all delegates that are in the nodes. Can anyone help me with this?
 Swift 3 implementation:
 class MulticastDelegate<T> {
 private var delegates = [Weak]()
 func add(_ delegate: T) {
 if Mirror(reflecting: delegate).subjectType is AnyClass {
 delegates.append(Weak(value: delegate as AnyObject))
 } else {
 fatalError("MulticastDelegate does not support value types")
 }
 }
 func remove(_ delegate: T) {
 if type(of: delegate).self is AnyClass {
 delegates.remove(Weak(value: delegate as AnyObject))
 }
 }
 func invoke(_ invocation: (T) -> ()) {
 for (index, delegate) in delegates.enumerated() {
 if let delegate = delegate.value {
 invocation(delegate as! T)
 } else {
 delegates.remove(at: index)
 }
 }
 }
 }
 private class Weak: Equatable {
 weak var value: AnyObject?
 init(value: AnyObject) {
 self.value = value
 }
 }
 private func ==(lhs: Weak, rhs: Weak) -> Bool {
 return lhs.value === rhs.value
 }
 extension RangeReplaceableCollection where Iterator.Element : Equatable {
 #discardableResult
 mutating func remove(_ element : Iterator.Element) -> Iterator.Element? {
 if let index = self.index(of: element) {
 return self.remove(at: index)
 }
 return nil
 }
 }
 You can test it with:
 protocol SomeDelegate: class {
 func onSomeEvent()
 }
 class SomeDelegateImpl: SomeDelegate {
 let value: Int
 init(value: Int) {
 self.value = value
 }
 func onSomeEvent() {
 print("Invoking delegate \(value)")
 }
 }
 let multicastDelegate = MulticastDelegate<SomeDelegate>()
 func testInvoke() {
 multicastDelegate.invoke {
 $0.onSomeEvent()
 }
 }
 print("Adding first delegate.")
 let delegate1 = SomeDelegateImpl(value: 1)
 multicastDelegate.add(delegate1)
 testInvoke()
 let delegate2 = SomeDelegateImpl(value: 2)
 print("Adding second delegate.")
 multicastDelegate.add(delegate2)
 testInvoke()
 print("Removing first delegate.")
 multicastDelegate.remove(delegate1)
 testInvoke()
 print("Adding third delegate.")
 ({
 let delegate3 = SomeDelegateImpl(value: 3)
 multicastDelegate.add(delegate3)
 testInvoke()
 })()
 print("Third delegate is deallocated by ARC.")
 testInvoke()
 It prints:
 Adding first delegate.
 Invoking delegate 1.
 Adding second delegate.
 Invoking delegate 1.
 Invoking delegate 2.
 Removing first delegate.
 Invoking delegate 2.
 Adding third delegate.
 Invoking delegate 2.
 Invoking delegate 3.
 Third delegate is deallocated by ARC.
 Invoking delegate 2.
 Based on this blog post.
 A Simple demo about MulticastDelegate.
 class DelegateMulticast <T> {
 private var delegates = [T]()
 func addDelegate(delegate: T) {
 delegates.append(delegate)
 }
 func invokeDelegates(invocation: (T) -> ()) {
 for delegate in delegates {
 invocation(delegate)
 }
 }
 }
 protocol MyProtocol {
 func testString() -> String
 }
 class OP {
 var delegates = DelegateMulticast<MyProtocol>()
 func process(){
 delegates.invokeDelegates{
 $0.testString()
 }
 }
 }
 Here is my implementation of multicast delegate using Swift 2.0 protocol extensions. Also i've added ability to remove delegates. To do so I've made my delegate type conform to NSObjectProtocol, didn't get how to declare that it should be reference type to use === operator for remove.
 protocol MulticastDelegateContainer {
 typealias DelegateType : NSObjectProtocol
 var multicastDelegate : [DelegateType] {set get}
 }
 extension MulticastDelegateContainer {
 mutating func addDelegate(delegate : DelegateType) {
 multicastDelegate.append(delegate)
 }
 mutating func removeDelegate(delegate : DelegateType) {
 guard let indexToRemove = self.multicastDelegate.indexOf({(item : DelegateType) -> Bool in
 return item === delegate
 }) else {return}
 multicastDelegate.removeAtIndex(indexToRemove)
 }
 func invokeDelegate(invocation: (DelegateType) -> ()) {
 for delegate in multicastDelegate {
 invocation(delegate)
 }
 }
 }
 and here is example of usage
 #objc protocol MyProtocol : NSObjectProtocol {
 func method()
 }
 class MyClass : MulticastDelegateContainer {
 typealias DelegateType = MyProtocol
 var multicastDelegate = [MyProtocol]()
 func testDelegates() {
 invokeDelegate { $0.method() }
 }
 }
 Ok. In some of the solutions I see mistakes (strong retain cycles, race conditions, ...)
 Here is what I combine based on 1 day research. For the stack of delegates I used NSHashTable, so all the delegates are having weak reference.
 Swift 3.1
 class MulticastDelegate <T> {
 private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()
 func add(delegate: T) {
 delegates.add(delegate as AnyObject)
 }
 func remove(delegate: T) {
 for oneDelegate in delegates.allObjects.reversed() {
 if oneDelegate === delegate as AnyObject {
 delegates.remove(oneDelegate)
 }
 }
 }
 func invoke(invocation: (T) -> ()) {
 for delegate in delegates.allObjects.reversed() {
 invocation(delegate as! T)
 }
 }
 }
 func += <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
 left.add(delegate: right)
 }
 func -= <T: AnyObject> (left: MulticastDelegate<T>, right: T) {
 left.remove(delegate: right)
 }
 How to set delegate:
 object.delegates.add(delegate: self)
 How to execute function on the delegates:
 instead of
 delegate?.delegateFunction
 you use
 delegates.invoke(invocation: { $0.delegateFunction })
 I've added my implementation of a Swift multicast delegate on GitHub: https://github.com/tumtumtum/SwiftMulticastDelegate
 Basically you use the overloaded operator "=>" with a block to perform the invocation. Internally the MulticastDelegate will call that block for every listener.
 class Button
 {
 var delegate: MulticastDelegate<ButtonDelegate>?
 func onClick()
 {
 self.delegate => { $0.clicked(self) }
 }
 }
 You might be able to add
 #objc
 To your protocol & classes, of course then you are no longer doing pure swift ... but that might solve your issue as it will re-enable dynamic dispatch powers.
 
 */
