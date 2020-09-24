//
//  CircularDependencies.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/9/23.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation
import Swinject

//https://github.com/Swinject/Swinject/blob/master/Documentation/CircularDependencies.md

class CircularDependencies {
    static func example() {
        let container = Swinject.Container()
        
        //MARK: Initializer/Property Dependencies
        container.register(ParentProtocol.self) { r in
            ParentCircularDependencies(child: r.resolve(ChildProtocol.self)!)
        }
        
        container.register(ChildProtocol.self) { _ in ChildCircularDependencies() }
        .initCompleted { r, c in
            let child = c as! ChildCircularDependencies
            child.parent = r.resolve(ParentProtocol.self)
        }
        
        //MARK: Property/Property Dependencies
        
        /*container.register(ParentProtocol.self) { r in
            let parent = Parent()
            parent.child = r.resolve(ChildProtocol.self)!
            return parent
        }
        container.register(ChildProtocol.self) { _ in Child() }
            .initCompleted { r, c in
                let child = c as! Child
                child.parent = r.resolve(ParentProtocol.self)
        }*/
        
       /*container.register(ParentProtocol.self) { r in
            let parent = ParentCircularDependencies()
            parent.child = r.resolve(ChildProtocol.self)!
            return parent
        }
        //TO
        container.register(ParentProtocol.self) { _ in Parent() }
        .initCompleted { r, p in
            let parent = p as! Parent
            parent.child = r.resolve(ChildProtocol.self)!
        }*/
    }
}

protocol ParentProtocol: AnyObject { }
protocol ChildProtocol: AnyObject { }

class ParentCircularDependencies: ParentProtocol {
    let child: ChildProtocol?

    init(child: ChildProtocol?) {
        self.child = child
    }
}

class ChildCircularDependencies: ChildProtocol {
    weak var parent: ParentProtocol?
}

//class Parent: ParentProtocol {
//    var child: ChildProtocol?
//}
//
//class Child: ChildProtocol {
//    weak var parent: ParentProtocol?
//}
