//
//  BezierCurve+Transforms.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 3/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

public func * (lhs:BezierCurve, rhs:CGAffineTransform) -> BezierCurve {
    let controls = lhs.controls.map() {
        return $0 * rhs
    }
    if let start = lhs.start {
        return BezierCurve(start:start * rhs, controls: controls, end: lhs.end * rhs)
    }
    else {
        return BezierCurve(controls: controls, end: lhs.end * rhs)
    }
}

//public func *= (inout lhs:CGPoint, rhs:CGAffineTransform) {
//    lhs = CGPointApplyAffineTransform(lhs, rhs)
//}
