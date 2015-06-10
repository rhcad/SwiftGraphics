//
//  Color.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: RGB

public struct RGB {
    public var r:CGFloat = 0.0
    public var g:CGFloat = 0.0
    public var b:CGFloat = 0.0

    public init(r:CGFloat = 0.0, g:CGFloat = 0.0, b:CGFloat = 0.0) {
        (self.r, self.g, self.b) = (r,g,b)
    }

    public init(tuple:(r:CGFloat, g:CGFloat, b:CGFloat)) {
        (self.r, self.g, self.b) = tuple
    }
}

extension RGB: CustomStringConvertible {
    public var description: String { return "RGB(\(r), \(g), \(b))" }
}

extension RGB: Equatable {

}

public func ==(lhs: RGB, rhs: RGB) -> Bool {
    return lhs.r == rhs.r && lhs.g == rhs.g && lhs.b == rhs.b
}

public extension RGB {
    public var cgColor:CGColor {
        return CGColor.color(red:r, green:g, blue:b)
    }
}

// MARK: HSV

public struct HSV {
    public let h:CGFloat
    public let s:CGFloat
    public let v:CGFloat

    public init(h:CGFloat = 0.0, s:CGFloat = 0.0, v:CGFloat = 0.0) {
        (self.h, self.s, self.v) = (h,s,v)
    }

    public init(tuple:(h:CGFloat, s:CGFloat, v:CGFloat)) {
        (self.h, self.s, self.v) = tuple
    }

    public var toTuple:(CGFloat, CGFloat, CGFloat) {
        get {
            return (h,s,v)
        }
    }
}

extension HSV: CustomStringConvertible {
    public var description: String { return "HSV(\(h), \(s), \(v))" }
}

extension HSV: Equatable {
}

public func ==(lhs: HSV, rhs: HSV) -> Bool {
    return lhs.h == rhs.h && lhs.s == rhs.s && lhs.v == rhs.v
}

public extension HSV {
    public var cgColor:CGColor {
        let rgb = convert(self)
        return rgb.cgColor
    }
}

// MARK: Lerping HSV

extension HSV: Lerpable {
    typealias FactorType = CGFloat
}

public func + (lhs:HSV, rhs:HSV) -> HSV {
    return HSV(h:lhs.h + rhs.h, s:lhs.s + rhs.s, v:lhs.v + rhs.v)
}

public func * (lhs:HSV, rhs:CGFloat) -> HSV {
    return HSV(h:lhs.h * rhs, s:lhs.s * rhs, v:lhs.v * rhs)
}

// TODO: One option? Or just add alpha to colors
//struct HSVA {
//    var hsv:HSV
//    var a:CGFloat
//}
//
//struct RGBA {
//    var rgb:RGB
//    var a:CGFloat
//}

public func convert(hsv:HSV) -> RGB {
    var (h, s, v) = (hsv.h, hsv.s, hsv.v)
    if (s == 0) {
        return RGB(tuple:(v,v,v))
    }
    else {
        h *= 360.0;
        if (h == 360.0) {
            h = 0.0
        }
        else {
            h /= 60
        }
        let i = floor(h)
        let f = h - i
        let p = v * (1.0 - s)
        let q = v * (1.0 - (s * f))
        let t = v * (1.0 - (s * (1.0 - f)))

        switch Int(i) {
            case 0:
                return RGB(tuple:(v,t,p))
            case 1:
                return RGB(tuple:(q,v,p))
            case 2:
                return RGB(tuple:(p,v,t))
            case 3:
                return RGB(tuple:(p,q,v))
            case 4:
                return RGB(tuple:(t,p,v))
            case 5:
                return RGB(tuple:(v,p,q))
            default:
                fatalError("Cannot convert HSV to RGB")
        }
    }
}

public func convert(rgb:RGB) -> HSV {
    let max_ = max(rgb.r, rgb.g, rgb.b)
    let min_ = min(rgb.r, rgb.g, rgb.b)
    let delta = max_ - min_

    var h:CGFloat = 0.0
    let s = max_ != 0.0 ? delta / max_ : 0.0
    let v = max_

    if s == 0.0 {
        h = 0.0
    }
    else {
        if rgb.r == max_ {
            h = (rgb.g - rgb.b) / delta
        }
        else if rgb.g == max_ {
            h = 2 + (rgb.b - rgb.r) / delta
        }
        else if rgb.b == max_ {
            h = 4 + (rgb.r - rgb.g) / delta
        }

        h *= 60
        if h < 0 {
            h += 360
        }
    }

    h /= 360

    return HSV(h:h, s:s, v:v)
}


