//
//  ScratchView.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/25/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

class ScratchView: NSView {

    var model:Model! {
        didSet {
            model.addObserver(self, forKeyPath: "objects", options: NSKeyValueObservingOptions(), context: nil)
            dragging = Dragging(model:model)
            dragging.view = self
        }
    }
    var dragging:Dragging!

    required init?(coder: NSCoder) {
        super.init(coder:coder)
        wantsLayer = true
    }

    override var acceptsFirstResponder:Bool {
        return true
    }

    override func keyDown(theEvent: NSEvent) {
        interpretKeyEvents([theEvent])
    }

    override func deleteBackward(sender: AnyObject?) {
        model.removeObjectsAtIndices(model.selectedObjectIndices)
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        let context = NSGraphicsContext.currentContext()!.CGContext

        for (index, thing) in model.objects.enumerate() {
            if model.selectedObjectIndices.containsIndex(index) {
                context.strokeColor = CGColor.redColor()
            }
            thing.drawInContext(context)
        }

//        context.plotPoints(locations)
        if let startLocation = startLocation, currentLocation = currentLocation {
            context.strokeColor = CGColor.redColor()
            context.lineWidth = 1.0
            context.lineDash = [10, 10]
            context.strokeLine(startLocation, currentLocation)
            context.lineDash = []
        }
    }

    var locations:[CGPoint] = []
    var startLocation:CGPoint?
    var currentLocation:CGPoint?


    override func addGestureRecognizer(gestureRecognizer: NSGestureRecognizer) {
        super.addGestureRecognizer(gestureRecognizer)

        if gestureRecognizer.isKindOfClass(NSPanGestureRecognizer.self) {
            gestureRecognizer.addCallback() {
                [unowned self] in
                let location = gestureRecognizer.locationInView(self)


                switch gestureRecognizer.state {
                    case .Began:
                        self.startLocation = location
                        MagicLog("startLocation", location)
                    case .Changed:
                        MagicLog("location", location)
                        let delta = location - self.startLocation!
                        MagicLog("delta", location - delta)

                        let angle = atan2(delta)
//                        self.startLocation!.angleTo(location))

                        MagicLog("angle", RadiansToDegrees(angle))

                        self.currentLocation = location
                    default:
                        break
                }
                self.locations.append(location)
                self.needsDisplay = true
            }
        }
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [NSObject: AnyObject]?, context: UnsafeMutablePointer<Void>) {
        // Yup, this is super lazy
        self.needsDisplay = true
    }

}

