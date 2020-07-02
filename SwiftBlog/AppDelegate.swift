//
//  AppDelegate.swift
//  SwiftBlog
//
//  Created by Wulongwang on 04/09/14.
//  Copyright (c) 2014 Wulongwang. All rights reserved.
//

import UIKit
import AppleArchive

import os

struct Mountain {
    let uuid: UUID
    var name: String
    var height: Float
}

//@UIApplicationMain
@available(iOS 14.0, *)
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?
    
    let name: String = "AppDelegate"
    lazy var printName = {
        [weak self] in
        if let strongSelf = self {
            print("The name is \(strongSelf.name)")
        }
    }
    
    var gcd: SwiftGrandCentralDispatchExample?
    
    //
    let logger = Logger(subsystem: "com.example.Fruta", category: "giftcards")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        printName()
        logger.log("com.example.Fruta")
        
        var m1 = Mountain(uuid: UUID.init(), name: "", height: 30)
        var m2 = m1
        print(NSString(format: "%p", addressOf(&m1)))
        print(NSString(format: "%p", addressOf(&m2)))
        //print(NSString(format: "%p", addressOf(&m1.name)))
        //print(NSString(format: "%p", addressOf(&m2.name)))
        //print(NSString(format: "%p", addressOf(&m1.height)))
        //print(NSString(format: "%p", addressOf(&m2.height)))
        
        // builderExample()
        // SwiftClassDynamicExample().dynamicTest()
        
        // let throttledNetworkManager = ThrottledNetworkManager()
        // throttledNetworkManager.printDebugData()
        
        do {
            let tips = SwiftTipsExample.init()
            //SwiftTipsExample.Type // typealias AnyClass = AnyObject.Type
            //通过 AnyObject.Type 这种方式所得到是一个元类型 (Meta)
            try tips.example()
        } catch {
        }
        
        //let x = "Started a task"
        //logger.debug("An unsigned integer \(x, privacy: .public)")
        //logger.log("Started a task")
        
        let gcdExample = SwiftGrandCentralDispatchExample()
        gcdExample.grandCentralDispatchTest()
        
        //var stepCounter = Point(500, 4434)
        //stepCounter.y = 54333
        
       //let example =  ClosureExample.init()
       //example.takesAClosure()
       //example.captureValue()
        
        /**
         将 totalSteps 的值设置为 200
         增加了 200 步
         将 totalSteps 的值设置为 360
         增加了 160 步
         将 totalSteps 的值设置为 896
         增加了 536 步
         */
        //let stepCounter = StepCounter()
        //stepCounter.totalSteps = 200
        
//        stepCounter.totalSteps = 360
//        stepCounter.totalSteps = 896
        
        
//        var rectangle = SmallRectangle()
//        print(rectangle.height)
//        rectangle.height = 10
//        print(rectangle.height)
//        rectangle.height = 24
//        print(rectangle.height)
        
        //var zeroRectangle = ZeroRectangle()
        //print(zeroRectangle.height, zeroRectangle.width)
        
        //let mm = Planet.earth
        
        //let mars = Planet[5]
        //print(mars)
        
       /*let train = Train.init()
       train.defaultType = "dfddfd"
       print(train.defaultType)*/
        
        //Point(x: 2.0, y: 2.0)
        //let r = Rect.init(origin: ExtensionPoint(x: 0.0, y: 0.0), size: ExtensionSize(width: 5.0, height: 60.0))
        
//         var example = PersonExample(fullName: "PersonExample")
//        example.fullName = "ExtensionPoint"
//        print(example.fullName)
        
//        let tracker = DiceGameTracker()
//        let game = SnakesAndLadders()
//        game.delegate = tracker
//        game.play()
        
        //var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
        //print(paragraph?.asHTML())
        
        /*内存安全*/
        
        //var oscar = Player(name: "Oscar", health: 10, energy: 10)
        //var maria = Player(name: "Maria", health: 5, energy: 10)
        //oscar.shareHealth(with: &maria)  // 正常
        
        //Inout arguments are not allowed to alias each other
        //Overlapping accesses to 'oscar', but modification requires exclusive access; consider copying to a local variable
        //oscar.shareHealth(with: &oscar) //内存访问冲突
        /*内存安全*/
        
