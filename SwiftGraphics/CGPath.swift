//
//  CGPath.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/27/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

public extension CGPathDrawingMode {
    public init(strokeColor:CGColorRef?, fillColor:CGColorRef?, evenOdd:Bool = false) {
        let hasStrokeColor = strokeColor != nil && strokeColor!.alpha > 0.0
        let hasFillColor = fillColor != nil && fillColor!.alpha > 0.0
        switch (Int(hasStrokeColor), Int(hasFillColor), Int(evenOdd)) {
            case (1, 1, 0):
                self = kCGPathFillStroke
            case (0, 1, 0):
                self = kCGPathFill
            case (1, 0, 0):
                self = kCGPathStroke
            case (1, 1, 1):
                self = kCGPathEOFillStroke
            case (0, 1, 1):
                self = kCGPathEOFill
            default:
                assertionFailure("Invalid combination (stroke:\(strokeColor), fill:\(fillColor), evenOdd:\(evenOdd))")
        }
    }
}



public extension CGMutablePath {

    var currentPoint : CGPoint { get { return CGPathGetCurrentPoint(self) } }

    func move(point:CGPoint) -> CGMutablePath {
        CGPathMoveToPoint(self, nil, point.x, point.y)
        return self
    }

    func move(point:CGPoint, relative:Bool) -> CGMutablePath {
        if relative {
            return move(point + currentPoint)
        }
        else {
            return move(point)
        }
    }
    
    func close() -> CGMutablePath {
        CGPathCloseSubpath(self)
        return self
    }

    func addLine(point:CGPoint) -> CGMutablePath {
        CGPathAddLineToPoint(self, nil, point.x, point.y)
        return self
    }

    func addLine(point:CGPoint, relative:Bool) -> CGMutablePath {
        if relative {
            return addLine(point + currentPoint)
        }
        else {
            return addLine(point)
        }
    }

    func addQuadCurveToPoint(end:CGPoint, control1:CGPoint) -> CGMutablePath {
        CGPathAddQuadCurveToPoint(self, nil, control1.x, control1.y, end.x, end.y)
        return self
    }

    func addQuadCurveToPoint(end:CGPoint, control1:CGPoint, relative:Bool) -> CGMutablePath {
        if relative {
            return addQuadCurveToPoint(end + currentPoint, control1:control1 + currentPoint)
        }
        else {
            return addQuadCurveToPoint(end, control1:control1)
        }
    }

    func addCubicCurveToPoint(end:CGPoint, control1:CGPoint, control2:CGPoint) -> CGMutablePath {
        CGPathAddCurveToPoint(self, nil, control1.x, control1.y, control2.x, control2.y, end.x, end.y)
        return self
    }

