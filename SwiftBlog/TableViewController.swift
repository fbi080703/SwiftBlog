//
//  ViewController.swift
//  SwiftBlog
//
//  Created by Patrick Balestra on 04/09/14.
//  Copyright (c) 2014 Patrick Balestra. All rights reserved.
//

import UIKit

class BlogPost {
    var title = String()
    var link = String()
    var description = String()
    var date = String()
}

extension Array {
    func accumulate<U>(initial: U, combine: (U, Element) -> U) -> [U] {
        var running = initial
        return self.map { next in
                running = combine(running, next)
                return running
        }
   }
}

extension Array {
    func flter (includeElement: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for x in self where includeElement(x) {
            result.append(x)
        }
       return result }
}

class Example {
      init () {
        print("init Example")
    }
    deinit {
        print("deinit Example")
    }
}


class TableViewController: UITableViewController, XMLParserDelegate {
                            
    var parser = XMLParser()
    var blogPosts: [BlogPost] = []
    
    var eName = String()
    var postTitle = String()
    var postLink = String()
    var descriptionText = String()
    var postDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "NavigationBarBackground"), for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white, NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Light", size: 18)!]
        navigationController?.navigationBar.shadowImage = UIImage()
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        
        let url = URL(string: "https://developer.apple.com/swift/blog/news.rss")
//        var url: URL = URL.URLWithString("https://developer.apple.com/swift/blog/news.rss")!
        parser = XMLParser(contentsOf: url!)!
        parser.delegate = self
        parser.parse()
        
        //
        navigationController?.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign In", style: .plain, target: nil,
            action: #selector(self.signInAction)
            //Argument of '#selector' refers to instance method 'signInAction()' that is not exposed to Objective-C
        )
        

        //let contents = String.init(contentsOf: url!, encoding: String.Encoding(rawValue: 0))
//        let contents = String(contentsOf: url, encoding: 0, error: nil)
        
        /*let a = NSMutableArray(array: [1,2,3]) // 我们不想让b发生改变
        let b: NSArray = a
        // 但是事实上它依然能够被a影响并改变
        a.insert(4, at: 3)
        
        print(a)
        print(b)
        
        let array = [1, 2, 3, 4, 5]
        
        print(array.accumulate(initial: 100, combine: +))
        
        var otherArray = array;
        
        otherArray.insert(6, at: 5)
        
        print(array)
        print(otherArray)
        
       (1..<10).forEach { number in
            print(number)
            if number > 2 {
                return
            }
        }*/
        
        /*let stringNumbers = ["1", "2", "3", "foo"]
        let maybeInts = stringNumbers.map {Int($0)}
        for case let i? in maybeInts {
            print(i)
        }
        
        for case nil in maybeInts {
            print("---")
        }
        
        var temps = ["-459.67", "98.6", "0", "warm"]
        temps.sort { ($0) < ($1) }
        print(temps)
        
        // logIfTrue(predicate: () -> Bool)
        logIfTrue { 1 < 2 }
        // logIfTrueWi  thAutoclosure(predicate: Bool)
        logIfTrueWithAutoclosure(1 < 2)
        
        var array = [1, 2, 3, 4, 5]

        array.removeLast()
        print(array.count)

        var closureVar = { array.removeLast() }
        print(array.count)

        closureVar()
        print(array.count)
        
        let str: String? = nil
        useString(s: str)
        
        let image = UIImage.init()
        
        let inputParameters = [kCIInputRadiusKey:10, kCIInputImageKey:image] as [String : Any]
        let blurFilter = CIFilter(name: "CIGaussianBlur",parameters:inputParameters)!
        let secondBlurFilter = blurFilter
        secondBlurFilter.setValue(20, forKey: kCIInputRadiusKey)
        print("-----------")
        print(uniqueIntegerProvider()())
        print(uniqueIntegerProvider()())
        print(uniqueIntegerProvider()())
        
        //let example = Example()
        //print("About to leave the scope")
        
        _ = capturingScope()
        
        let sample = TestSample();
        sample.printName()
        
        TestSample.someTypeMethod() */
        
        //let conforms = sample.conforms(to: TestProtocol.self)
       // print(conforms)
        
        
//        var variableString = "Horse"
//        var address = String(format: "%p", variableString)
//        print(address)
//        variableString += " and carriage"
//        address = String(format: "%p", variableString)
//        print(address)
        // variableString is now "Horse and carriage"

        //let constantString = "Highlander"
        //constantString += " and another Highlander"
        
