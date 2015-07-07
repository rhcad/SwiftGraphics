//
//  Model.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/1/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

import SwiftGraphics

class Model: NSObject {
    @objc var objects:[Thing] = []
    var selectedObjectIndices:NSMutableIndexSet = NSMutableIndexSet()
    var selectedObjects:[Thing] {
        var objects:[Thing] = []
        selectedObjectIndices.with(512) {
            for N in $0 {
                objects.append(self.objects[N])
            }
        }
        return objects
    }

    override init() {
    }

    func hitTest(location:CGPoint) -> (Int, Thing)? {
        for (index, thing) in objects.enumerate() {
            if thing.contains(location) {
                return (index, thing)
            }
        }
        return nil
    }


    func objectSelected(thing:Thing) -> Bool {
        let index = objects.indexOf(thing)
        return selectedObjectIndices.containsIndex(index!)
    }

    func selectObject(object:Thing) {
        let index = objects.indexOf(object)
        selectedObjectIndices.addIndex(index!)
    }

    func unselectObject(object:Thing) {
        let index = objects.indexOf(object)
        selectedObjectIndices.removeIndex(index!)
    }


    func addObject(object:Thing) {
        self.willChangeValueForKey("objects")
        self.objects.append(object)
        self.didChangeValueForKey("objects")
    }

    func removeObject(object:Thing) {
        self.willChangeValueForKey("objects")
        let index = objects.indexOf(object)
        removeObjectAtIndex(index!)
        self.didChangeValueForKey("objects")
    }

    func removeObjectAtIndex(index:Int) {
        objects.removeAtIndex(index)
        selectedObjectIndices.removeIndex(index)
        selectedObjectIndices.shiftIndexesStartingAtIndex(index + 1, by: -1)
    }

    func removeObjectsAtIndices(indices:NSIndexSet) {
        var index = indices.lastIndex
        while index != NSNotFound {
            removeObjectAtIndex(index)
            index = indices.indexLessThanIndex(index)
        }
    }
}

// MARK: -

class Thing: HitTestable, Drawable, Equatable {

    typealias ThingType = protocol <HitTestable, Drawable, Geometry, Markupable, CGPathable>

    weak var model:Model?
    let geometry:ThingType

    var selected: Bool {
        return model!.objectSelected(self)
    }

    init(model:Model, geometry:ThingType) {
        self.model = model
        self.geometry = geometry
        self.center = geometry.frame.mid
    }

    var bounds:CGRect { return geometry.frame }

    var center:CGPoint = CGPointZero

    var frame:CGRect { return CGRect(origin:center, size:bounds.size) }

    func drawInContext(context:CGContextRef) {
        let localTransform = CGAffineTransform(translation: frame.origin)

        context.strokeColor = CGColor.redColor().withAlpha(0.1)
        context.strokeRect(frame)

        context.with(localTransform) {
            context.lineWidth = 1.0
            context.strokeColor = CGColor.blackColor()
            self.geometry.drawInContext(context)

            if self.selected {
                context.lineWidth = 2.0
                context.strokeColor = CGColor.blueColor()
                self.geometry.drawInContext(context)

//                let markup = self.geometry.markup
//                context.draw(markup)
            }
        }
    }

    func contains(point:CGPoint) -> Bool {
        let transformedPoint = point - frame.origin
        return self.geometry.contains(transformedPoint)
    }

    func intersects(rect:CGRect) -> Bool {
        return geometry.intersects(rect.offsetBy(-frame.origin))
    }

    func intersects(path:CGPath) -> Bool {

        var transform = CGAffineTransform(translation: -frame.origin)
//        let ptr = UnsafePointer <CGAffineTransform> (transform)
        let path = CGPathCreateCopyByTransformingPath(path, &transform)
        return geometry.intersects(path!)
    }

}

func ==(lhs: Thing, rhs: Thing) -> Bool {
    // TOTO hack
    return lhs === rhs
}
