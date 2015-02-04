//
//  ConvexHull.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

// https://en.wikibooks.org/wiki/Algorithm_Implementation/Geometry/Convex_hull/Monotone_chain
public func monotoneChain(var points:[CGPoint], presorted:Bool = false) -> [CGPoint] {

    if points.count <= 3 {
        return points
    }

    if presorted == false {
        points.sort {
            return $0.x < $1.x ? true : ($0.x == $1.x ? ($0.y < $1.y ? true : false) : false)
        }
    }

    var lower:[CGPoint] = []
    for var i = 0; i < points.count; i++ {
        while lower.count >= 2 && Turn(lower[lower.count - 2], lower[lower.count - 1], points[i]) != .Right {
            lower.removeLast()
        }
        lower.append(points[i])
    }
       
    var upper:[CGPoint] = []
    for var i = points.count - 1; i >= 0; i-- {
        while upper.count >= 2 && Turn(upper[upper.count - 2], upper[upper.count - 1], points[i]) != .Right {
            upper.removeLast()
            }
        upper.append(points[i]);
    }   

    lower.removeLast()
    upper.removeLast()

    let hull = lower + upper

    return hull
}

