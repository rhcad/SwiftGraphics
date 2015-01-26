//
//  Silly.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

// TODO: This needs a much better name.
public func tiled(context:CGContext, tileSize:CGSize, dimension:IntSize, origin:CGPoint = CGPoint(x:0.5, y:0.5), block:CGContext -> Void) {

    for y in 0..<dimension.height {
        for x in 0..<dimension.width {

            let frame = CGRect(
                origin:CGPoint(x:CGFloat(x) * tileSize.width, y:CGFloat(y) * tileSize.height),
                size:tileSize
                )

            CGContextSaveGState(context)
            CGContextClipToRect(context, frame)

            let translate = CGPoint(
                x:frame.origin.x + origin.x * tileSize.width,
                y:frame.origin.y + origin.y * tileSize.height
            )

            CGContextTranslateCTM(context, translate.x, translate.y)

            block(context)

            CGContextRestoreGState(context)
        }
    }
}

public func stylesForMarkup(markup:[Markup]) -> [String:SwiftGraphics.Style] {

    let rng = Random(provider: SRandomProvider(seed: 42))

    var styles:[String:SwiftGraphics.Style] = [:]
    for item in markup {
        if let tag = item.tag {
            if let style = styles[tag] {
                // NOP
            }
            else {
                var style = SwiftGraphics.Style()

                let hue:CGFloat = rng.random()
                style.strokeColor = HSV(h: hue, s: 1.0, v: 0.5).cgColor
                styles[tag] = style
            }
        }
    }
    return styles
}
