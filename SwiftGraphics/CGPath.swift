//
//  CGPath.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/27/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

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
    public var bounds: CGRect { get { return CGPathGetPathBoundingBox(self) }}
    
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
