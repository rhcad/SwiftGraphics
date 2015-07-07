//
//  MetaballsView.swift
//  Metaballs
//
//  Created by Jonathan Wight on 9/14/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics
import SwiftUtilities

class MetaballsView: NSView {

    var displayLink = CDisplayLink()
    var playing:Bool = false
    var resolution:CGFloat = 10
    var marchingSquares: MarchingSquares!
    var bouncingBalls: BouncingBalls!
    var fps: Double = 0
    var fieldSize: IntSize! {
        didSet {
            marchingSquares = MarchingSquares(size:fieldSize, resolution:resolution)
            marchingSquares.magnitudeClosure = self.magnitudeAtPoint
        }
    }

    required init?(coder: NSCoder) {

        super.init(coder:coder)

        let width = Int(ceil(self.bounds.size.width / resolution)) + 1
        let height = Int(ceil(self.bounds.size.height / resolution)) + 1
        fieldSize = IntSize(width:width, height:height)

        bouncingBalls = BouncingBalls(bounds:self.bounds, numberOfBalls:10)
        marchingSquares = MarchingSquares(size:fieldSize, resolution:resolution)
        marchingSquares.magnitudeClosure = self.magnitudeAtPoint

        self.displayLink.displayLinkBlock = {
            (time:NSTimeInterval, deltaTime:NSTimeInterval, fps:Double) in
            self.tick(deltaTime, fps)
        }

        displayLink.start()
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        let context = NSGraphicsContext.currentContext()!.CGContext
        if let marchingSquares = marchingSquares {
            marchingSquares.drawMagnitudeGrid(context)
            marchingSquares.render(context)
        }
        bouncingBalls.draw(context)

        
        context.drawLabel("\(Int(fps))", point:CGPoint(x:20,y:20), size:18)
    }

    override func setFrameSize(newSize: NSSize) {
        super.setFrameSize(newSize)

        let width = Int(ceil(self.bounds.size.width / resolution)) + 1
        let height = Int(ceil(self.bounds.size.height / resolution)) + 1
        fieldSize = IntSize(width:width, height:height)

        bouncingBalls.bounds = self.bounds
    }

    override func mouseDown(theEvent: NSEvent) {
        self.playing = self.playing ? false : true
    }
    
    func magnitudeAtPoint(point:CGPoint) -> CGFloat {
        let magnitude:CGFloat = self.bouncingBalls.balls.reduce(0.0) {
            (u:CGFloat, ball:Ball) -> CGFloat in
            return u + ball.radius ** 2 / ((point.x - ball.position.x) ** 2 + (point.y - ball.position.y) ** 2)
        }
        return magnitude
    }

    func compute(delta:NSTimeInterval) {
        if self.playing == false {
            return
        }
        self.bouncingBalls.moveBalls(delta)
        if let marchingSquares = marchingSquares {
            marchingSquares.update()
        }
        self.needsDisplay = true
    }

    func tick(delta:NSTimeInterval, _ fps:Double) {
        dispatch_sync(dispatch_get_main_queue()) {
            self.fps = fps
            self.compute(delta)
        }
    }
}







