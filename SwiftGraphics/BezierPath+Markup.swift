//
//  BezierPath+Markup.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

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
            markup.append(Guide(drawable:A, tag: "controlLine"))

            let B = LineSegment(start:end, end:controls[1])
            markup.append(Guide(drawable:B, tag: "controlLine"))

            markup.append(Guide(drawable:Rectangle(frame: boundingBox), tag: "boundingBox"))

            markup.append(Guide(drawable:Rectangle(frame: boundingBox), tag: "simpleBounds"))
            return markup
        }
    }
}