//        // Objective-C
//        -void myMethodWithSome:(id <MyProtocolName>)param {
//           // ...
//        }
//
//        // Swift
//        func myMethodWithSome(param: protocol<MyProtocolName>) {
//           //...
//        }
        
        /*let success = ServerResponse.result("6:00 am", "8:09 pm")
        let failure = ServerResponse.failure("Out of cheese.")

        switch success {
        case let .result(sunrise, sunset):
            print("Sunrise is at \(sunrise) and sunset is at \(sunset)")
        case let .failure(message):
            print("Failure...  \(message)")
        }*/
        
    //    let a = SimpleClass()
    //    a.adjust()
    //    let aDescription = a.simpleDescription
    //
    //    var b = SimpleStructure()
    //    b.adjust()
    //    let bDescription = b.simpleDescription
        

        /*var fridgeIsOpen = false
        let fridgeContent = ["milk", "eggs", "leftovers"]

        func fridgeContains(_ food: String) -> Bool {
            fridgeIsOpen = true
            defer {
                fridgeIsOpen = false
            }

            let result = fridgeContent.contains(food)
            return result
        }
        fridgeContains("banana")
        print(fridgeIsOpen)*/
        /*let unusualMenagerie = "🐨🐌🐧🐪\u{301}"
        let dd = unusualMenagerie[unusualMenagerie.index(before: unusualMenagerie.endIndex)]
        print("unusualMenagerie \(unusualMenagerie) endIndex \(dd) has \(unusualMenagerie.count) characters")
        
        var someInt = 3
        var anotherInt = 107
        swapTwoInts(&someInt, &anotherInt)
        print("someInt is now \(someInt), and anotherInt is now \(anotherInt)")
        // 打印“someInt is now 107, and anotherInt is now 3”
        
        let digitNames = [
            0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
            5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
        ]
        let numbers = [16, 58, 510]*/
        /*let strings = numbers.map {
            (number) -> String in
            var number = number
            var output = ""
            repeat {
                output = digitNames[number % 10]! + output
                number /= 10
            } while number > 0
            return output
        }*/
        /*let strings = numbers.map({
            (number) -> String in
            var number = number
            var output = ""
            repeat {
                output = digitNames[number % 10]! + output
                number /= 10
            } while number > 0
            return output
        })*/
        // strings 常量被推断为字符串类型数组，即 [String]
        // 其值为 ["OneSix", "FiveEight", "FiveOneZero"]
        //print(strings)
        
        //print(ASCIIControlCharacter.lineFeed.rawValue)
    }
    
    @objc dynamic private func signInAction() {}
    
    func swapTwoInts(_ a: inout Int, _ b: inout Int) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    enum ASCIIControlCharacter: Character {
        case tab = "\t"
        case lineFeed = "\n"
        case carriageReturn = "\r"
    }
    
    
    enum ServerResponse {
        case result(String, String)
        case failure(String)
    }
    
    func capturingScope() -> () -> () {
        let example = Example()
        return { print(example) }
    }
    
    func uniqueIntegerProvider() -> () -> Int {
        var i = 0
        return { i+=1
                  return i }
    }
    
    func useString(s: String?) {
        print(s)
    }
    
    //func doStuffWithFileExtension( leName: String) {
    //    guard let period =  leName.characters.index(of:".") else { return }
    //    let extensionRange = period.successor()..< leName.endIndex; let 􏰀leExtension = 􏰀leName[extensionRange]
    //    print (  leExtension)
    //}
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        eName = elementName
        if elementName == "item" {
            postTitle = String()
            postLink = String()
            descriptionText = String()
            postDate = String()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let blogPost: BlogPost = BlogPost()
            blogPost.title = postTitle
            blogPost.link = postLink
            blogPost.description = descriptionText
            blogPost.date = postDate
            blogPosts.append(blogPost)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        //let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if (!data.isEmpty) {
            if eName == "title" {
                postTitle += data
            } else if eName == "link" {
                postLink += data
            } else if eName == "description" {
                descriptionText += data
            } else if eName == "pubDate" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, dd LLL yyyy HH:mm:ss zzz"
                dateFormatter.timeZone = TimeZone(abbreviation: "PDT")
                let formattedDate = dateFormatter.date(from: data)
                if formattedDate != nil {
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    postDate = dateFormatter.string(from: formattedDate!)
                }
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blogPosts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let currentBlogPost: BlogPost = blogPosts[indexPath.row]
        cell.textLabel?.text = currentBlogPost.title
        cell.detailTextLabel?.text = currentBlogPost.description
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.numberOfLines = 1
        
        let dateLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 25))
        dateLabel.textColor = UIColor.orange
        dateLabel.textAlignment = .right
        dateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12)
        dateLabel.text = currentBlogPost.date
        cell.accessoryView = dateLabel
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "post") {
            let webView: WebviewPost = segue.destination as! WebviewPost
            webView.blogPostURL = URL(string:blogPosts[(tableView.indexPathForSelectedRow?.row)!].link)
        }
    }
    
    func logIfTrue(_ predicate: () -> Bool) {
        if predicate() {
            print(#function)
        }
    } // logIfTrue(predicate: () -> Bool) logIfTrue { 1 < 2 }  // logIfTrueWithAutoclosure(predicate: Bool) logIfTrueWithAutoclosure(1 < 2)

   func logIfTrueWithAutoclosure(_ predicate: @autoclosure () -> Bool) {
        if predicate() {
            print(#function)
        }
    }
}

class NamedShape {
    var numberOfSides: Int = 0
    var name: String

    init(name: String) {
        self.name = name
    }

    func simpleDescription() -> String {
        return "A shape with \(numberOfSides) sides."
    }
}

class Square: NamedShape {
    var sideLength: Double

    init(sideLength: Double, name: String) {
        self.sideLength = sideLength
        super.init(name: name)
        numberOfSides = 4
    }

    func area() ->  Double {
        return sideLength * sideLength
    }

    override func simpleDescription() -> String {
        return "A square with sides of length \(sideLength)."
    }
}

protocol ExampleProtocol {
    var simpleDescription: String { get }
    mutating func adjust()
}

class SimpleClass: ExampleProtocol {
    var simpleDescription: String = "A very simple class."
    var anotherProperty: Int = 69105
    func adjust() {
        simpleDescription += "  Now 100% adjusted."
    }
}

struct SimpleStructure: ExampleProtocol {
    var simpleDescription: String = "A simple structure"
     mutating func adjust() {
        simpleDescription += " (adjusted)"
    }
}
