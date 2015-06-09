//
//  SwiftGraphicsPlayground.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/15/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import AppKit
import SwiftGraphics

// MARK: Rendering in views

public func SGPRender(identifier:String, showView:((identifier:String, view:NSView) -> Void), block:((ctx:CGContext, bounds:CGRect) -> Void)) -> DemoView {
    let demoView = DemoView(frame:CGRect(size:CGSize(w:480, h:320)))
    demoView.drawBlock = block
    showView(identifier: identifier, view: demoView)
    return demoView
}

public class DemoView : NSView {
    public var drawBlock: ((ctx:CGContext, bounds:CGRect) -> Void)?
    public var tickBlock: ((time:NSTimeInterval, deltaTime:NSTimeInterval, fps:Double) -> Void)? { didSet { displayLink.start() } }
    let displayLink: CDisplayLink = CDisplayLink()

    required public init?(coder: NSCoder) {
        super.init(coder:coder)

        displayLink.displayLinkBlock = {
            (time:NSTimeInterval, deltaTime:NSTimeInterval, fps:Double) in
            self.tick(time:time, deltaTime:deltaTime, fps:fps)
        }
    }

    override public init(frame frameRect: NSRect) {
        super.init(frame:frameRect)

        displayLink.displayLinkBlock = {
            (time:NSTimeInterval, deltaTime:NSTimeInterval, fps:Double) in
            self.tick(time:time, deltaTime:0, fps:0)
        }
    }

    override public func drawRect(dirtyRect: NSRect) {
        let ctx = NSGraphicsContext.currentContext()!.CGContext
        drawBlock?(ctx:ctx, bounds:bounds)
    }

    func tick(time  time:NSTimeInterval, deltaTime:NSTimeInterval, fps:Double) {
        dispatch_async(dispatch_get_main_queue()) {
            self.tickBlock?(time:time, deltaTime: deltaTime, fps:fps)
            self.needsDisplay = true
            return
        }
    }
}