//
//  AppDelegate.swift
//  SwiftBlog
//
//  Created by Patrick Balestra on 04/09/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        
        /*var hitendra = Person(name: "Hitendra Solanki",
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
        
        print("Person objec \(p.name).") */
        
        //let throttledNetworkManager = ThrottledNetworkManager()
        //throttledNetworkManager.printDebugData()
        
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
        let stepCounter = StepCounter()
        stepCounter.totalSteps = 200
        
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
        
        
        return true
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