//        let font = UIFont.systemFont(ofSize: 10.0)
//        var label1 = Label(text:"Hi", font:font)  //栈区包含了存储在堆区的指针
//        var label2 = label1 //label2产生新的指针，和label1一样指向同样的string和font地址
        //label2.text = "swift"
        
        //let another = UIFont.systemFont(ofSize: 12.0)
        //label2.font = another
        //label2.font = UIFont.systemFont(ofSize: 12.0)
        
//        print(Base().directProperty)
//        print(Sub().directProperty)
//
//        print(Base().indirectProperty)
//        print(Sub().indirectProperty)
        
        //Base().test()
        //Sub().test()
        
        
//        let obj = ChildClass()
//        obj.method2()
        
        let myStruct = MyStruct()
        let proto: MyProtocol = myStruct

        myStruct.extensionMethod() // -> “In Struct”
        proto.extensionMethod() // -> “In Protocol”
        
        
        //let classIns = Base()
        //(classIns as AnyObject).perform?(NSSelectorFromString("test"))
        //
        //let subClassIns = Sub()
        //(subClassIns as AnyObject).perform?(NSSelectorFromString("test"))
        
        //var sub:LoudPerson = LoudPerson()
        //sub.sayHi()  //sub
        
        //协议的扩展内实现的方法，无法被遵守类的子类重载
        //var sub:ParentPerson = LoudPerson()
        //sub.sayHi() //hello
        
        //let subClass : MyClass = SubClass()
        //subClass.extensionMethod()
        
        print(B().a())  // 0
        print(C().a()) // 1
        print((C() as A).a()) // 0 # We thought return 1.

        // Success cases.
        print(D().a()) // 1
        print((D() as A).a()) // 1
        print(E().a()) // 2
        print((E() as A).a()) // 2
        
        #if swift(>=5.2)
           print("Running Swift 5.0 or later")
        #else
           print("Running old Swift")
        #endif
        return true
    }
    
    /// 获取内存地址
    /// http://stackoverflow.com/a/36539213/226791
    ///https://stackoverflow.com/questions/37401959/how-can-i-get-the-memory-address-of-a-value-type-or-a-custom-struct-in-swift
    /// Example:
    ///
    /// //struct
    /// var struct1 = myStruct(a: 5)
    //var struct2 = struct1
    //print(NSString(format: "%p", address(&struct1))) // -> "0x10f1fd430\n"
    //print(NSString(format: "%p", address(&struct2))) // -> "0x10f1fd438\n"
    //
    ////String
    //var s = "A String"
    //var aa = s
    //print(NSString(format: "%p", address(&s))) // -> "0x10f43a430\n"
    //print(NSString(format: "%p", address(&aa))) // -> "0x10f43a448\n"
    //
    ////Class
    //var class1 = myClas()
    //var class2 = class1
    //print(NSString(format: "%p", addressHeap(class1))) // -> 0x7fd5c8700970
    //print(NSString(format: "%p", addressHeap(class2))) // -> 0x7fd5c8700970
    //
    //unsafeAddressOf(class1) //"UnsafePointer(0x7FD95AE272E0)"
    //unsafeAddressOf(class2) //"UnsafePointer(0x7FD95AE272E0)"
    //
    ////Int
    //var num1 = 55
    //var num2 = num1
    //print(NSString(format: "%p", address(&num1))) // -> "0x10f1fd480\n"
    //print(NSString(format: "%p", address(&num2))) // -> "0x10f1fd488\n"
    ///
    func addressOf(_ o: UnsafeRawPointer) -> String {
        let addr = Int(bitPattern: o)
        return String(format: "%p", addr)
    }

    func addressOf<T: AnyObject>(_ o: T) -> String {
        let addr = unsafeBitCast(o, to: Int.self)
        return String(format: "%p", addr)
    }
    
    func greetings(_ greeter: Greetable) {
        greeter.sayHi()
    }
    
    func builderExample() {
        let hitendra = Person(name: "Hitendra Solanki",
                              gender: "Male",
                              birthDate: "2nd Oct 1991",
                              birthPlace: "Gujarat, India",
                              height: "5.9 ft",
                              weight: "85kg",
                              phone: "+91 90333-71772",
                              email: "hitendra.developer@gmail.com",
                              streeAddress: "52nd Godrej Street",
                              zipCode: "380015",
                              city: "Ahmedabad",
                              companyName: "Fortune 500",
                              designation: "Software architect",
                              annualIncome: "45,000 USD")
        
        //use of Person object
        print("\(hitendra.name) works in \(hitendra.companyName) compay as a \(hitendra.designation).")
        
        // use builder
        var builderHitendra = Person() //person with empty details
        let personBuilder = PersonBuilder(person: builderHitendra)
        
        builderHitendra = personBuilder
          .personalInfo
            .nameIs("Hitendra Solanki")
            .genderIs("Male")
            .bornOn("2nd Oct 1991")
            .bornAt("Gujarat, India")
            .havingHeight("5.9 ft")
            .havingWeight("85 kg")
          .contacts
            .hasPhone("+91 90333-71772")
            .hasEmail("hitendra.developer@gmail.com")
          .lives
            .at("52nd Godrej Street")
            .inCity("Ahmedabad")
            .withZipCode("380015")
          .build()
        
        //use of Person object
        print("\(builderHitendra.name) has contact number \(builderHitendra.phone) and email \(builderHitendra.email)")
        
        //later on when we have company details ready for the person
        /*hitendra = personBuilder
          .works
            .asA("Software architect")
            .inCompany("Fortune 500")
            .hasAnnualEarning("45,000 USD")
          .build()
        
        //use of Person object with update info
        print("\(hitendra.name) works in \(hitendra.companyName) compay as a \(hitendra.designation).")*/
        
        
        var p = Person() //person with empty details
        let builder = PersonProtocolBuilder(object: p)
        
        p = builder.personalInfo.nameIs("ddd").builder()
        print("Person objec \(p.name).")
    }
    
    func objectGetClass() {
        let someRequired = SomeRequiredSubclass()
        print(addressOf(someRequired))
        print(addressOf(someRequired.self))
        //print(addressOf(object_getClass(someRequired)))
        
        object_getClass(someRequired)
        object_getClass(object_getClass(someRequired))
        object_getClass(object_getClass(object_getClass(someRequired)))
        object_getClass(object_getClass(object_getClass(object_getClass(someRequired))))
        /*
        (lldb) p/x object_getClass(someRequired)
        (AnyClass?) $R0 = 0x00000001004915d0 SwiftBlog.SomeRequiredSubclass
        (lldb) p/x object_getClass(object_getClass(someRequired))
        (AnyClass?) $R2 = 0x0000000100cd27e0 0x0000000100cd27e0
        (lldb) p/x object_getClass(object_getClass(object_getClass(someRequired)))
        (AnyClass?) $R4 = 0x0000000100cd2808 0x0000000100cd2808
        (lldb) p/x object_getClass(object_getClass(object_getClass(object_getClass(someRequired))))
        (AnyClass?) $R6 = 0x0000000100cd2808 0x0000000100cd2808 */
    }
    
    func anyObjectAny() {
        /*
         
        
         Any 和 AnyObject 的类型转换
         Swift 为不确定类型提供了两种特殊的类型别名：
         Any 可以表示任何类型，包括函数类型。
         AnyObject 可以表示任何类类型的实例。
         只有当你确实需要它们的行为和功能时才使用 Any 和 AnyObject。最好还是在代码中指明需要使用的类型。
         
        var things = [Any]()

        things.append(0)
        things.append(0.0)
        things.append(42)
        things.append(3.14159)
        things.append("hello")
        things.append((3.0, 5.0))
        //things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
        things.append({ (name: String) -> String in "Hello, \(name)" })
        
        
        for thing in things {
            switch thing {
            case 0 as Int:
                print("zero as an Int")
            case 0 as Double:
                print("zero as a Double")
            case let someInt as Int:
                print("an integer value of \(someInt)")
            case let someDouble as Double where someDouble > 0:
                print("a positive double value of \(someDouble)")
            case is Double:
                print("some other double value that I don't want to print")
            case let someString as String:
                print("a string value of \"\(someString)\"")
            case let (x, y) as (Double, Double):
                print("an (x, y) point at \(x), \(y)")
            /*case let movie as Movie:
                print("a movie called \(movie.name), dir. \(movie.director)")*/
            case let stringConverter as (String) -> String:
                print(stringConverter("Michael"))
            default:
                print("something else")
            }
        }*/
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension String {
    static func pointer(_ object: AnyObject?) -> String {
        guard let object = object else { return "nil" }
        let opaque: UnsafeMutableRawPointer = Unmanaged.passUnretained(object).toOpaque()
        return String(describing: opaque)
    }
}

