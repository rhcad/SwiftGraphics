//
//  Transforms.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: Printable

extension CGAffineTransform: CustomStringConvertible {
    public var description: String {
        get {
            return "CGAffineTransform(\(a), \(b), \(c), \(d), \(tx), \(ty))"
        }
    }
}

// MARK: Equatable

extension CGAffineTransform: Equatable {
}

public func == (lhs:CGAffineTransform, rhs:CGAffineTransform) -> Bool {
    return CGAffineTransformEqualToTransform(lhs, rhs)
}


// MARK: Constructors

public extension CGAffineTransform {

    static var identity:CGAffineTransform = CGAffineTransformIdentity
    
    /**
     Identity.
     */
    init() {
        self = CGAffineTransform.identity
    }

    /**
     Copy.
     */
    init(transform: CGAffineTransform) {
        self = transform
    }

    /**
     Parameterized.
     */
    init(a: CGFloat, b: CGFloat, c: CGFloat, d: CGFloat, tx: CGFloat, ty: CGFloat) {
        self = CGAffineTransformMake(a, b, c, d, tx, ty)
    }
    
    /**
     Translation.
     */
    init(translation: CGPoint) {
        self = CGAffineTransformMakeTranslation(translation.x, translation.y)
    }

    init(tx: CGFloat, ty: CGFloat) {
        self = CGAffineTransformMakeTranslation(tx, ty)
    }

    /**
     Scale.
     */
    init(scale: CGSize) {
        self = CGAffineTransformMakeScale(scale.width, scale.height)
    }

    init(sx: CGFloat, sy: CGFloat) {
        self = CGAffineTransformMakeScale(sx, sy)
    }

    init(scale: CGFloat) {
        self = CGAffineTransformMakeScale(scale, scale)
    }
    
    init(scale: CGFloat, origin:CGPoint) {
        self = CGAffineTransformMake(scale, 0, 0, scale, (1 - scale) * origin.x, (1 - scale) * origin.y)
    }

    /**
     Rotation

     - parameter angle: Rotation angle in radians.
     */
    init(rotation: CGFloat) {
        self = CGAffineTransformMakeRotation(rotation)
    }

    /**
     Rotation around a point.
     */
    init(rotation: CGFloat, origin:CGPoint) {
        self = CGAffineTransform(translation:-origin) + CGAffineTransform(rotation:rotation) + CGAffineTransform(translation:origin)
    }

    var isIdentity: Bool { get { return CGAffineTransformIsIdentity(self) } }
}

public extension CGAffineTransform {

    func translated(translation  translation:CGPoint) -> CGAffineTransform {
        return CGAffineTransformTranslate(self, translation.x, translation.y)
    }

    func translated(tx  tx:CGFloat, ty:CGFloat) -> CGAffineTransform {
        return CGAffineTransformTranslate(self, tx, ty)
    }

    func scaled(scale  scale:CGSize) -> CGAffineTransform  {
        return CGAffineTransformScale(self, scale.width, scale.height)
    }

    func scaled(sx  sx:CGFloat, sy:CGFloat) -> CGAffineTransform  {
        return CGAffineTransformScale(self, sx, sy)
    }

    func scaled(scale  scale:CGFloat) -> CGAffineTransform  {
        return CGAffineTransformScale(self, scale, scale)
    }
    
    func scaled(scale  scale:CGFloat, origin:CGPoint) -> CGAffineTransform  {
        return self + CGAffineTransform(scale:scale, origin:origin)
    }

    func rotated(angle:CGFloat) -> CGAffineTransform  {
        return CGAffineTransformRotate(self, angle)
    }

    func rotated(rotation:CGFloat, origin:CGPoint) -> CGAffineTransform  {
        return CGAffineTransform(rotation: rotation, origin: origin)
    }

    func concated(other:CGAffineTransform) -> CGAffineTransform {
        return CGAffineTransformConcat(self, other)
    }

    func inverted() -> CGAffineTransform {
        return CGAffineTransformInvert(self)
    }

}

public extension CGAffineTransform {

