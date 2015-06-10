//
//  Style.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

public struct Style {
    public var fillColor:CGColor?
    public var strokeColor:CGColor?
    public var lineWidth:CGFloat?
    public var lineCap:CGLineCap?
    public var lineJoin:CGLineJoin?
    public var miterLimit:CGFloat?
    public var lineDash:[CGFloat]?
    public var lineDashPhase:CGFloat?
    public var flatness:CGFloat?
    public var alpha:CGFloat?
    public var blendMode:CGBlendMode?

    public init() {
    }
}

public extension Style {
    public static var defaultStyle:Style {
        var style = Style()
        style.fillColor = nil
        style.strokeColor = CGColor.blackColor()
        style.lineWidth = 1.0
//            style.lineCap = kCGLineCapButt
//            style.lineJoin = kCGLineJoinBevel
//            style.miterLimit = 4.0
//            style.lineDash = [1]
//            style.lineDashPhase = 0.0
//            style.flatness = 4
//            style.alpha = 1.0
//            style.blendMode = kCGBlendModeNormal
        return style
    }
}

public enum StyleElement {
    case fillColor(CGColor)
    case strokeColor(CGColor)
    case lineWidth(CGFloat)
    case lineCap(CGLineCap)
    case lineJoin(CGLineJoin)
    case miterLimit(CGFloat)
    case lineDash([CGFloat])
    case lineDashPhase(CGFloat)
    case flatness(CGFloat)
    case alpha(CGFloat)
    case blendMode(CGBlendMode)
}

var CGContext_Style_Key = 1

public extension CGContext {
    var style: Style {
        get {
            let style = getAssociatedWrappedObject(self, key: &CGContext_Style_Key) as! Style?
            if let style = style {
                return style
            }
            else {
                let style = Style.defaultStyle
                setAssociatedWrappedObject(self, key: &CGContext_Style_Key, value: style)
                return style
            }
        }
        set {
            setAssociatedWrappedObject(self, key: &CGContext_Style_Key, value: newValue)
            apply(newValue)
        }
    }

    func apply(newStyle:Style) {
        if let fillColor = newStyle.fillColor {
            setFillColor(fillColor)
        }
        if let strokeColor = newStyle.strokeColor {
            setStrokeColor(strokeColor)
        }
        if let lineWidth = newStyle.lineWidth {
            setLineWidth(lineWidth)
        }
        if let lineCap = newStyle.lineCap {
            setLineCap(lineCap)
        }
        if let lineJoin = newStyle.lineJoin {
            setLineJoin(lineJoin)
        }
        if let miterLimit = newStyle.miterLimit {
            setMiterLimit(miterLimit)
        }
        if let lineDash = newStyle.lineDash {
            if let lineDashPhase = newStyle.lineDashPhase {
                setLineDash(lineDash, phase: lineDashPhase)
            } else {
                setLineDash(lineDash, phase: 0.0)
            }
        }
        if let flatness = newStyle.flatness {
            setFlatness(flatness)
        }
        if let alpha = newStyle.alpha {
            setAlpha(alpha)
        }
        if let blendMode = newStyle.blendMode {
            setBlendMode(blendMode)
        }
    }
}

public extension CGContext {

    var fillColor:CGColor? {
        get {
            return style.fillColor
        }
        set {
            assert(newValue != nil)
            style.fillColor = newValue
            setFillColor(newValue!)
        }
    }

    var strokeColor:CGColor? {
        get {
            return style.strokeColor
        }
        set {
            assert(newValue != nil)
            style.strokeColor = newValue
            setStrokeColor(newValue!)
        }
    }

    var lineWidth:CGFloat? {
        get {
            return style.lineWidth
        }
        set {
            assert(newValue != nil)
            style.lineWidth = newValue
            setLineWidth(newValue!)
        }
    }

    var lineCap:CGLineCap? {
        get {
            return style.lineCap
        }
        set {
            assert(newValue != nil)
            style.lineCap = newValue
            setLineCap(newValue!)
        }
    }

    var lineJoin:CGLineJoin? {
        get {
            return style.lineJoin
        }
        set {
            assert(newValue != nil)
            style.lineJoin = newValue
            setLineJoin(newValue!)
        }
    }

    var lineDash:[CGFloat]? {
        get {
            return style.lineDash
        }
        set {
            assert(newValue != nil)
            style.lineDash = newValue
            setLineDash(newValue!)
        }
    }

    var lineDashPhase:CGFloat? {
        get {
            return style.lineDashPhase
        }
        set {
            assert(newValue != nil)
            style.lineDashPhase = newValue
            // TODO
        }
    }

    var flatness:CGFloat? {
        get {
            return style.flatness
        }
        set {
            assert(newValue != nil)
            style.flatness = newValue
            setFlatness(newValue!)
        }
    }

    var alpha:CGFloat? {
        get {
            return style.alpha
        }
        set {
            assert(newValue != nil)
            style.alpha = newValue
            setAlpha(newValue!)
        }
    }

    var blendMode:CGBlendMode? {
        get {
            return style.blendMode
        }
        set {
            assert(newValue != nil)
            style.blendMode = newValue
            setBlendMode(newValue!)
        }
    }

}

public extension Style {
    mutating func add(element:StyleElement) {
        switch element {
            case .fillColor(let value):
                fillColor = value
            case .strokeColor(let value):
                strokeColor = value
            case .lineWidth(let value):
                lineWidth = value
            case .lineCap(let value):
                lineCap = value
            case .lineJoin(let value):
                lineJoin = value
            case .miterLimit(let value):
                miterLimit = value
            case .lineDash(let value):
                lineDash = value
            case .lineDashPhase(let value):
                lineDashPhase = value
            case .flatness(let value):
                flatness = value
            case .alpha(let value):
                alpha = value
            case .blendMode(let value):
                blendMode = value
// TODO: add more styles here
//            default:
//                assert(false)
        }
    }

    mutating func add(elements:[StyleElement]) {
        for element in elements {
            add(element)
        }
    }

    init(elements:[StyleElement]) {
        add(elements)
    }
}

public extension CGContext {

    func with(elements:[StyleElement], @noescape block:() -> Void) {
        let style = Style(elements: elements)
        with(style, block: block)
    }

    func with(style:Style, @noescape block:() -> Void) {
        let savedStyle = self.style
        self.style = style
        with() {
            block()
        }
        self.style = savedStyle
    }
}
