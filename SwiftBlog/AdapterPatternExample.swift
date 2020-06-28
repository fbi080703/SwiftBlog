//
//  AdapterPatternExample.swift
//  SwiftBlog
//
//  Created by wulongwang on 2020/6/4.
//  Copyright © 2020 Wulongwang. All rights reserved.
//

import Foundation
import UIKit

class ExamplePoint {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

class LineSegment {
    var startPoint: ExamplePoint
    var endPoint:   ExamplePoint
    
    init(startPoint: ExamplePoint, endPoint: ExamplePoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
}

//Mark:- DrawingPad
//  This is just to make example more interesting
//  We are just printing the point on Console to make it simple
class DrawingPad {
    //Draw Single point, main drawing method
    func draw(point: ExamplePoint) {
        print(".")
    }
    
    //Draw multiple points
    func draw(points: [ExamplePoint]) {
        points.forEach { (point) in
            self.draw(point: point)
        }
    }
}


//Mark: LineSegmentToPointAdapter
//  This is responsible to generate all points exists on LineSegment
class LineSegmentToPointAdapter {
    var lineSegment: LineSegment
    init(lineSegment: LineSegment) {
        self.lineSegment = lineSegment
    }
    func points() -> Array<ExamplePoint> {
        //To make things simple, without complex line drawing algorithms,
        //This will only work for points like below
        //(10,10) to (20,20)
        //(34,34) to (89,89)
        //(x,y) to (p,q) where y=x and q=p i.e. (x,x) to (p,p) just to make it simple for this demo
        
        var points: Array<ExamplePoint> = []
        let zipXY = zip(
            (self.lineSegment.startPoint.x...self.lineSegment.endPoint.x),
            (self.lineSegment.startPoint.y...self.lineSegment.endPoint.y)
        )
        for (x,y) in zipXY {
            let newPoint = ExamplePoint(x: x, y: y)
            points.append(newPoint)
        }
        return points
    }
    
}

class AdapterPatternExample {
    func main(){
        let drawingPad = DrawingPad()
        let point1 = ExamplePoint(x: 10, y: 10)
        drawingPad.draw(point: point1)
    }
    
    func adapterMain() {
        let drawingPad = DrawingPad()
        //Remeber: (x,y) to (p,q) where y=x and q=p => (x,x) to (p,p) for our points logic to work
        //create lineSegment
        let startPoint = ExamplePoint(x: 2, y: 2)
        let endPoint = ExamplePoint(x: 10, y: 10)
        let lineSegment = LineSegment(startPoint: startPoint, endPoint: endPoint)
        
        //create adapter
        let adapter = LineSegmentToPointAdapter(lineSegment: lineSegment)
        
        //get points from adapter to draw
        let points = adapter.points()
        drawingPad.draw(points: points) //it will draw total 9 dots on console
    }
    
}

//https://medium.com/swift-india/protocol-the-power-of-swift-45e97f6531f9
/*

//example one
 
typealias HSCompositeTableViewDatasourceDelegate = (UITableViewDataSource & UITableViewDelegate)

class ContactListViewController: UIViewController {
    //ContactListViewController implementation
}

extension ContactListViewController: HSCompositeTableViewDatasourceDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // UITableViewDataSource
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //UITableViewDelegate
        return UITableViewCell.init()
    }
    
    //implementation of methods releated to UITableViewDataSource and UITableViewDelegate
}*/

//example two
protocol HSCombineTableViewDatasourceDelegate : UITableViewDataSource, UITableViewDelegate { } //empty protocol

class ContactListViewController: UIViewController {
    //ContactListViewController implementation
}

extension ContactListViewController: HSCombineTableViewDatasourceDelegate {
    //implementation of methods releated to UITableViewDataSource and UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // UITableViewDataSource
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //UITableViewDelegate
        return UITableViewCell.init()
    }
}
