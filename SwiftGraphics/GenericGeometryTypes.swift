//
//  IntGeometry.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

// MARK: A generic arithmetic type.

/*
    Note this seems to cause the compiler to get very unhappy when inferring types and complain about. You'll see errors like:
    "error: expression was too complex to be solved in reasonable time; consider breaking up the expression into distinct sub-expressions"
    To fix this specify the type explicitly so the compiler no longer needs to infer.
    Look for this comment to see places where I've had to do this: "(Unnecessarily specify CGFloat to prevent compiler from complaining about complexity while inferring type)"
*/

public protocol ArithmeticType: Comparable {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
}

extension Int: ArithmeticType {
}

extension UInt: ArithmeticType {
}

extension CGFloat: ArithmeticType {
}

// MARK: Protocols with associated types

/*
    Due to a bug with Swift (http://openradar.appspot.com/myradars/edit?id=5241213351362560) we cannot make CG types conform to these protocols.
    Ideally instead of using CGPoint and friends we could just use PointType and our code would work with all types.
*/

public protocol PointType {
    typealias ScalarType
    
    var x:ScalarType { get }
    var y:ScalarType { get }
    }

public protocol SizeType {
    typealias ScalarType
    
    var width:ScalarType { get }
    var height:ScalarType { get }
    }

public protocol RectType {
    typealias OriginType
    typealias SizeType

    var origin:OriginType { get }
    var size:SizeType { get }
    }

// MARK: Generic Points

public struct GenericPoint <T:ArithmeticType> {
    public let x:T
    public let y:T

    public init(x:T, y:T) {
        self.x = x
        self.y = y
    }
}

extension GenericPoint: PointType {
    typealias ScalarType = T
}

// MARK: Generic Sizes

public struct GenericSize <T:ArithmeticType> {
    public let width:T
    public let height:T

    public init(width:T, height:T) {
        self.width = width
        self.height = height
    }
}

extension GenericSize: SizeType {
    typealias ScalarType = T
}

// MARK: Generic Rects

public struct GenericRect <T:PointType, U:SizeType> {
    public let origin:T
    public let size:U

    public init(origin:T, size:U) {
        self.origin = origin
        self.size = size
    }
}

extension GenericRect: RectType {
    typealias OriginType = T
    typealias SizeType = U
}

// MARK: Specialisations of Generic geometric types for Integers.

public typealias IntPoint = GenericPoint<Int>
public typealias IntSize = GenericSize<Int>
public typealias IntRect = GenericRect<IntPoint, IntSize>

public typealias UIntPoint = GenericPoint <UInt>
public typealias UIntSize = GenericSize <UInt>
public typealias UIntRect = GenericRect<UIntPoint, UIntSize>

// MARK: Extensions

extension GenericPoint: Equatable {
}

public func == <T> (lhs:GenericPoint <T>, rhs:GenericPoint <T>) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

extension GenericSize: Equatable {
}

public func == <T> (lhs:GenericSize <T>, rhs:GenericSize <T>) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}

// TODO: Need more generic magic

//extension GenericRect: Equatable {
//}

//public func == <T,U> (lhs:GenericRect <T,U>, rhs:GenericRect <T,U>) -> Bool {
//    return lhs.origin == rhs.origin && lhs.size == rhs.size
//}

