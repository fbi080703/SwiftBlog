//
//  SubscriptExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/10.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation

//let mm = Planet.earth
 
 //let mars = Planet[5]
 //print(mars)
 
/*let train = Train.init()
train.defaultType = "dfddfd"
print(train.defaultType)*/
 
 //Point(x: 2.0, y: 2.0)
 //let r = Rect.init(origin: ExtensionPoint(x: 0.0, y: 0.0), size: ExtensionSize(width: 5.0, height: 60.0))

enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    static subscript(n: Int) -> Planet {
        return Planet(rawValue: n)!
    }
}
//let mars = Planet[4]
//print(mars)


struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

//var matrix = Matrix(rows: 2, columns: 2)
//matrix[0, 1] = 1.5
//matrix[1, 0] = 3.2
