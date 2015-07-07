//
//  ScratchWindowController.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/1/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

class ScratchWindowController: NSWindowController {

    var model:Model! {
        didSet {
            contentViewController?.representedObject = model
        }
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        model = Model()
    }

    @IBAction func insertShape(sender:AnyObject?) {

        var type:String!
        if let toolbarItem = sender as? NSToolbarItem {
            type = toolbarItem.userInfo as? String
        }
        else if let toolbarItem = sender as? NSMenuItem {
            type = toolbarItem.userInfo as? String
        }

        assert(type != nil)

        var geometry:Thing.ThingType!
        switch type {
            case "rectangle":
                geometry = Rectangle(frame:CGRect(size:CGSize(w:100, h:100)))
            case "circle":
                geometry = Circle(center:CGPoint(x:50, y:50), diameter:100)
            case "triangle":
                geometry = Triangle(rect:CGRect(size:CGSize(w:100, h:100)))
            default:
                break
        }


        var mouseLocation = self.window!.mouseLocationOutsideOfEventStream
        let view = contentViewController!.view
        mouseLocation = view.convertPoint(mouseLocation, fromView: nil)

        mouseLocation = mouseLocation.clampedTo(view.bounds.insetted(dx: 50, dy: 50))

        let thing = Thing(model:model, geometry:geometry)
        thing.center = mouseLocation

        model.addObject(thing)
    }
}
