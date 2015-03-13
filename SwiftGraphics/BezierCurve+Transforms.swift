//
//  BezierCurve+Transforms.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 3/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

public func * (lhs:BezierCurve, rhs:CGAffineTransform) -> BezierCurve {
    let transformedPoints = lhs.points.map() {
        return $0 * rhs
    }
    return BezierCurve(points: transformedPoints)
}

//public func *= (inout lhs:CGPoint, rhs:CGAffineTransform) {
//    lhs = CGPointApplyAffineTransform(lhs, rhs)
//}
