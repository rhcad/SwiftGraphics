//
//  Rectangle+Markup.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/1/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

extension Rectangle: Markupable {
    public var markup:[Markup] {
        get {
            var markup:[Markup] = []

            markup.append(Marker(point: frame.minXMinY, tag: "vertex"))
            markup.append(Marker(point: frame.minXMaxY, tag: "vertex"))
            markup.append(Marker(point: frame.maxXMinY, tag: "vertex"))
            markup.append(Marker(point: frame.maxXMaxY, tag: "vertex"))

            return markup
        }
    }
}