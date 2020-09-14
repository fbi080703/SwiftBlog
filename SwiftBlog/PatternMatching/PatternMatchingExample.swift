//
//  PatternMatchingExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/9/11.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation



class PatternMatchingExample {
    static func testStaticExample() {
        
        // switch, enums & where clauses
        let book = Media.book(title: "20,000 leagues under the sea", author: "Jules Verne", year: 1870)
        print(book.mediaTitle)
        print(book.mediaTitle3)
        print(book.isFromJulesVerne)
        print(book.checkAuthor("Jules Verne"))
    }
}
