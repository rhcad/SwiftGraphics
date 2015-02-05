//
//  BezierPath+Markup.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

extension BezierCurve: Markupable {
    public var markup:[Markup] {
        get {
            var markup:[Markup] = []

            markup.append(Marker(point: start!, tag: "start"))
            markup.append(Marker(point: end, tag: "end"))
            for control in controls {
                markup.append(Marker(point: control, tag: "control"))
            }

            let A = LineSegment(start!, controls[0])
            markup.append(Guide(drawable:A, tag: "controlLine"))

            let B = LineSegment(end, controls[1])
            markup.append(Guide(drawable:B, tag: "controlLine"))

            markup.append(Guide(drawable:Rectangle(frame: boundingBox), tag: "boundingBox"))

            markup.append(Guide(drawable:Rectangle(frame: boundingBox), tag: "simpleBounds"))
            return markup
        }
    }
}
