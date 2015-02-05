//
//  Ellipse+Markup.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

extension Ellipse: Markupable {

    public var markup:[Markup] {
        get {
            var markup:[Markup] = []

            // Center and foci already include rotation...
            markup.append(Marker(point: center, tag: "center"))
            markup.append(Marker(point: foci.0, tag: "foci"))
            markup.append(Marker(point: foci.1, tag: "foci"))

            let t = CGAffineTransform(rotation: rotation)

            let corners = (
                center + CGPoint(x:-a, y:-b) * t,
                center + CGPoint(x:+a, y:-b) * t,
                center + CGPoint(x:+a, y:+b) * t,
                center + CGPoint(x:-a, y:+b) * t
            )

            markup.append(Marker(point: corners.0, tag: "corner"))
            markup.append(Marker(point: corners.1, tag: "corner"))
            markup.append(Marker(point: corners.2, tag: "corner"))
            markup.append(Marker(point: corners.3, tag: "corner"))

            markup.append(Marker(point: center + CGPoint(x:-a) * t, tag: "-a"))
            markup.append(Marker(point: center + CGPoint(x:+a) * t, tag: "+a"))
            markup.append(Marker(point: center + CGPoint(y:-b) * t, tag: "-b"))
            markup.append(Marker(point: center + CGPoint(y:+b) * t, tag: "+b"))

            let A = LineSegment(center + CGPoint(x:-a) * t, center + CGPoint(x:+a) * t)
            markup.append(Guide(drawable:A, tag: "A"))

            let B = LineSegment(center + CGPoint(y:-b) * t, center + CGPoint(y:+b) * t)
            markup.append(Guide(drawable:B, tag: "B"))

            let rect = Polygon(points: [corners.0, corners.1, corners.2, corners.3])
            markup.append(Guide(drawable:rect, tag: "frame"))

            markup.append(Guide(drawable:Rectangle(frame:boundingBox), tag: "boundingBox"))

            return markup
        }
    }
}