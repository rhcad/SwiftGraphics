//
//  BouncingBalls.swift
//  Metaballs
//
//  Created by Jonathan Wight on 9/19/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa
import SwiftGraphics
import SwiftUtilities

class Ball {
    var position:CGPoint
    var velocity:CGPoint
    var radius:CGFloat
    var frame:CGRect {
        get { return CGRect(center:position, radius:radius) }
        set { position = newValue.mid }
        }
    var color:NSColor = NSColor.redColor()

    init(position:CGPoint, radius:CGFloat, velocity:CGPoint) {
        self.position = position
        self.radius = radius
        self.velocity = velocity
    }
}

class BouncingBalls {
    var bounds:CGRect
    var balls:[Ball] = []

    init(bounds:CGRect, numberOfBalls:Int) {
        self.bounds = bounds
        for _ in 0..<numberOfBalls {
            let radius = random.random(CGFloat(10)...CGFloat(50))
            let velocity = random.random(CGRect(x:-100, y:-100, width:200, height:200))
            let positionRange = self.bounds.insetted(dx:radius, dy:radius)
            balls.append(Ball(position:random.random(positionRange), radius:radius, velocity:velocity))
        }
    }

    func draw(ctx:CGContext) {
        ctx.with {
            for ball in self.balls {
                ctx.with {
                    ball.color.set()
                    ctx.strokeEllipseInRect(ball.frame)
                }
            }
        }
    }

    func moveBalls(delta:NSTimeInterval) {
        for ball in balls {
            ball.position += ball.velocity * CGFloat(delta)
            if bounds.partiallyIntersects(ball.frame) {
                ball.color = NSColor.greenColor()
                if ball.frame.minX < bounds.minX {
                    ball.velocity.x *= -1
                    ball.frame = CGRect(minX:bounds.minX, minY:ball.frame.minY, maxX:ball.frame.maxX, maxY:ball.frame.maxY)
                }
                else if ball.frame.maxX > bounds.maxX {
                    ball.velocity.x *= -1
                    ball.frame = CGRect(minX:ball.frame.minX, minY:ball.frame.minY, maxX:bounds.maxX, maxY:ball.frame.maxY)
                }

                if ball.frame.minY < bounds.minY {
                    ball.velocity.y *= -1
                    ball.frame = CGRect(minX:ball.frame.minX, minY:bounds.minY, maxX:ball.frame.maxX, maxY:ball.frame.maxY)
                }
                else if ball.frame.maxY > bounds.maxY {
                    ball.velocity.y *= -1
                    ball.frame = CGRect(minX:ball.frame.minX, minY:ball.frame.minY, maxX:ball.frame.maxX, maxY:bounds.maxY)
                }
            }
            else {
                ball.color = NSColor.redColor()
            }
        }
    }
}