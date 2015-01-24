//
//  Triangle+Markup.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/24/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

public extension Triangle {
    var markup:[Markup] {
        get {
            var markup:[Markup] = []

            markup.append(Marker(point: points.0, tag: "vertex"))
            markup.append(Marker(point: points.1, tag: "vertex"))
            markup.append(Marker(point: points.2, tag: "vertex"))

//            for control in controls {
//                markup.append(Marker(point: control, tag: "control"))
//            }
//
//            let A = LineSegment(start:start!, end:controls[0])
//            markup.append(Guide(type: .lineSegment(A), tag: "controlLine"))
//
//            let B = LineSegment(start:end, end:controls[1])
//            markup.append(Guide(type: .lineSegment(B), tag: "controlLine"))
//
//            markup.append(Guide(type: .rectangle(Rectangle(frame: boundingBox)), tag: "boundingBox"))
//
//            markup.append(Guide(type: .rectangle(Rectangle(frame: boundingBox)), tag: "simpleBounds"))
            return markup
        }
    }
}
