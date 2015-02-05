//
//  Circle+Markup.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/1/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import CoreGraphics

extension Circle: Markupable {

    public var markup:[Markup] {
        get {
            var markup:[Markup] = []

            // Center and foci already include rotation...
            markup.append(Marker(point: center, tag: "center"))

            return markup
        }
    }
}