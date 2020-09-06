//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

//https://www.dazhuanlan.com/2019/10/25/5db286b375738/
//https://stackoverflow.com/questions/44441223/encode-decode-array-of-types-conforming-to-protocol-with-jsonencoder
//https://stackoverflow.com/questions/31438368/swift-whats-the-difference-between-metatype-type-and-self

//class MyViewController : UIViewController {
//    override func loadView() {
//        let view = UIView()
//        view.backgroundColor = .white
//
//        let label = UILabel()
//        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
//        label.text = "Hello World!"
//        label.textColor = .black
//
//        view.addSubview(label)
//        self.view = view
//    }
//}
//// Present the view controller in the Live View window
//PlaygroundPage.current.liveView = MyViewController()


struct AnimalCodable: Codable {
    let name: String
    let age: Int
}

let animalCodable = AnimalCodable(name: "旺财", age: 1)

let jsonEncoder = JSONEncoder()
let jsonData = try jsonEncoder.encode(animalCodable)
if let str = String(data: jsonData, encoding: .utf8) {
    print(str)
    // {"name":"旺财","age":1}
}

// 用JSONDecoder把JSON Data解码回instance
let jsonDecoder = JSONDecoder()
let decodedAnimalCodable = try jsonDecoder.decode(AnimalCodable.self, from: jsonData)
print(decodedAnimalCodable)


struct Person {
    enum Gender: Int, Codable {
        case male = 0, female
    }
    
    let name: String
    let gender: Gender?
    let birthday: String // Format of yyyy-MM-dd
    
    init(name: String, gender: Gender?, birthday: String) {
        self.name = name
        self.gender = gender
        self.birthday = birthday
    }
    
    static func birthdayFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

extension Person: Codable {
    enum PersonCodKeys: String, CodingKey {
        case name = "person_name"
        case gender
        case birthday = "timestamp_birthday"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: PersonCodKeys.self)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(gender, forKey: .gender)
        guard let timestamp: TimeInterval = Person.birthdayFormatter().date(from: birthday)?.timeIntervalSince1970 else {
            fatalError("invalid birthday")
        }
        try container.encode(timestamp, forKey: .birthday)
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: PersonCodKeys.self)
        name = try container.decode(String.self, forKey: .name)
        gender = try container.decodeIfPresent(Gender.self, forKey: .gender)
        let timestamp: TimeInterval = try container.decode(TimeInterval.self, forKey: .birthday)
        birthday = Person.birthdayFormatter().string(from: Date(timeIntervalSince1970: timestamp))
    }
}

let ming = Person(name: "小明", gender: .male, birthday: "1999-02-11")
let personJsonData = try jsonEncoder.encode(ming)
if let str = String(data: personJsonData, encoding: .utf8) {
    print(str)
    // {"name":"小明","timestamp_birthday":918662400,"gender":0}
}


// 用JSONDecoder把JSON Data转回instance
let decodedMing = try jsonDecoder.decode(Person.self, from: personJsonData)
print(decodedMing)

class Creature : Codable {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class Animal: Creature {
    var hasLeg: Bool
    
    init(name: String, age: Int, hasLeg: Bool) {
        self.hasLeg = hasLeg
        super.init(name: name, age: age)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        hasLeg = try container.decode(Bool.self, forKey: .hasLeg)
        // 注意：调用父类的init(from:)方法
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(hasLeg, forKey: .hasLeg)
        // 注意：调用父类的encode(to:)方法
        let superdecoder = container.superEncoder()
        try super.encode(to: superdecoder)
    }

    enum CodingKeys: String, CodingKey {
        case hasLeg
    }
}

class Plant: Creature {
    var height: Double
    
    init(name: String, age: Int, height: Double) {
        self.height = height
        super.init(name: name, age: age)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        height = try container.decode(Double.self, forKey: .height)
    
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(height, forKey: .height)
        
        let superdecoder = container.superEncoder()
        try super.encode(to: superdecoder)
    }
    
