//
//  Utilities.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: Math

infix operator ** { associativity none precedence 160 }

public func ** (lhs:Double, rhs:Double) -> Double {
    if rhs == 2.0 {
        return lhs * lhs
    }    
    return pow(lhs, rhs)
}

public func ** (lhs:CGFloat, rhs:CGFloat) -> CGFloat {
    if rhs == 2.0 {
        return lhs * lhs
    }    
    return pow(lhs, rhs)
}

// MARK: Basics

public func clamp <T:Comparable> (value:T, lower:T, upper:T) -> T {
    return max(min(value, upper), lower)
}

public func round(value:CGFloat, decimal:Int) -> CGFloat {
    let e10n = pow(10.0, CGFloat(clamp(decimal, -6, 7)))
    let fl = floor(e10n * value + 0.5)
    return fl / e10n
}

// MARK: Degrees/Radians

public func DegreesToRadians(v:CGFloat) -> CGFloat {
    return v * CGFloat(M_PI) / 180
}

public func RadiansToDegrees(v:CGFloat) -> CGFloat {
    return v * 180 / CGFloat(M_PI)
}

public func DegreesToRadians(v:Double) -> Double {
    return v * M_PI / 180
}

public func RadiansToDegrees(v:Double) -> Double {
    return v * 180 / M_PI
}

