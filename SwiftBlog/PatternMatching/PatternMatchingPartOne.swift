//
//  PatternMatchingPartOne.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/9/11.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

//https://alisoftware.github.io/swift/pattern-matching/2016/03/27/pattern-matching-1/

import Foundation

//Switch Basics

enum Direction {
  case north, south, east, west
}

// We can easily switch between simple enum values
extension Direction: CustomStringConvertible {
  var description: String {
    switch self {
    case .north: return "⬆️"
    case .south: return "⬇️"
    case .east: return "➡️"
    case .west: return "⬅️"
    }
  }
}

enum Media {
  case book(title: String, author: String, year: Int)
  case movie(title: String, director: String, year: Int)
  case website(url: NSURL, title: String)
}

extension Media {
  var mediaTitle: String {
    switch self {
    case .book(title: let aTitle, author: _, year: _):
      return aTitle
    case .movie(title: let aTitle, director: _, year: _):
      return aTitle
    case .website(url: _, title: let aTitle):
      return aTitle
    }
  }
  //case .book(title: let aTitle, author: let anAuthor, year: let aYear): …
  //case let .book(title: aTitle, author: anAuthor, year: aYear): …
  
  var isFromJulesVerne: Bool {
    switch self {
        case .book(title: _, author: "Jules Verne", year: _): return true
        case .movie(title: _, director: "Jules Verne", year: _): return true
        default: return false
    }
  }
    
  func checkAuthor(_ author: String) -> Bool {
        switch self {
        case .book(title: _, author: author, year: _): return true
        case .movie(title: _, director: author, year: _): return true
        default: return false
      }
   }
    
    var mediaTitle2: String {
       switch self {
         // Error: 'case' labels with multiple patterns cannot declare variables
           case let .book(title: aTitle, author: _, year: _), let .movie(title: aTitle, director: _, year: _):
             return aTitle
           case let .website(url: _, title: aTitle):
             return aTitle
       }
    }
    
    //var mediaTitle2: String {
    //switch self {
    //    case let .book(title, _, _): return title
    //    case let .movie(title, _, _): return title
    //    case let .website(_, title): return title
    //}
    //}

  var mediaTitle3: String {
    switch self {
        //Cannot match several associated values at once, implicitly tupling the associated values and trying to match that instead
        case let .book(tuple): return tuple.author
        case let .movie(tuple): return tuple.title
        case let .website(tuple): return tuple.title
    }
  }
  //Using Where
  var publishedAfter1930: Bool {
    switch self {
        case let .book(_, _, year) where year > 1930: return true
        case let .movie(_, _, year) where year > 1930: return true
        case .website: return true // same as "case .website(_)" but we ignore the associated tuple value
        default: return false
     }
  }
  
}

//enum Response {
//  case httpResponse(statusCode: Int)
//  case networkError(Error)
//  …
//}
//
//let response: Response = …
//switch response {
//  case .httpResponse(200): …
//  case .httpResponse(404): …
//  …
//}


