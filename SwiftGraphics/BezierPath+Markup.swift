//
//  BezierPath+Markup.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics
import SwiftGraphics

public extension BezierCurve {

    var markup:[Markup] {
        get {

            var markup:[Markup] = []

            markup.append(Marker(point: start!, tag: "start"))
            markup.append(Marker(point: end, tag: "end"))
            for control in controls {
                markup.append(Marker(point: control, tag: "control"))
            }

            let A = LineSegment(start:start!, end:controls[0])
            markup.append(Guide(type: .lineSegment(A), tag: "controlLine"))

            let B = LineSegment(start:end, end:controls[1])
            markup.append(Guide(type: .lineSegment(B), tag: "controlLine"))

            markup.append(Guide(type: .rectangle(Rectangle(frame: boundingBox)), tag: "boundingBox"))

            markup.append(Guide(type: .rectangle(Rectangle(frame: boundingBox)), tag: "simpleBounds"))
            return markup
        }
    }
}

//        // Center and foci already include rotation...
//        markup.append(Marker(point: center, tag: "center", style: style1))
//        markup.append(Marker(point: foci.0, tag: "foci", style: style1))
//        markup.append(Marker(point: foci.1, tag: "foci", style: style1))
//
//        let t = CGAffineTransform(rotation: rotation)
//
//        let corners = (
//            center + CGPoint(x:-a, y:-b) * t,
//            center + CGPoint(x:+a, y:-b) * t,
//            center + CGPoint(x:+a, y:+b) * t,
//            center + CGPoint(x:-a, y:+b) * t
//        )
//
//        markup.append(Marker(point: corners.0, tag: "corner", style: style3))
//        markup.append(Marker(point: corners.1, tag: "corner", style: style3))
//        markup.append(Marker(point: corners.2, tag: "corner", style: style3))
//        markup.append(Marker(point: corners.3, tag: "corner", style: style3))
//
//        markup.append(Marker(point: center + CGPoint(x:-a) * t, tag: "-a", style: style3))
//        markup.append(Marker(point: center + CGPoint(x:+a) * t, tag: "+a", style: style3))
//        markup.append(Marker(point: center + CGPoint(y:-b) * t, tag: "-b", style: style3))
//        markup.append(Marker(point: center + CGPoint(y:+b) * t, tag: "+b", style: style3))
//
//        let A = LineSegment(start:center + CGPoint(x:-a) * t, end:center + CGPoint(x:+a) * t)
//        markup.append(Guide(type: .lineSegment(A), tag: "A", style:style2))
//
//        let B = LineSegment(start:center + CGPoint(y:-b) * t, end:center + CGPoint(y:+b) * t)
//        markup.append(Guide(type: .lineSegment(B), tag: "B", style:style2))
//
//        let rect = Polygon(points: [corners.0, corners.1, corners.2, corners.3])
//        markup.append(Guide(type: .polygon(rect), tag: "frame", style:style2))
//
//        markup.append(Guide(type: .rectangle(self.boundingBox), tag: "boundingBox", style:style2))