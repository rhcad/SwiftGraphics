//
//  CGColor.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

#if os(OSX)
import AppKit
#else
import UIKit
#endif

extension CGColor: CustomStringConvertible {
    public var description: String {
        return CFCopyDescription(self) as String
    }
}

public extension CGColor {
    public var alpha:CGFloat {
        return CGColorGetAlpha(self)
    }
}

public extension CGColor {

    class func color(colorSpace colorSpace:CGColorSpace, components:[CGFloat]) -> CGColor! {
        return components.withUnsafeBufferPointer {
            (buffer:UnsafeBufferPointer<CGFloat>) -> CGColor! in
            return CGColorCreate(colorSpace, buffer.baseAddress)
        }
    }

    class func color(red  red:CGFloat, green:CGFloat, blue:CGFloat, alpha:CGFloat = 1.0) -> CGColor! {
#if os(OSX)
        return NSColor(deviceRed:red, green:green, blue:blue, alpha:alpha).CGColor
#else
        return UIColor(red: red, green: green, blue: blue, alpha: alpha).CGColor
#endif
    }

    class func color(white  white:CGFloat, alpha:CGFloat = 1.0) -> CGColor! {
#if os(OSX)
        return NSColor(deviceWhite:white, alpha:alpha).CGColor
#else
        return UIColor(white: white, alpha: alpha).CGColor
#endif
    }


    class func color(hue  hue:CGFloat, saturation:CGFloat, brightness:CGFloat, alpha:CGFloat) -> CGColor! {
#if os(OSX)
        return NSColor(deviceHue: hue, saturation: saturation, brightness: brightness, alpha: alpha).CGColor
#else
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha).CGColor
#endif
    }
}

public extension CGColor {
    func withAlpha(alpha:CGFloat) -> CGColor {
        return CGColorCreateCopyWithAlpha(self, alpha)!
    }
}

public extension CGColorSpace {
#if os(OSX)
    var name:String {
        return CGColorSpaceCopyName(self) as! String
    }
#endif
}

public extension CGColor {

    var colorSpace:CGColorSpaceRef {
        return CGColorGetColorSpace(self)!
    }

    // There's a possibility that these colours dont match UIColor's or NSColor's version (although they are taken from the NSColor header file)
    class func blackColor() -> CGColor { return CGColor.color(white:0) }
    class func darkGrayColor() -> CGColor { return CGColor.color(white:0.333) }
    class func lightGrayColor() -> CGColor { return CGColor.color(white:0.667) }
    class func whiteColor() -> CGColor { return CGColor.color(white:1) }
    class func grayColor() -> CGColor { return CGColor.color(white:0.5) }
    class func redColor() -> CGColor { return CGColor.color(red:1, green:0, blue:0) }
    class func greenColor() -> CGColor { return CGColor.color(red:0, green:1, blue:0) }
    class func blueColor() -> CGColor { return CGColor.color(red:0, green:0, blue:1) }
    class func cyanColor() -> CGColor { return CGColor.color(red:0, green:1, blue:1) }
    class func yellowColor() -> CGColor { return CGColor.color(red:1, green:1, blue:0) }
    class func magnetaColor() -> CGColor { return CGColor.color(red:0, green:1, blue:1) }
    class func orangeColor() -> CGColor { return CGColor.color(red:1, green:0.5, blue:0) }
    class func purpleColor() -> CGColor { return CGColor.color(red:0.5, green:0.0, blue:0.5) }
    class func brownColor() -> CGColor { return CGColor.color(red:0.6, green:0.4, blue:0.2) }
    class func clearColor() -> CGColor { return CGColor.color(white:0.0, alpha:0.0) }
}