    func addCubicCurveToPoint(end:CGPoint, control1:CGPoint, control2:CGPoint, relative:Bool) -> CGMutablePath {
        if relative {
            return addCubicCurveToPoint(end + currentPoint, control1:control1 + currentPoint, control2:control2 + currentPoint)
        }
        else {
            return addCubicCurveToPoint(end, control1:control1, control2:control2)
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
    func enumerate(block:(type:CGPathElementType, points:[CGPoint]) -> Void) {
        var curpt = CGPoint()
        var start = curpt
        
        CGPathApplyWithBlock(self) {
            (elementPtr:UnsafePointer<CGPathElement>) -> Void in
            let element : CGPathElement = elementPtr.memory
            
            switch element.type.value {
            case kCGPathElementMoveToPoint.value:
                curpt = element.points.memory
                start = curpt
                block(type:kCGPathElementMoveToPoint, points:[curpt])
                
            case kCGPathElementAddLineToPoint.value:
                let points = [curpt, element.points.memory]
                curpt = points[1]
                block(type:kCGPathElementAddLineToPoint, points:points)
                
            case kCGPathElementAddQuadCurveToPoint.value:
                let cp = element.points.memory
                let end = element.points.advancedBy(1).memory
                let points = [curpt, (curpt + 2 * cp) / 3, (end + 2 * cp) / 3, end]
                block(type:kCGPathElementAddCurveToPoint, points:points)
                curpt = end
                
            case kCGPathElementAddCurveToPoint.value:
                let points = [curpt, element.points.memory,
                    element.points.advancedBy(1).memory,
                    element.points.advancedBy(2).memory]
                block(type:kCGPathElementAddCurveToPoint, points:points)
                curpt = points[3]
            
            case kCGPathElementCloseSubpath.value:
                block(type:kCGPathElementCloseSubpath, points:[curpt, start])
            default:
                println("default")
            }
        }
    }
    
    func getPoint(index:Int) -> CGPoint? {
        var pt:CGPoint?
        var i = 0
        
        enumerate() { (type, points) -> Void in
            switch type.value {
            case kCGPathElementMoveToPoint.value:
                if index == i++ {
                    pt = points[0]
                }
            case kCGPathElementAddLineToPoint.value:
                if index == i++ {
                    pt = points[1]
                }
            case kCGPathElementAddCurveToPoint.value:
                if index >= i && index - i < 3 {
                    pt = points[index - i + 1]
                }
                i = i + 3
            case kCGPathElementCloseSubpath.value:
                println("kCGPathElementCloseSubpath")
            default:
                println("default")
            }
        }
        return pt
    }

    func dump() {
        enumerate() {
            (type:CGPathElementType, points:[CGPoint]) -> Void in
            switch type.value {
            case kCGPathElementMoveToPoint.value:
                println("kCGPathElementMoveToPoint (\(points[0].x),\(points[0].y))")
            case kCGPathElementAddLineToPoint.value:
                println("kCGPathElementAddLineToPoint (\(points[0].x),\(points[0].y))-(\(points[1].x),\(points[1].y))")
            case kCGPathElementAddCurveToPoint.value:
                println("kCGPathElementAddCurveToPoint (\(points[0].x),\(points[0].y))-(\(points[1].x),\(points[1].y))"
                    + ", (\(points[2].x),\(points[2].y))-(\(points[3].x),\(points[3].y))")
            case kCGPathElementCloseSubpath.value:
                println("kCGPathElementCloseSubpath (\(points[0].x),\(points[0].y))-(\(points[1].x),\(points[1].y))")
            default:
                println("default")
            }
        }
    }

}

// MARK: Bounding box and length

public extension CGPath {
    public var boundingBox: CGRect { get { return CGPathGetPathBoundingBox(self) }}
    
    public var length: CGFloat { get {
        var ret:CGFloat = 0.0
        enumerate() {
            (type:CGPathElementType, points:[CGPoint]) -> Void in
            switch type.value {
            case kCGPathElementAddLineToPoint.value, kCGPathElementCloseSubpath.value:
                ret += points[0].distanceTo(points[1])
            case kCGPathElementAddCurveToPoint.value:
                ret += BezierCurve(points:points).length
            default:
                assert(false)
            }
        }
        return ret
    }}
}

// MARK: Get control points and endpoints of path segments

public extension CGPath {
    
    var points: [CGPoint] { get {
        var ret:[CGPoint] = []
        
        enumerate() { (type, points) -> Void in
            switch type.value {
            case kCGPathElementMoveToPoint.value:
                ret.append(points[0])
            case kCGPathElementAddLineToPoint.value:
                ret.append(points[1])
            case kCGPathElementAddCurveToPoint.value:
                [1, 2, 3].map { ret.append(points[$0]) }
            case kCGPathElementCloseSubpath.value:
                println("")
            default:
                println("")
            }
        }
        return ret
    }}
    
    var pointCount: Int { get {
        var ret = 0
        
        enumerate() { (type, points) -> Void in
            switch type.value {
            case kCGPathElementMoveToPoint.value:
                ret = ret + 1
            case kCGPathElementAddLineToPoint.value:
                ret = ret + 1
            case kCGPathElementAddCurveToPoint.value:
                ret = ret + 3
            case kCGPathElementCloseSubpath.value:
                println("")
            default:
                println("")
            }
        }
        return ret
    }}
    
    var isClosed : Bool { get {
        var ret = false
        
        CGPathApplyWithBlock(self) { (elementPtr) -> Void in
            if elementPtr.memory.type.value == kCGPathElementCloseSubpath.value {
                ret = true
            }
        }
        return ret
    }}
}
