//
//  Dragging.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/3/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

// MARK: -

class Dragging: NSObject {

    var model:Model!
    var clickGestureRecogniser:NSClickGestureRecognizer!
    var panGestureRecognizer:NSPanGestureRecognizer!

    init(model:Model) {
        super.init()

        self.model = model

        clickGestureRecogniser = NSClickGestureRecognizer(target: self, action: Selector("click:"))
        panGestureRecognizer = NSPanGestureRecognizer(target: self, action: Selector("pan:"))
    }

    var view:NSView! {
        willSet {
            if let view = view {
                view.removeGestureRecognizer(clickGestureRecogniser)
                view.removeGestureRecognizer(panGestureRecognizer)
            }
        }
        didSet {
            if let view = view {
                view.addGestureRecognizer(clickGestureRecogniser)
                view.addGestureRecognizer(panGestureRecognizer)
            }
        }
    }

    func click(gestureRecognizer:NSClickGestureRecognizer) {
        switch gestureRecognizer.state {
            case .Began:
                let location = gestureRecognizer.locationInView(view)
                if let (_, thing) = hitTest(location) {
                    unselectAll()
                    selectObject(thing)
                    needsDisplay = true
                    return
                }
                else {
                    unselectAll()
                    needsDisplay = true
                }
            default:
                break
        }
    }

    var draggedObject:Thing? = nil
    var dragBeganLocation:CGPoint?
    var offset:CGPoint = CGPointZero
    var selectionMarquee:SelectionMarquee = SelectionMarquee()


    func pan(gestureRecognizer:NSPanGestureRecognizer) {
        let location = gestureRecognizer.locationInView(view)

        switch gestureRecognizer.state {
            case .Began:
                dragBeganLocation = location
                if let (_, thing) = hitTest(location) {
                    unselectAll()
                    draggedObject = thing
                    selectObject(draggedObject!)
                    offset = location - draggedObject!.center
                }
                else {
                    self.selectionMarquee.active = true
                    self.selectionMarquee.panLocation = location
                    self.view.layer?.addSublayer(self.selectionMarquee.layer)

                }
            case .Changed:
                if let draggedObject = draggedObject {
                    draggedObject.center = location - offset
                }
                else {
                    selectionMarquee.panLocation = location

                    for thing in model.objects {

                        var selected = false

                        switch selectionMarquee.value {
                            case .rect(let rect):
                                selected = thing.intersects(rect)
                            case .polygon(let polygon):
                                selected = thing.intersects(polygon.cgpath)
                            default:
                                break
                        }

                        if selected {
                            selectObject(thing)
                        }
                        else {
                            unselectObject(thing)
                        }
                    }
                    needsDisplay = true
                }
                break
            case .Ended:
                draggedObject = nil
                offset = CGPointZero
                self.selectionMarquee.active = false
                self.selectionMarquee.layer.removeFromSuperlayer()

            default:
                break
        }

        needsDisplay = true
    }


    func selectObject(object:Thing) {
        model.selectObject(object)
    }

    func unselectObject(object:Thing) {
        model.unselectObject(object)
    }

    func unselectAll() {
        model.selectedObjectIndices.removeAllIndexes()
    }

    func hitTest(location:CGPoint) -> (Int,Thing)? {
        return model.hitTest(location)
    }

    var needsDisplay:Bool {
        get {
            return view.needsDisplay
        }
        set {
            view.needsDisplay = newValue
        }
    }


}

