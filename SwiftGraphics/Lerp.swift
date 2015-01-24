//
//  Lerp.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/23/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

public protocol Subtractable {
    func - (lhs:Self, rhs:Self) -> Self
}

public protocol Lerpable {
    typealias FactorType

    func + (lhs:Self, rhs:Self) -> Self
    func * (lhs:Self, rhs:FactorType) -> Self
}

public func lerp <T:Lerpable, U:Subtractable where U:FloatLiteralConvertible, U == T.FactorType> (lower:T, upper:T, factor:U) -> T {
    return lower * (1.0 - factor) + upper * factor
}

extension Double : Lerpable, Subtractable {
    typealias FactorType = Double
}

extension CGFloat : Lerpable, Subtractable {
    typealias FactorType = CGFloat
}

extension CGPoint : Lerpable {
    typealias FactorType = CGFloat
}

extension CGSize : Lerpable {
    typealias FactorType = CGFloat
}

public func lerp(lower:CGRect, upper:CGRect, factor:CGFloat) -> CGRect {
    return CGRect(
        origin:lerp(lower.origin, upper.origin, factor),
        size:lerp(lower.size, upper.size, factor)
        )
}
