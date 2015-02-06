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
        get {
            return true
        }
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

        for (index, thing) in enumerate(model.objects) {
            if model.selectedObjectIndices.containsIndex(index) {
                context.strokeColor = CGColor.redColor()
            }
            thing.drawInContext(context)
        }
    }

    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject: AnyObject], context: UnsafeMutablePointer<Void>) {
        // Yup, this is super lazy
        self.needsDisplay = true
    }

}

