//
//  GrahamScan.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/10/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

public func grahamOrdered(var points:[CGPoint]) -> [CGPoint] {
    // Find the point (and its index) with the lowest y
    typealias IndexedPoint = (index:Int,point:CGPoint)
    
    let lowest = reduce(enumerate(points), IndexedPoint(0, points[0])) {
        (u:IndexedPoint, c:IndexedPoint) -> IndexedPoint in
        return c.point.y < u.point.y ? c : (c.point.y == u.point.y ? (c.point.x <= u.point.x ? c : u) : u)
    }

    points.removeAtIndex(lowest.index)
    points.sort {
        return Turn.turn(lowest.point, $0, $1) <= .None
    }
    points.insert(lowest.point, atIndex:0)
    return points
}

public func grahamScan(var points:[CGPoint], preordered:Bool = false) -> [CGPoint] {
    if points.count <= 3 {
        return points
    }

    if preordered == false {
        points = grahamOrdered(points)
    }

    var hull:[Int] = [0, 1]

    for index in 2..<points.count {
        
        var t:Turn = Turn.Left
        do {
            let p_index = hull[hull.count - 2]
            let p = points[p_index]
            let q_index = hull[hull.count - 1]
            let q = points[q_index]
            let r = points[index]
            t = Turn.turn(p, q, r)
            if t != .Right {
                hull.removeLast()
            }
        } while t != .Right

        hull.push(index)
    }

    let hull_points:[CGPoint] = hull.map {
        return points[$0]
    }

    return hull_points
}
