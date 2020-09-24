//
//  InjectionPatterns.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/9/23.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation
import Swinject


class InjectionPatterns {
    static func example() {
        let container = Swinject.Container()
        
        //MARK: Initializer Injection
        
        container.register(AnimalDI.self) { _ in CatDI() }
        container.register(PersonDI.self) { r in
            PetOwner(pet: r.resolve(AnimalDI.self)!)
        }
        
        //MARK: Property Injection
        
        container.register(AnimalDI.self) { _ in CatDI() }
        container.register(PersonDI.self) { r in
            let owner = PetOwner2()
            owner.pet = r.resolve(AnimalDI.self)
            return owner
        }
        
        //initCompleted
        container.register(AnimalDI.self) { _ in CatDI() }
        container.register(PersonDI.self) { _ in PetOwner2() }
            .initCompleted { r, p in
                let owner = p as! PetOwner2
                owner.pet = r.resolve(AnimalDI.self)
        }
        
        //MARK: Method Injection
        
        container.register(AnimalDI.self) { _ in CatDI() }
        container.register(PersonDI.self) { r in
            let owner = PetOwner3()
            owner.setPet(pet: r.resolve(AnimalDI.self)!)
            return owner
        }
        
        //initCompleted
        container.register(AnimalDI.self) { _ in CatDI() }
        container.register(PersonDI.self) { _ in PetOwner3() }
            .initCompleted { r, p in
                let owner = p as! PetOwner3
                owner.setPet(pet: r.resolve(AnimalDI.self)!)
        }
        
       let person = container.resolve(PersonDI.self)
        let pet = (person as! PetOwner3).pet
        print(person is PetOwner3) // prints "true"
        print(pet?.name ?? "") // prints ""
        print(pet is CatDI) // prints "true"
        
    }
}

class PetOwner2: PersonDI {
    var name: String
    var pet: AnimalDI?
    init() {
        self.name = ""
    }
}

class PetOwner3: PersonDI {
    var pet: AnimalDI?
    var name: String

    init() {
       self.name = ""
    }
    func setPet(pet: AnimalDI) {
        self.pet = pet
    }
}
