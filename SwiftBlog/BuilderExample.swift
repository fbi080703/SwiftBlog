//
//  BuilderExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/5/30.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

//https://medium.com/flawless-app-stories/design-patterns-by-tutorials-the-power-of-oop-2e871b551cbe

class Person {
  //personal details
  var name: String = ""
  var gender: String = ""
  var birthDate: String = ""
  var birthPlace: String = ""
  var height: String = ""
  var weight: String = ""
  
  //contact details
  var phone: String = ""
  var email: String = ""
  
  //address details
  var streeAddress: String = ""
  var zipCode: String = ""
  var city: String = ""
  
  //work details
  var companyName: String = ""
  var designation: String = ""
  var annualIncome: String = ""
    
    init() {}

  //constructor
  init(name: String,
       gender: String,
       birthDate: String,
       birthPlace: String,
       height: String,
       weight: String,
       phone: String,
       email: String,
       streeAddress: String,
       zipCode: String,
       city: String,
       companyName: String,
       designation: String,
       annualIncome: String) {
    self.name = name
    self.gender = gender
    self.birthDate = birthDate
    self.birthPlace = birthPlace
    self.height = height
    self.weight = weight
    self.phone = phone
    self.email = email
    self.streeAddress = streeAddress
    self.zipCode = zipCode
    self.height = height
    self.city = city
    self.companyName = companyName
    self.designation = designation
    self.annualIncome = annualIncome
  }
}

class PersonBuilder {
  var person: Person
  init(person: Person){
    self.person = person
  }
  
  //personal details builder switching
  var personalInfo: PersonPersonalDetailsBuilder {
    return PersonPersonalDetailsBuilder(person: self.person)
  }
  
  //contact details builder switching
  var contacts: PersonContactDetailsBuilder {
    return PersonContactDetailsBuilder(person: self.person)
  }
  
  //address details builder switching
  var lives: PersonAddressDetailsBuilder {
    return PersonAddressDetailsBuilder(person: self.person)
  }
  
  //work details builder switching
  var works: PersonCompanyDetailsBuilder {
    return PersonCompanyDetailsBuilder(person: self.person)
  }
  
  func build() -> Person {
    return self.person
  }
}

//PersonPersonalDetailsBuilder: update personal details
class PersonPersonalDetailsBuilder: PersonBuilder {
  func nameIs(_ name: String) -> Self {
    self.person.name = name
    return self
  }
  func genderIs(_ gender: String) -> Self {
    self.person.gender = gender
    return self
  }
  func bornOn(_ birthDate: String) -> Self {
    self.person.birthDate = birthDate
    return self
  }
  func bornAt(_ birthPlace: String) -> Self {
    self.person.birthPlace = birthPlace
    return self
  }
  func havingHeight(_ height: String) -> Self {
    self.person.height = height
    return self
  }
  func havingWeight(_ weight: String) -> Self {
    self.person.weight = weight
    return self
  }
}

//PersonContactDetailsBuilder: update contact details
class PersonContactDetailsBuilder: PersonBuilder {
  func hasPhone(_ phone: String) -> Self {
    self.person.phone = phone
    return self
  }
  func hasEmail(_ email: String) -> Self {
    self.person.email = email
    return self
  }
}

//PersonAddressDetailsBuilder: update address details
class PersonAddressDetailsBuilder: PersonBuilder {
  func at(_ streeAddress: String) -> Self {
    self.person.streeAddress = streeAddress
    return self
  }
  func withZipCode(_ zipCode: String) -> Self {
    self.person.zipCode = zipCode
    return self
  }
  func inCity(_ city: String) -> Self {
    self.person.city = city
    return self
  }
}

//PersonCompanyDetailsBuilder: update company details
class PersonCompanyDetailsBuilder: PersonBuilder {
  func inCompany(_ companyName: String) -> Self {
    self.person.companyName = companyName
    return self
  }
  func asA(_ designation: String) -> Self {
    self.person.designation = designation
    return self
  }
  func hasAnnualEarning(_ annualIncome: String) -> Self {
    self.person.annualIncome = annualIncome
    return self
  }
    
}

// 通过protocol方式实现的一种方案

protocol HSBuilder {
   associatedtype Builder
    associatedtype ToBuilder
    var object : ToBuilder {get}
    init(object: ToBuilder)
    func builder() -> ToBuilder
}


class PersonProtocolBuilder: HSBuilder {
    var object: Person
    
    required init(object: Person) {
        self.object = object
    }
    
    func builder() -> Person {
        return self.object
    }
    
    typealias Builder = PersonProtocolBuilder
    typealias ToBuilder = Person
    
    var personalInfo: PersonDetailBuilder {
        return PersonDetailBuilder(object: self.object)
    }
    
}

class PersonDetailBuilder: PersonProtocolBuilder {
    func nameIs(_ name: String) -> Self {
        self.object.name = name
        return self
    }
}