//任何情况下，对于元组元素的写访问都需要对整个元组发起写访问。这意味着对于 playerInfomation 发起的两个写访问重叠了，造成冲突
var playerInformation = (health: 10, energy: 20)

struct Player {
    var name: String
    var health: Int
    var energy: Int

    static let maxHealth = 10
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
    
    func balance(_ x: inout Int, _ y: inout Int) {
        let sum = x + y
        x = sum / 2
        y = sum - x
    }
}

extension Player {
    mutating func shareHealth(with teammate: inout Player) {
        balance(&teammate.health, &health)
    }
}


struct Label {
 var text:String
 var font:UIFont
 func draw() {}
}

//主体方法加上 @objc dynamic 子类的extension 可以重写
//父类的extension中的方法加 @objc 子类的主体可以重写

//
class Base :NSObject {
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
}

class Sub:Base {}

extension Sub {
    //@objc dynamic 对应的属性需要加上
    override var directProperty: String {
        return "This is Sub"
    }
    
    override func test() {
        print("Sub--test")
    }
}

protocol Greetable {
    func sayHi()
}
extension Greetable {
    func sayHi() {
        print("hello")
    }
}

class ParentPerson : Greetable {
}
class LoudPerson:ParentPerson {
    func sayHi() {
        print("sub")
    }
}

class ParentClass {
    func method1() {}
    func method2() {
        print("this is ParentClass")
    }
}
class ChildClass: ParentClass {
    override func method2() {
        print("this is ChildClass")
    }
    func method3() {}
}

protocol MyProtocol {
}
struct MyStruct: MyProtocol {
}
extension MyStruct {
    func extensionMethod() {
        print("In Struct")
    }
}
extension MyProtocol {
    func extensionMethod() {
        print("In Protocol")
    }
}

class MyClass {
//    func extensionMethod() {
//        print("MyClass")
//    }
}
extension MyClass {
    func extensionMethod() {
        print("MyClass")
    }
}

//Overriding non-@objc declarations from extensions is not supported
/*class SubClass : MyClass {
    override func extensionMethod() {
        print("SubClass")
    }
}*/


// Defined protocol.
protocol A {
    func a() -> Int
}
extension A {
    func a() -> Int {
        return 0
    }
}

// A class doesn't have implement of the function.
class B: A {}

class C: B {
    func a() -> Int {
        return 1
    }
}

// A class has implement of the function.
class D: A {
    func a() -> Int {
        return 1
    }
}

class E: D {
    override func a() -> Int {
        return 2
    }
}

