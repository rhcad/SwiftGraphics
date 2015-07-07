//
//  Dragging.swift
//  HandleEditor
//
//  Created by Jonathan Wight on 11/12/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

protocol Draggable {
    var position: CGPoint { get set }
}

class Drag: NSObject, NSGestureRecognizerDelegate {
    var draggedObject:Draggable!
    var offset:CGPoint = CGPointZero
    var panGestureRecogniser:NSPanGestureRecognizer!
    var objectForPoint:((CGPoint) -> (Draggable?))!
    var objectDidChange:((Draggable) -> (Void))!
    var dragDidFinish:((Void) -> (Void))!
    
    override init() {
        super.init()
        panGestureRecogniser = NSPanGestureRecognizer(target: self, action:"pan:")
        panGestureRecogniser.delegate = self
    }

    internal func pan(recognizer:NSPanGestureRecognizer) {
        switch recognizer.state {
            case .Began:
                let location = recognizer.locationInView(recognizer.view)
                draggedObject = objectForPoint(location)
                if draggedObject != nil {
                    offset = location - draggedObject.position
                }
            case .Changed:
                if draggedObject != nil {
                    let location = recognizer.locationInView(recognizer.view)
                    draggedObject.position = location
                    objectDidChange?(draggedObject)
                }
                break
            case .Ended:
                draggedObject = nil
                dragDidFinish?()
            default: 
                break
        }
    }

    func gestureRecognizerShouldBegin(gestureRecognizer: NSGestureRecognizer) -> Bool {
        switch gestureRecognizer {
            case panGestureRecogniser:
                let location = panGestureRecogniser.locationInView(panGestureRecogniser.view)
                return objectForPoint(location) != nil
            default:
                return true
        }
    }
}
