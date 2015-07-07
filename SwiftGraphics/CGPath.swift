//
//  CGPath.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/27/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

public extension CGPathDrawingMode {
    public init(hasStroke:Bool, hasFill:Bool, evenOdd:Bool = false) {
        switch (Int(hasStroke), Int(hasFill), Int(evenOdd)) {
            case (1, 1, 0):
                self = .FillStroke
            case (0, 1, 0):
                self = .Fill
            case (1, 0, 0):
                self = .Stroke
            case (1, 1, 1):
                self = .EOFillStroke
            case (0, 1, 1):
                self = .EOFill
            default:
                preconditionFailure("Invalid combination (stroke:\(hasStroke), fill:\(hasFill), evenOdd:\(evenOdd))")
        }
    }

    public init(strokeColor:CGColorRef?, fillColor:CGColorRef?, evenOdd:Bool = false) {
        let hasStrokeColor = strokeColor != nil && strokeColor!.alpha > 0.0
        let hasFillColor = fillColor != nil && fillColor!.alpha > 0.0
        self.init(hasStroke: hasStrokeColor, hasFill: hasFillColor, evenOdd: evenOdd)
    }
}



public extension CGMutablePath {

    var currentPoint: CGPoint {
        return CGPathGetCurrentPoint(self)
    }

    func move(point:CGPoint, relative:Bool = false) -> CGMutablePath {
        if relative {
            return move(point + currentPoint)
        }
        else {
            CGPathMoveToPoint(self, nil, point.x, point.y)
            return self
        }
    }
    
    func close() -> CGMutablePath {
        CGPathCloseSubpath(self)
        return self
    }

    func addLine(point:CGPoint, relative:Bool = false) -> CGMutablePath {
        if relative {
            return addLine(point + currentPoint)
        }
        else {
            CGPathAddLineToPoint(self, nil, point.x, point.y)
            return self
        }
    }

    func addLines(points:[CGPoint], relative:Bool = false) -> CGMutablePath {
        for point in points {
            addLine(point, relative:relative)
        }
        return self
    }

    func addQuadCurveToPoint(end:CGPoint, control1:CGPoint, relative:Bool = false) -> CGMutablePath {
        if relative {
            return addQuadCurveToPoint(end + currentPoint, control1:control1 + currentPoint)
        }
        else {
            CGPathAddQuadCurveToPoint(self, nil, control1.x, control1.y, end.x, end.y)
            return self
        }
    }

    func addCubicCurveToPoint(end:CGPoint, control1:CGPoint, control2:CGPoint, relative:Bool = false) -> CGMutablePath {
        if relative {
            return addCubicCurveToPoint(end + currentPoint, control1:control1 + currentPoint, control2:control2 + currentPoint)
        }
        else {
            CGPathAddCurveToPoint(self, nil, control1.x, control1.y, control2.x, control2.y, end.x, end.y)
            return self
        }
    }

    func addCurve(curve:BezierCurve, relative:Bool = false) -> CGMutablePath {
        switch curve.order {
            case .Quadratic:
                if let start = curve.start {
                    move(start)
                }
                return addQuadCurveToPoint(curve.end, control1:curve.controls[0], relative:relative)
            case .Cubic:
                if let start = curve.start {
                    move(start)
                }
                return addCubicCurveToPoint(curve.end, control1:curve.controls[0], control2:curve.controls[1], relative:relative)
            default:
                assert(false)
        }
        return self
    }
}

// MARK: Add smooth curve segment whose start tangent is the end tangent of the previous segment

public extension CGMutablePath {
    func addSmoothQuadCurveToPoint(end:CGPoint) -> CGMutablePath {
        return addQuadCurveToPoint(end, control1: outControlPoint())
    }
    
    func addSmoothQuadCurveToPoint(end:CGPoint, relative:Bool) -> CGMutablePath {
        return addQuadCurveToPoint(end, control1: outControlPoint(), relative:relative)
    }
    
    func addSmoothCubicCurveToPoint(end:CGPoint, control2:CGPoint) -> CGMutablePath {
        return addCubicCurveToPoint(end, control1:outControlPoint(), control2:control2)
    }
    
    func addSmoothCubicCurveToPoint(end:CGPoint, control2:CGPoint, relative:Bool) -> CGMutablePath {
        return addCubicCurveToPoint(end, control1:outControlPoint(), control2:control2, relative:relative)
    }
    
    private func outControlPoint() -> CGPoint {
        let n = pointCount
        return n > 1 ? 2 * currentPoint - getPoint(n - 2)! : currentPoint
    }
}

// MARK: Enumerate path elements

public extension CGPath {

//    typealias ElementPtr = UnsafePointer<CGPathElement>
//    typealias ApplyClosure = ElementPtr -> Void
//    func apply(var closure:ApplyClosure) {
//        var info = UnsafeMutablePointer<ApplyClosure> (&closure)
//        CGPathApply(self, info) {
//            (info:UnsafeMutablePointer<Void>, elementPtr:ElementPtr) -> Void in
//            let closure:ApplyClosure = info.memory
//            closure(elementPtr.memory)
//        }
//    }

