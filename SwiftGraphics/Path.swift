//
//  Path.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/27/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

public enum PathElement {
    case move(CGPoint)
    case addLine(CGPoint)
    case addCurve(BezierCurve)
    case close
}


public struct Path {

    public var elements:[PathElement] = []
    
    public var currentPoint: CGPoint = CGPointZero

    public init() {
    }

    public mutating func move(point:CGPoint) -> Path {
        currentPoint = point
        elements.append(.move(point))
        return self
    }
    
    public mutating func addLine(point:CGPoint) -> Path {
        currentPoint = point
        elements.append(.addLine(point))
        return self
    }

    public mutating func addCurve(curve:BezierCurve) -> Path {
        currentPoint = curve.end
        elements.append(.addCurve(curve))
        return self
    }

    public mutating func close() -> Path {
        elements.append(.close)
        return self
    }
}

public extension Path {
    init(vertices:[CGPoint], closed:Bool = false) {
        self.init()

        move(vertices[0])
        for vertex in vertices[1..<vertices.count] {
            addLine(vertex)
        }
        if closed {
            close()
        }
    }
}


public extension Path {
    var cgPath:CGPath {
        get {
            var CGPath = CGPathCreateMutable()

            for element in elements {
                switch element {
                    case .move(let point):
                        CGPathMoveToPoint(CGPath, nil, point.x, point.y)
                        break
                    case .addLine(let point):
                        CGPathAddLineToPoint(CGPath, nil, point.x, point.y)
                        break
                    case .addCurve(let curve):

                        switch curve.order {
                            case .Cubic:
                                CGPathAddCurveToPoint(CGPath, nil,
                                    curve.controls[0].x, curve.controls[0].y,
                                    curve.controls[1].x, curve.controls[1].y,
                                    curve.end.x, curve.end.y
                                )
                            case .Quadratic:
                                CGPathAddQuadCurveToPoint(CGPath, nil,
                                    curve.controls[0].x, curve.controls[0].y,
                                    curve.end.x, curve.end.y
                                )
                            default:
                                assertionFailure("Unsupport bezier curve order.")
                                break
                        }

                        break
                    case .close():
                        CGPathCloseSubpath(CGPath)
                        break
                    default:
                        break
                }
            }

            return CGPath
        }
    }
}