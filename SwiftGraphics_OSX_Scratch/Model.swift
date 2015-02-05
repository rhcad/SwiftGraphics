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
    dynamic var objects:[Thing] = []
    var selectedObjectIndices:NSMutableIndexSet = NSMutableIndexSet()
    var selectedObjects:[Thing] {
        get {
            var objects:[Thing] = []
            selectedObjectIndices.with(maxCount: 512) {
                for N in $0 {
                    objects.append(self.objects[N])
                }
            }
            return objects
        }
    }

    override init() {
    }

    func hitTest(location:CGPoint) -> (Int, Thing)? {
        for (index, thing) in enumerate(objects) {
            if thing.contains(location) {
                return (index, thing)
            }
        }
        return nil
    }


    func objectselected(thing:Thing) -> Bool {
        let index = find(objects, thing)
        return selectedObjectIndices.containsIndex(index!)
    }

    func selectObject(object:Thing) {
        let index = find(objects, object)
        selectedObjectIndices.addIndex(index!)
    }

    func unselectObject(object:Thing) {
        let index = find(objects, object)
        selectedObjectIndices.removeIndex(index!)
    }


    func addObject(object:Thing) {
        self.objects.append(object)
    }

    func removeObject(object:Thing) {
        let index = find(objects, object)
        removeObjectAtIndex(index!)
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
        get {
            return model!.objectselected(self)
        }
    }

    init(model:Model, geometry:ThingType) {
        self.model = model
        self.geometry = geometry
        self.center = geometry.frame.mid
    }

    var bounds:CGRect { get { return geometry.frame } }

    var center:CGPoint = CGPointZero

    var frame:CGRect { get { return CGRect(center:center, size:bounds.size) } }

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

                let markup = self.geometry.markup
                context.draw(markup)
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
        return geometry.intersects(path)
    }

}

func ==(lhs: Thing, rhs: Thing) -> Bool {
    // TOTO hack
    return lhs === rhs
}