    func enumerate(/*@noescape*/ block:(type:CGPathElementType, points:[CGPoint]) -> Void) {
        var curpt = CGPoint()
        var start = curpt

        // TODO: This is limiting noescape
        CGPathApplyWithBlock(self) {
            (elementPtr:UnsafePointer<CGPathElement>) -> Void in
            let element: CGPathElement = elementPtr.memory
            
            switch element.type.rawValue {
            case CGPathElementType.MoveToPoint.rawValue:
                curpt = element.points.memory
                start = curpt
                block(type:CGPathElementType.MoveToPoint, points:[curpt])
                
            case CGPathElementType.AddLineToPoint.rawValue:
                let points = [curpt, element.points.memory]
                curpt = points[1]
                block(type:CGPathElementType.AddLineToPoint, points:points)
                
            case CGPathElementType.AddQuadCurveToPoint.rawValue:
                let cp = element.points.memory
                let end = element.points.advancedBy(1).memory
                let points = [curpt, (curpt + 2 * cp) / 3, (end + 2 * cp) / 3, end]
                block(type:CGPathElementType.AddCurveToPoint, points:points)
                curpt = end
                
            case CGPathElementType.AddCurveToPoint.rawValue:
                let points = [curpt, element.points.memory,
                    element.points.advancedBy(1).memory,
                    element.points.advancedBy(2).memory]
                block(type:CGPathElementType.AddCurveToPoint, points:points)
                curpt = points[3]
            
            case CGPathElementType.CloseSubpath.rawValue:
                block(type:CGPathElementType.CloseSubpath, points:[curpt, start])
            default: ()
            }
        }
    }
    
    func getPoint(index:Int) -> CGPoint? {
        var pt:CGPoint?
        var i = 0
        
        enumerate() { (type, points) -> Void in
            switch type.rawValue {
            case CGPathElementType.MoveToPoint.rawValue:
                if index == i++ {
                    pt = points[0]
                }
            case CGPathElementType.AddLineToPoint.rawValue:
                if index == i++ {
                    pt = points[1]
                }
            case CGPathElementType.AddCurveToPoint.rawValue:
                if index >= i && index - i < 3 {
                    pt = points[index - i + 1]
                }
                i = i + 3
            default: ()
            }
        }
        return pt
    }

    func dump() {
        enumerate() {
            (type:CGPathElementType, points:[CGPoint]) -> Void in
            switch type.rawValue {
            case CGPathElementType.MoveToPoint.rawValue:
                print("kCGPathElementMoveToPoint (\(points[0].x),\(points[0].y))", appendNewline: false)
            case CGPathElementType.AddLineToPoint.rawValue:
                print("kCGPathElementAddLineToPoint (\(points[0].x),\(points[0].y))-(\(points[1].x),\(points[1].y))", appendNewline: false)
            case CGPathElementType.AddCurveToPoint.rawValue:
                print("kCGPathElementAddCurveToPoint (\(points[0].x),\(points[0].y))-(\(points[1].x),\(points[1].y))"
                    + ", (\(points[2].x),\(points[2].y))-(\(points[3].x),\(points[3].y))", appendNewline: false)
            case CGPathElementType.CloseSubpath.rawValue:
                print("kCGPathElementCloseSubpath (\(points[0].x),\(points[0].y))-(\(points[1].x),\(points[1].y))", appendNewline: false)
            default:
                assert(false)
            }
        }
    }
}

// MARK: Bounding box and length

public extension CGPath {
    public var boundingBox: CGRect {
        return CGPathGetPathBoundingBox(self)
    }
    
    public var length: CGFloat {
        var ret:CGFloat = 0.0
        enumerate() {
            (type:CGPathElementType, points:[CGPoint]) -> Void in
            switch type.rawValue {
            case CGPathElementType.AddLineToPoint.rawValue, CGPathElementType.CloseSubpath.rawValue:
                ret += points[0].distanceTo(points[1])
            case CGPathElementType.AddCurveToPoint.rawValue:
                ret += BezierCurve(points:points).length
            default: ()
            }
        }
        return ret
    }
}

// MARK: Get control points and endpoints of path segments

public extension CGPath {
    
    var points: [CGPoint] {
        var ret:[CGPoint] = []
        
        enumerate() { (type, points) -> Void in
            switch type.rawValue {
            case CGPathElementType.MoveToPoint.rawValue:
                ret.append(points[0])
            case CGPathElementType.AddLineToPoint.rawValue:
                ret.append(points[1])
            case CGPathElementType.AddCurveToPoint.rawValue:
                [1, 2, 3].map { ret.append(points[$0]) }
            default: ()
            }
        }
        return ret
    }
    
    var pointCount: Int {
        var ret = 0
        
        enumerate() { (type, points) -> Void in
            switch type.rawValue {
            case CGPathElementType.MoveToPoint.rawValue:
                ret = ret + 1
            case CGPathElementType.AddLineToPoint.rawValue:
                ret = ret + 1
            case CGPathElementType.AddCurveToPoint.rawValue:
                ret = ret + 3
            default: ()
            }
        }
        return ret
    }
    
    var isClosed: Bool {
        var ret = false
        
        CGPathApplyWithBlock(self) { (elementPtr) -> Void in
            if elementPtr.memory.type.rawValue == CGPathElementType.CloseSubpath.rawValue {
                ret = true
            }
        }
        return ret
    }
}

// MARK: End points and tangent vectors

public extension CGPath {
    
    public var startPoint: CGPoint {
        return getPoint(0)!
    }
    
    public var endPoint: CGPoint {
        return getPoint(pointCount - 1)!
    }
    
    public var startTangent: CGPoint {
        return getPoint(1)! - getPoint(0)!
    }
    
    public var endTangent: CGPoint {
        let n = pointCount
        return getPoint(n - 1)! - getPoint(n - 2)!
    }
}
