//
//  HandleEditorView.swift
//  HandleEditor
//
//  Created by Jonathan Wight on 11/10/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

// MARK: -

class Marker {
    var position:CGPoint
    var size:CGSize
    var visible:Bool = true

    init(position:CGPoint) {
        self.position = position
        self.size = CGSize(width:10, height:10)
    }

    var frame:CGRect {
        get { return CGRect(center:position, size:size) }
    }
}

class Handle: Marker, Draggable, Equatable {
    var didMove: ((position:CGPoint) -> Void)?

}

func ==(lhs:Handle, rhs:Handle) -> Bool {
//    return lhs.position == rhs.position
    return lhs.position.x == rhs.position.x && lhs.position.y == rhs.position.y
    }

// MARK: -

class HandleEditor {
    var handles: [Handle] = []
    var drag : Drag

    init() {
        drag = Drag()

        drag.objectForPoint = {
            point in
            for handle in self.handles {
                if handle.frame.contains(point) {
                    return handle
                }
            }
            return nil
            }

        drag.objectDidChange = {
            draggable in
            let handle = draggable as Handle
            handle.didMove?(position:handle.position)
            self.handleDidUpdate?()
            return
            }
        drag.dragDidFinish = {
            self.handleDidUpdate?()
            return
            }
    }
    
    func addHandle(handle:Handle) {
        handles.append(handle)
    }

    func addInteractive(var interactive:Interactive) {
        let handles = interactive.makeHandles()
        for handle in handles {
            self.addHandle(handle)
        }

    }

    var handleDidUpdate: (() -> Void)?
}

protocol Interactive {
    func makeHandles() -> [Handle]
}

// MARK: -

class BoxObject {
    var frame:CGRect

    init(frame:CGRect) {
        self.frame = frame
    }
}

extension BoxObject : Drawable {
    func draw(context:CGContext) {
        self.draw(context)
    }
}

extension BoxObject : Interactive {
    func makeHandles() -> [Handle] {
        let handles = [
            Handle(position: CGPoint(x:frame.minX, y:frame.minY)),
            Handle(position: CGPoint(x:frame.minX, y:frame.maxY)),
            Handle(position: CGPoint(x:frame.maxX, y:frame.maxY)),
            Handle(position: CGPoint(x:frame.maxX, y:frame.minY)),
            ]

        for (index, handle) in enumerate(handles) {
            handle.didMove = {
                position in
                self.updateFromHandles(handles, activeHandleIndex:index)
            }
        }

        return handles
    }

    internal func updateFromHandles(handles:[Handle], activeHandleIndex:Int) {
        switch activeHandleIndex {
            case 0:
                self.frame = CGRect(P1:handles[0].position, P2:handles[2].position);
                handles[1].position = CGPoint(x:handles[0].position.x, y:handles[2].position.y)
                handles[3].position = CGPoint(x:handles[2].position.x, y:handles[0].position.y)
            case 1:
                self.frame = CGRect(P1:handles[1].position, P2:handles[3].position);
                handles[0].position = CGPoint(x:handles[1].position.x, y:handles[3].position.y)
                handles[2].position = CGPoint(x:handles[3].position.x, y:handles[1].position.y)
            case 2:
                self.frame = CGRect(P1:handles[2].position, P2:handles[0].position);
                handles[1].position = CGPoint(x:handles[0].position.x, y:handles[2].position.y)
                handles[3].position = CGPoint(x:handles[2].position.x, y:handles[0].position.y)
            case 3:
                self.frame = CGRect(P1:handles[3].position, P2:handles[1].position);
                handles[0].position = CGPoint(x:handles[1].position.x, y:handles[3].position.y)
                handles[2].position = CGPoint(x:handles[3].position.x, y:handles[1].position.y)
            default:
                break
        }
    }

}

// MARK: -

class LineSegmentObject {
    var lineSegment:LineSegment

    init(start:CGPoint, end:CGPoint) {
        lineSegment = LineSegment(start: start, end: end)
    }
}

extension LineSegmentObject : Interactive {
    func makeHandles() -> [Handle] {
        let startHandle = Handle(position: self.lineSegment.start)
        startHandle.didMove = {
            position in
            self.lineSegment = LineSegment(start:position, end:self.lineSegment.end)
        }
        let endHandle = Handle(position: self.lineSegment.end)
        endHandle.didMove = {
            position in
            self.lineSegment = LineSegment(start:self.lineSegment.start, end:position)
        }
        return [startHandle, endHandle]
    }
}

extension LineSegmentObject : Drawable {
    func draw(context:CGContext) {
        self.lineSegment.draw(context)
    }
}

// MARK: -

class HandleEditorView: NSView, NSGestureRecognizerDelegate {
    var handleEditor = HandleEditor()
    var intersection = Marker(position: CGPointZero)

    var interactives:[Drawable] = []

    override func awakeFromNib() {
        let LSO1 = LineSegmentObject(start: CGPoint(x:100, y:100), end: CGPoint(x:100, y:200))
        interactives.append(LSO1)
        handleEditor.addInteractive(LSO1)

        let box = BoxObject(frame: CGRect(center: CGPoint(x:150, y:150), diameter:50))
        interactives.append(box)
        handleEditor.addInteractive(box)



        handleEditor.handleDidUpdate = { self.needsDisplay = true }
        addGestureRecognizer(handleEditor.drag.panGestureRecogniser)
    }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        let context = NSGraphicsContext.currentContext()!.CGContext

        for thing in interactives {
            thing.draw(context)
        }

        context.setStrokeColor(CGColor.redColor())
        for handle in handleEditor.handles {
            context.strokeCross(handle.frame)
        }
//
//        if intersection.visible {
//            context.setStrokeColor(NSColor.greenColor())
//            context.strokeCross(intersection.frame)
//        }


    }
}
