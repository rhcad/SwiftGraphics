//
//  DemoView.swift
//  SwiftGraphicsDemo
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

class DemoView: NSView {

    var points: [CGPoint] = []

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        NSColor.whiteColor().set()
        NSRectFill(dirtyRect)
        NSColor.blackColor().set()

        let context = NSGraphicsContext.currentContext()!.CGContext

        for p in self.points {
            context.withColor(CGColor.blackColor()) {
                context.strokeSaltire(CGRect(center:p, size:CGSize(w:4, h:4)))
            }
        }

        context.withColor(CGColor.greenColor()) {
            let hull = convexHull(self.points)
            context.strokeLine(hull, closed:true)
        }

    }

    override func mouseDown(theEvent: NSEvent) {
        let p = self.convertPoint(theEvent.locationInWindow, fromView:nil)
        self.addPoint(p)
    }    

    override func mouseDragged(theEvent: NSEvent) {
        let p = self.convertPoint(theEvent.locationInWindow, fromView:nil)
        self.addPoint(p)
    }    
    
    func addPoint(p:CGPoint) {
        self.points.append(p)
        self.needsDisplay = true
    }
}
