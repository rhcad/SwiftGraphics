//
//  MarchingSquares.swift
//  Metaballs
//
//  Created by Jonathan Wight on 9/18/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa
import SwiftGraphics
import SwiftUtilities

func NOP() {
}

class MarchingSquares {
    var size:IntSize
    var resolution:CGFloat
    var threshold:CGFloat = 1
    var points:[CGPoint] = []
    var magnitudeGrid: Grid_Buffer <CGFloat>!
    var magnitudeClosure:((point:CGPoint) -> CGFloat)!

    init(size:IntSize, resolution:CGFloat) {
        self.size = size
        self.resolution = resolution
    }
    
    func render(ctx:CGContext) {
        // Yup!
  
        ctx.strokeLines(points)
    }
    
    func drawMagnitudeGrid(ctx:CGContext) {
        if magnitudeGrid == nil {
            return
        }
        for X in 0..<size.width {
            for Y in 0..<size.height {
                let point = CGPoint(x:CGFloat(X), y:CGFloat(Y)) * resolution
                let magnitude = magnitudeGrid[IntPoint(x:X,y:Y)]
                if magnitude < 0.2 {
                    continue
                }
                
                let hue:CGFloat = magnitude >= threshold ? 1.0 : 0.8
                
                ctx.fillColor = CGColor.color(hue:hue, saturation:1.0, brightness:1.0, alpha:magnitude)
                ctx.fillCircle(center:point, radius:1.5)
            }
        }
    }
    
    func magnitudeForPoint(point:CGPoint) -> CGFloat {
        if point.x != floor(point.x) || point.y != floor(point.y) {
            return magnitudeClosure(point: point)
        }
        else {
            let x = Int(point.x / resolution)
            let y = Int(point.y / resolution)
            return magnitudeGrid[IntPoint(x:x,y:y)]
        }
    }
    
    func magnitudeForCell(cell:IntPoint) -> CGFloat {
        return magnitudeGrid[cell]
    }

    func update() {
    
        magnitudeGrid = Grid_Buffer <CGFloat>(width:size.width, height:size.height, defaultValue:0.0)
        for X in 0..<size.width {
            for Y in 0..<size.height {
                let point = CGPoint(x:CGFloat(X), y:CGFloat(Y)) * resolution
                magnitudeGrid[IntPoint(x:X,y:Y)] = magnitudeClosure(point:point)
            }
        }
    
        points = []

        let cellSize = CGSize(width:resolution, height:resolution)
        
        var edges: [Edge] = []
        
        for X in 0..<(size.width - 1) {
            for Y in 0..<(size.height - 1) {
                let offset = CGPoint(x:CGFloat(X), y:CGFloat(Y)) * resolution

// TODO: Swift 2 - dead code
//                let A = magnitudeForCell(IntPoint(x:X, y:Y))
//                let B = magnitudeForCell(IntPoint(x:X + 1, y:Y))
//                let C = magnitudeForCell(IntPoint(x:X, y:Y + 1))
//                let D = magnitudeForCell(IntPoint(x:X + 1, y:Y + 1))

//                let CENTRUM = Int(magnitudeForPoint[(X + 0.5, Y + 0.5)] >= filter)

                let pointsCell = pointsForCell((X,Y), size:cellSize)
                switch pointsCell {
                    case .None:
                        NOP()
                    case .Single(let P1, let P2):
                        points.append(P1 + offset)
                        points.append(P2 + offset)
                        edges.append(Edge(start: P1 + offset, end: P2 + offset))
                    case .Double(let P1, let P2, let P3, let P4):
                        points.append(P1 + offset)
                        points.append(P2 + offset)
                        edges.append(Edge(start: P1 + offset, end: P2 + offset))
                        points.append(P3 + offset)
                        points.append(P4 + offset)
                        edges.append(Edge(start: P3 + offset, end: P4 + offset))
                }
            }
        }
        
//        Polygon.constructPolygonsFromUnconnectedEdges(edges)
    }


    enum PointCell {
        case None
        case Single(CGPoint, CGPoint)
        case Double(CGPoint, CGPoint, CGPoint, CGPoint)
    }

    func pointsForCell(cell:(x:Int, y:Int), size:CGSize) -> PointCell {
        func filter(magnitude:CGFloat) -> Bit {
            return magnitude >= threshold ? .One : .Zero
        }

        let (X,Y) = cell
        let A = clamp(magnitudeForCell(IntPoint(x:X, y:Y)), lower: 0, upper: 1)
        let B = clamp(magnitudeForCell(IntPoint(x:X + 1, y:Y)), lower: 0, upper: 1)
        let C = clamp(magnitudeForCell(IntPoint(x:X + 1, y:Y + 1)), lower: 0, upper: 1)
        let D = clamp(magnitudeForCell(IntPoint(x:X, y:Y + 1)), lower: 0, upper: 1)

        let (MINX, MIDX, MAXX) = (0.0 * size.width, 0.5 * size.width, 1.0 * size.width)
        let (MINY, MIDY, MAXY) = (1.0 * size.height, 0.5 * size.height, 0.0 * size.height)

        let (a,b,c,d) = (filter(A), filter(B), filter(C), filter(D))

        func ab() -> CGPoint { return CGPoint(x:MIDX, y:MAXY) }
        func bc() -> CGPoint { return CGPoint(x:MAXX, y:MIDY) }
        func cd() -> CGPoint { return CGPoint(x:MINX, y:MIDY) }
        func da() -> CGPoint { return CGPoint(x:MIDX, y:MINY) }

//        func ab() -> CGPoint { return CGPoint(x:lerp(0, 1, (A + B) * 0.5) * size.width, y:MAXY) }
//        func bc() -> CGPoint { return CGPoint(x:MAXX, y:lerp(1, 0, (B + C) * 0.5) * size.height) }
//        func cd() -> CGPoint { return CGPoint(x:MINX, y:lerp(1, 0, (C + D) * 0.5) * size.height) }
//        func da() -> CGPoint { return CGPoint(x:lerp(0, 1, (D + A) * 0.5) * size.width, y:MINY) }

        switch (a,b,c,d) {
            case (.Zero, .Zero, .Zero, .Zero): // 0
                return .None
            case (.Zero, .Zero, .Zero, .One): // 1
                return .Single(cd(), da())
            case (.Zero, .Zero, .One, .Zero): // 2
                return .Single(da(), bc())
            case (.Zero, .Zero, .One, .One): // 3
                return .Single(cd(), bc())
            case (.Zero, .One, .Zero, .Zero): // 4
                return .Single(ab(), bc())
            case (.Zero, .One, .Zero, .One): // 5
                // TODO: This assumes. Need to query midpoint
                return .Double(cd(), ab(), da(), bc())
            case (.Zero, .One, .One, .Zero): // 6
                return .Single(ab(), da())
            case (.Zero, .One, .One, .One): // 7
                return .Single(cd(), ab())
            case (.One, .Zero, .Zero, .Zero): // 8
                return .Single(cd(), ab())
            case (.One, .Zero, .Zero, .One): // 9
                return .Single(da(), ab())
            case (.One, .Zero, .One, .Zero): // 10
                // TODO: This assumes. Need to query midpoint
                return .Double(cd(), da(), ab(), bc())
            case (.One, .Zero, .One, .One): // 11
                return .Single(ab(), bc())
            case (.One, .One, .Zero, .Zero): // 12
                return .Single(cd(), bc())
            case (.One, .One, .Zero, .One): // 13
                return .Single(da(), bc())
            case (.One, .One, .One, .Zero): // 14
                return .Single(cd(), da())
            case (.One, .One, .One, .One):
                return .None
        }
    }
}