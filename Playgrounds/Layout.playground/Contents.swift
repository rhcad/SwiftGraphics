//: Playground - noun: a place where people can play

import Cocoa
import SwiftGraphics
import SwiftUtilities

public struct DrawableClosure: Drawable {

    typealias Closure = CGContext -> Void

    let closure: Closure

    init(closure:Closure) {
        self.closure = closure
    }

    public func drawInContext(context:CGContext) {
        closure(context)
    }
}

protocol Sizeable {
    var size:CGSize { get }
}

protocol Frameable: Sizeable {
    var frame:CGRect { get }
}

extension Frameable {
    var size:CGSize {
        return frame.size
    }
}

extension Circle: Frameable {
    var frame:CGRect {
        return CGRect(center: center, radius: radius)
    }
}

extension CGContext {
    func with(transform:CGAffineTransform, block:Void -> Void) {
        with() {
            CGContextConcatCTM(self, transform)
            block()
        }
    }
}

extension SequenceType where Self.Generator.Element : Drawable, Self.Generator.Element : Frameable {
    func row() -> Drawable {
        return DrawableClosure() {
            (context:CGContext) in
            var offset = CGPointZero
            for object in GeneratorSequence(self.generate()) {
                context.with(CGAffineTransform(translation:offset - object.frame.origin)) {
                    context.draw(object)
                    offset.x += object.size.width
                }
            }
        }
    }
}

func row <T:Drawable where T:Frameable> (objects:[T]) -> Drawable {
    return DrawableClosure() {
        (context:CGContext) in
        var offset = CGPointZero
        for object in objects {
            context.with(CGAffineTransform(translation:offset - object.frame.origin)) {
                context.draw(object)
                offset.x += object.size.width
            }
        }
    }
}

let circles = [
    Circle(radius: 50),
    Circle(radius: 20),
    Circle(radius: 10),
    ]

//let drawable = row(circles)
let drawable = circles.row()

var frame = circles.reduce(CGRectZero) {
    return $0.rectByUnion(CGRect(origin:$0.maxXMinY, size:$1.frame.size))
}
let context = CGContextRef.bitmapContext(frame)

context.draw(drawable)

context.nsimage
