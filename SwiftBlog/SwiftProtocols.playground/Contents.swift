import UIKit

var str = "Hello, playground"

//https://www.raywenderlich.com/6742901-protocol-oriented-programming-tutorial-in-swift-5-1-getting-started#toc-anchor-001

// CustomStringConvertible is  Extending Protocols

protocol Bird : CustomStringConvertible  {
  var name: String { get }
  var canFly: Bool { get }
}

extension CustomStringConvertible where Self: Bird {
  var description: String {
    canFly ? "I can fly" : "Guess I'll just sit here :["
  }
}

protocol Flyable {
  var airspeedVelocity: Double { get }
}


struct FlappyBird: Bird, Flyable {
  let name: String
  let flappyAmplitude: Double
  let flappyFrequency: Double
//  let canFly = true

  var airspeedVelocity: Double {
    3 * flappyFrequency * flappyAmplitude
  }
}

struct Penguin: Bird {
  let name: String
//  let canFly = false
}

struct SwiftBird: Bird, Flyable {
  var name: String { "Swift \(version)" }
//  let canFly = true
  let version: Double
  private var speedFactor = 1000.0
  
  init(version: Double) {
    self.version = version
  }

  // Swift is FASTER with each version!
  var airspeedVelocity: Double {
    version * speedFactor
  }
}

//MARK: Extending Protocols With Default Implementations

extension Bird {
  // Flyable birds can fly!
  var canFly: Bool { self is Flyable }
}

enum UnladenSwallow: Bird, Flyable {
  case african
  case european
  case unknown
  
  var name: String {
    switch self {
    case .african:
      return "African"
    case .european:
      return "European"
    case .unknown:
      return "What do you mean? African or European?"
    }
  }
  
  var airspeedVelocity: Double {
    switch self {
    case .african:
      return 10.0
    case .european:
      return 9.9
    case .unknown:
      fatalError("You are thrown from the bridge of death!")
    }
  }
}

//MARK: Overriding Default Behavior

extension UnladenSwallow {
  var canFly: Bool {
    self != .unknown
  }
}

UnladenSwallow.unknown.canFly         // false
UnladenSwallow.african.canFly         // true
Penguin(name: "King Penguin").canFly  // false

UnladenSwallow.african
UnladenSwallow.european
UnladenSwallow.unknown
UnladenSwallow.african.name

let numbers = [10, 20, 30, 40, 50, 60]
let slice = numbers[1...3]
let reversedSlice = slice.reversed()

let answer = reversedSlice.map { $0 * 10 }
print(answer)

class Motorcycle {
  init(name: String) {
    self.name = name
    speed = 200.0
  }

  var name: String
  var speed: Double
}

//MARK：Off to the Races

// 1
protocol Racer {
  var speed: Double { get }  // speed is the only thing racers care about
}

// 2
extension FlappyBird: Racer {
  var speed: Double {
    airspeedVelocity
  }
}

extension SwiftBird: Racer {
  var speed: Double {
    airspeedVelocity
  }
}

extension Penguin: Racer {
  var speed: Double {
    42  // full waddle speed
  }
}

extension UnladenSwallow: Racer {
  var speed: Double {
    canFly ? airspeedVelocity : 0.0
  }
}

extension Motorcycle: Racer {}

// 3
let racers: [Racer] =
  [UnladenSwallow.african,
   UnladenSwallow.european,
   UnladenSwallow.unknown,
   Penguin(name: "King Penguin"),
   SwiftBird(version: 5.1),
   FlappyBird(name: "Felipe", flappyAmplitude: 3.0, flappyFrequency: 20.0),
   Motorcycle(name: "Giacomo")]

func topSpeed(of racers: [Racer]) -> Double {
  racers.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
}

topSpeed(of: racers) // 5100


// 1
func topSpeed<RacersType: Sequence>(of racers: RacersType) -> Double
    /*2*/ where RacersType.Iterator.Element == Racer {
  // 3
  racers.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
}

topSpeed(of: racers[1...3]) // 42

//MARK: Making It More Swifty

extension Sequence where Iterator.Element == Racer {
  func topSpeed() -> Double {
    self.max(by: { $0.speed < $1.speed })?.speed ?? 0.0
  }
}

racers.topSpeed()        // 5100
racers[1...3].topSpeed() // 42

//MARK: Protocol Comparators

//protocol SwiftScore {
//  var value: Int { get }
//}

protocol Score: Comparable {
  var value: Int { get }
}

//struct RacingScore: Score {
//  let value: Int
//}

struct RacingScore: Score {
  let value: Int
  
  static func <(lhs: RacingScore, rhs: RacingScore) -> Bool {
    lhs.value < rhs.value
  }
}

RacingScore(value: 150) >= RacingScore(value: 130) // true

//MARK: Mutating Functions

protocol Cheat {
  mutating func boost(_ power: Double)
}

extension SwiftBird: Cheat {
  mutating func boost(_ power: Double) {
    speedFactor += power
  }
}

var swiftBird = SwiftBird(version: 5.0)
swiftBird.boost(3.0)
swiftBird.airspeedVelocity // 5015
swiftBird.boost(3.0)
swiftBird.airspeedVelocity // 5030
