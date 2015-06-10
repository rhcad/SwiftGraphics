//
//  SketchView.swift
//  Sketch
//
//  Created by Jonathan Wight on 8/30/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics
import SwiftGraphicsPlayground

class SketchView: NSView {

    var rootNode : GroupGeometryNode

    required init?(coder: NSCoder) {

        let path = NSBundle.mainBundle().pathForResource("Test", ofType:"graffle")
        let converter = OmniGraffleLoader(path:path!)
        rootNode = converter.root as! GroupGeometryNode

        super.init(coder:coder)
    }
        
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        NSColor.whiteColor().set()
        NSRectFill(dirtyRect)
        NSColor.blackColor().set()

        let context = NSGraphicsContext.currentContext()!.CGContext
        self.renderNode(context, rect:dirtyRect, node:self.rootNode) {
            (context:CGContext, node:Node) -> Void in
            NSColor.redColor().set()            
        }
    }
    
    func renderNode(context:CGContext, rect:CGRect, node:Node, applyStyleForNode:(context:CGContext, node:Node) -> Void) {
        applyStyleForNode(context: context, node: node)

        if let geometryNode = node as? GeometryNode {
            if rect.intersects(geometryNode.frame) == false {
                return
            }
        }
        
        switch node {
            case let node as CircleNode:
                context.strokeEllipseInRect(node.frame)
            case let node as LineSegmentNode:
                context.strokeLine(node.start, node.end)
            case let node as RectangleNode:
                context.strokeRect(node.frame)
            case  _ as GroupGeometryNode:
                break
            default:
                print("No renderer for \(node)")
        }
        
        if let group = node as? GroupGeometryNode {
            for node in group.children {
                self.renderNode(context, rect:rect, node:node, applyStyleForNode:applyStyleForNode)
            }
        }
    }
    
    override func mouseDown(theEvent: NSEvent) {
        // TODO: Isolate into own code.
        // TODO: Break this up into a ColorMap object
        // Shows how to do per-pixel hit testing by using an offscreen render buffer (bitmap context)   
        let location = self.convertPoint(theEvent.locationInWindow, fromView:nil)

        // We don't need _all_ of view as a bitmap - in fact we only need 1 pixel - but doing lets us dump the buffer to disk with context
        let rect = CGRect(center:location, radius:20)
        
        let context = CGContext.bitmapContext(rect.size)
        
        CGContextConcatCTM(context, CGAffineTransform(tx:-rect.origin.x, ty:-rect.origin.y))
        
        CGContextSetAllowsAntialiasing(context, false)
        
        var colors = Dictionary <UInt32, Node> ()
        
        self.renderNode(context, rect:rect, node:rootNode) {
            (context:CGContext, node:Node) -> Void in

            // TODO: Random is good enough for a demo - not good enough for production.
            let colorInt:UInt32 = UInt32(Random.rng.random(0...0xFFFFFF)) << 8 | 0xFF
            let color = NSColor(rgba:colorInt)
            colors[colorInt] = node
//            print("DEFINING: \(colorInt.toHex()) \(color)")
            CGContextSetStrokeColorWithColor(context, color.CGColor)
            CGContextSetFillColorWithColor(context, color.CGColor)
            CGContextSetLineWidth(context, 4)
        }
        
        let bitmap = Bitmap(
            size:UIntSize(width:UInt(rect.size.width), height:UInt(rect.size.height)),
            bitsPerComponent:8,
            bitsPerPixel:32,
            bytesPerRow:UInt(rect.size.width) * 4,
            ptr:CGBitmapContextGetData(context))
        
        let colorInt = bitmap[UIntPoint(x:UInt(location.x - rect.origin.x), y:UInt(location.y - rect.origin.y))]
//        let color = NSColor(rgba: colorInt)
//        print("SEARCH: \(colorInt.toHex()) \(color)")

        let node = colors[colorInt]
        Swift.print(node)

        
//        let image = context.nsimage
//        image.TIFFRepresentation.writeToFile("/Users/schwa/Desktop/test.tiff", atomically:false)
    }
}