    enum CodingKeys: String, CodingKey {
        case height
    }
}

let creature = Creature(name: "some_name", age: 12)
let creatureJsonData = try jsonEncoder.encode(creature)
if let str = String(data: creatureJsonData, encoding: .utf8) {
    print(str)
    // {"name":"some_name","age":12}
}
let decodedCreature: Creature = try jsonDecoder.decode(Creature.self, from: creatureJsonData)


let animal = Animal(name: "miaomiao", age: 2, hasLeg: true)
let animalJsonData = try jsonEncoder.encode(animal)
if let str = String(data: animalJsonData, encoding: .utf8) {
    print(str)
    // {"super":{"name":"miaomiao","age":2},"hasLeg":true}
}
let decodedAnimal: Animal = try jsonDecoder.decode(Animal.self, from: animalJsonData)


// 首先定义一个Creature类型的对象，并且用子类Animal初始化
let creatureNew: Creature = Animal(name: "miaomiao", age: 2, hasLeg: true)
let creatureJsonDataNew = try jsonEncoder.encode(creatureNew)
if let strNew = String(data: creatureJsonDataNew, encoding: .utf8) {
    print(strNew)
    // 这里打印出了以下信息，符合预期
    //{"super":{"name":"miaomiao","age":2},"hasLeg":true}
}
// 用JSONDecoder把JSON Data转回instance
// 以下这句代码报错了！
let decodedAnimalNew: Creature = try jsonDecoder.decode(Creature.self, from: creatureJsonDataNew)


// Swift无法使用type string来构造Type，因此对每个使用了多态的类簇，实现一个遵守此协议的enum，间接获取Type。
protocol Meta: Codable {
    associatedtype Element
    
    static func metatype(for element: Element) -> Self
    var type: Decodable.Type { get }
}


//struct MetaArray<M: Meta>: Codable, ExpressibleByArrayLiteral {
//
//    let array: [M.Element]
//
//    init(_ array: [M.Element]) {
//        self.array = array
//    }
//
//    init(arrayLiteral elements: M.Element...) {
//        self.array = elements
//    }
//
//    enum CodingKeys: String, CodingKey {
//        case metatype
//        case object
//    }
//
//    init(from decoder: Decoder) throws {
//        var container = try decoder.unkeyedContainer()
//
//        var elements: [M.Element] = []
//        while !container.isAtEnd {
//            let nested = try container.nestedContainer(keyedBy: CodingKeys.self)
//            let metatype = try nested.decode(M.self, forKey: .metatype)
//
//            let superDecoder = try nested.superDecoder(forKey: .object)
//            let object = try metatype.type.init(from: superDecoder)
//            if let element = object as? M.Element {
//                elements.append(element)
//            }
//        }
//        array = elements
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.unkeyedContainer()
//        try array.forEach { object in
//            let metatype = M.metatype(for: object)
//            var nested = container.nestedContainer(keyedBy: CodingKeys.self)
//            try nested.encode(metatype, forKey: .metatype)
//            let superEncoder = nested.superEncoder(forKey: .object)
//
//            let encodable = object as? Encodable
//            try encodable?.encode(to: superEncoder)
//        }
//    }
//}
//
//enum CreatureMetaType: String, Meta {
//
//    typealias Element = Creature
//
//    static func metatype(for element: Creature) -> CreatureMetaType {
//        return element.self
//    }
//    // Raw Value需要与类名Type严格一致；case需要覆盖到类簇里的每一类型！
//    case creature = "Creature"
//    case animal = "Animal"
//    case plant = "Plant"
//
//    var type: Decodable.Type {
//        switch self {
//        case .creature:
//            return Creature.self
//        case .animal:
//            return Animal.self
//        case .plant:
//            return Plant.self
//        }
//    }
//}
//
//
//let creatureNewss: Creature = Animal(name: "miaomiao", age: 2, hasLeg: true)
//// Encode时，Encode的不是creature对象本身，而是装着creature对象的Wrapper: MetaObject<CreatureMetaType>
//let creatureJsonDataNewss = try JSONEncoder().encode(MetaArray<CreatureMetaType>(creatureNewss))
//if let str = String(data: creatureJsonDataNewss, encoding: .utf8) {
//    print(str)
//    // 可以看到，creature对象实际的类型"Animal"被编码进json了
//    // {"metatype":"Animal","object":{"super":{"name":"miaomiao","age":2},"hasLeg":true}}
//}
//// 解码时，也是先解码出Wrapper
//let decodedMetaObjectNewss: MetaArray<CreatureMetaType> = try JSONDecoder().decode(MetaArray<CreatureMetaType>.self, from: creatureJsonData)
//// 然后再取出其中Object，这个Object的类型是"Animal"
//let decodedCreature = decodedMetaObjectNewss.object
