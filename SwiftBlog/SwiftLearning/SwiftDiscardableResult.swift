//
//  SwiftDiscardableResult.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/5/30.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

func foo() -> String {
    return "wulongwang"
}

@discardableResult
func bar() -> String {
    return "wulongwang"
}