    mutating func translate(translation:CGPoint) -> CGAffineTransform {
        self = translated(tx:translation.x, ty:translation.y)
        return self
    }

    mutating func translate(tx:CGFloat, _ ty:CGFloat) -> CGAffineTransform {
        self = translated(tx:tx, ty:ty)
        return self
    }

    mutating func scale(scale:CGSize) -> CGAffineTransform  {
        self = scaled(sx:scale.width, sy:scale.height)
        return self
    }

    mutating func scale(sx:CGFloat, _ sy:CGFloat) -> CGAffineTransform  {
        self = scaled(sx:sx, sy:sy)
        return self
    }

    mutating func scale(scale:CGFloat) -> CGAffineTransform  {
        self = scaled(sx:scale, sy:scale)
        return self
    }
    
    mutating func scale(scale:CGFloat, origin:CGPoint) -> CGAffineTransform  {
        self = scaled(scale:scale, origin:origin)
        return self
    }

    mutating func rotate(angle:CGFloat) -> CGAffineTransform  {
        self = rotated(angle)
        return self
    }

    mutating func rotate(angle:CGFloat, origin:CGPoint) -> CGAffineTransform  {
        self = rotated(angle, origin:origin)
        return self
    }

    mutating func concat(other:CGAffineTransform) -> CGAffineTransform {
        self = concated(other)
        return self
    }

    mutating func invert() -> CGAffineTransform {
        self = inverted()
        return self
    }
}

// MARK: Concatination via the + and += operators

public func + (lhs:CGAffineTransform, rhs:CGAffineTransform) -> CGAffineTransform {
    return lhs.concated(rhs)
}

public func += (inout lhs:CGAffineTransform, rhs:CGAffineTransform) {
    lhs.concat(rhs)
}

// MARK: Applying transforms to CG types

public func * (lhs:CGPoint, rhs:CGAffineTransform) -> CGPoint {
    return CGPointApplyAffineTransform(lhs, rhs)
}

public func *= (inout lhs:CGPoint, rhs:CGAffineTransform) {
    lhs = CGPointApplyAffineTransform(lhs, rhs)
}

public func * (lhs:CGSize, rhs:CGAffineTransform) -> CGSize {
    return CGSizeApplyAffineTransform(lhs, rhs)
}

public func *= (inout lhs:CGSize, rhs:CGAffineTransform) {
    lhs = CGSizeApplyAffineTransform(lhs, rhs)
}

public func * (lhs:CGRect, rhs:CGAffineTransform) -> CGRect {
    return CGRectApplyAffineTransform(lhs, rhs)
}

public func *= (inout lhs:CGRect, rhs:CGAffineTransform) {
    lhs = CGRectApplyAffineTransform(lhs, rhs)
}

// MARK: Converting transforms to/from arrays

public extension CGAffineTransform {
    init(v:[CGFloat]) {
        assert(v.count == 6)
        self = CGAffineTransformMake(v[0], v[1], v[2], v[3], v[4], v[5])
    }
    
    var values:[CGFloat] {
        get {
            return [a,b,c,d,tx,ty]
        }
        set(v) {
            assert(v.count == 6)
            (a, b, c, d, tx, ty) = (v[0], v[1], v[2], v[3], v[4], v[6])
        }
    }
}

// MARK: Convenience constructors.

public extension CGAffineTransform {

    init(transforms:[CGAffineTransform]) {
        var current = CGAffineTransform.identity
        for transform in transforms {
            current.concat(transform)
        }
        self = current
    }
    
    // Constructor with two fingers' positions while moving fingers.
    init(from1:CGPoint, from2:CGPoint, to1:CGPoint, to2:CGPoint) {
        if (from1 == from2 || to1 == to2) {
            self = CGAffineTransform.identity
        } else {
            let scale = to2.distanceTo(to1) / from2.distanceTo(from1)
            let angle1 = (to2 - to1).direction, angle2 = (from2 - from1).direction
            self = CGAffineTransform(translation:to1 - from1)
                + CGAffineTransform(scale:scale, origin:to1)
                + CGAffineTransform(rotation:angle1 - angle2, origin:to1)
        }
    }
}

