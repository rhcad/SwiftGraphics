//
//  Scratch.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 6/12/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

//NSSize imgSize = self.bounds.size;
//
//    NSBitmapImageRep * bir = [self bitmapImageRepForCachingDisplayInRect:[self bounds]];
//    [bir setSize:imgSize];
//
//    [self cacheDisplayInRect:[self bounds] toBitmapImageRep:bir];
//
//    NSImage* image = [[[NSImage alloc] initWithSize:imgSize] autorelease];
//    [image addRepresentation:bir];
//
//    return image;


public func tiled(context:CGContext, tileSize:CGSize, dimension:IntSize, @noescape block:CGContext -> Void) {
    for y in 0..<dimension.height {
        for x in 0..<dimension.width {
            context.with() {
                CGContextClipToRect(context, CGRect(size:tileSize))
                let translate = CGPoint(x:x, y:y) * tileSize
                CGContextTranslateCTM(context, translate.x, translate.y)
                block(context)
            }
        }
    }
}


public struct DrawableClosure: Drawable {

    typealias Closure = CGContext -> Void

    let closure: Closure

    init(closure:Closure) {
        self.closure = closure
    }

    public func drawInContext(context:CGContext) {
        closure(context)
    }
}