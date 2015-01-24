//
//  TestArc.swift
//  ArcTest
//
//  Created by Jonathan Wight on 8/26/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

import SwiftGraphics

class ARCHandle : NSObject {
    dynamic var position : CGPoint = CGPointZero {
        willSet {
            self.willChangeValueForKey("position_x")
            self.willChangeValueForKey("position_y")
        }
        didSet {
            self.didChangeValueForKey("position_x")
            self.didChangeValueForKey("position_y")
            }
    }
    
    dynamic var position_x : CGFloat {
        get { return position.x }
        set { position.x = newValue }
    }
    dynamic var position_y : CGFloat {
        get { return position.y }
        set { position.y = newValue }
    }
    
    init(position:CGPoint) {
        super.init()
        self.position = position;
    }
}

class TestArc : NSObject {
    // TODO remove this
    dynamic var handles : [ARCHandle] = [
        ARCHandle(position:CGPoint(x:100, y:100)),
        ARCHandle(position:CGPoint(x:200, y:200)),
        ]
    
    dynamic var start : CGPoint { get { return handles[0].position } }
    dynamic var end : CGPoint { get { return handles[1].position } }
        
    dynamic var angle : CGFloat = 0.0
    dynamic var rx : CGFloat = 50.0
    dynamic var ry : CGFloat = 50.0
    dynamic var largeArc : Bool = false
    dynamic var sweep : Bool = false
    
    var radius : CGFloat { get { return max(rx, ry) } }
    
    var center : CGPoint {
        get {
            let midPoint = (start + end) / 2
            let a = (midPoint - start).magnitude
            let c = radius
            let b = sqrt(c ** 2 - a ** 2)
            let theta = atan2(end - start) + DegreesToRadians(90)
            let center = CGPoint(magnitude: b, direction:theta) + midPoint
            return center
        }
    }
}
