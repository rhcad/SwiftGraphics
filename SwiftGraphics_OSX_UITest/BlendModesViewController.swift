//
//  BlendModesViewController.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 6/12/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Cocoa
import SwiftGraphics
import SwiftUtilities

extension CGBlendMode: CustomStringConvertible {
    public var description: String {
        switch self {
            case .Normal: return "Normal"
            case .Multiply: return "Multiply"
            case .Screen: return "Screen"
            case .Overlay: return "Overlay"
            case .Darken: return "Darken"
            case .Lighten: return "Lighten"
            case .ColorDodge: return "ColorBurn"
            case .SoftLight: return "SoftLight"
            case .HardLight: return "HardLight"
            case .Difference: return "Difference"
            case .Exclusion: return "Exclusion"
            case .Hue: return "Hue"
            case .Saturation: return "Saturation"
            case .Color: return "Color"
            case .Luminosity: return "Luminosity"
            case .Clear: return "Clear"
            case .Copy: return "Copy"
            case .SourceIn: return "Source In"
            case .SourceOut: return "Source Out"
            case .SourceAtop: return "Source Atop"
            case .DestinationOver: return "Destination Over"
            case .DestinationIn: return "Destination In"
            case .DestinationOut: return "Destination Out"
            case .DestinationAtop: return "Destination Atop"
            case .XOR: return "XOR"
            case .PlusDarker: return "Plus Darker"
            case .PlusLighter: return "Plus Lighter"
            default:
                preconditionFailure("Not handled")
        }
    }
}

let banana = BlockValueTransformer.register("banana") {
    return KVCBox(value: $0, template: template)
}

var template = KVCGetterTemplate()

class BlendModesViewController: NSViewController {

    var blendModes:[CGBlendMode] = [ .Normal, .Multiply, .Screen, .Overlay, .Darken, .Lighten, .ColorDodge, .SoftLight, .HardLight, .Difference, .Exclusion, .Hue, .Saturation, .Color, .Luminosity, .Clear, .Copy, .SourceIn, .SourceOut, .SourceAtop, .DestinationOver, .DestinationIn, .DestinationOut, .DestinationAtop, .XOR, .PlusDarker, .PlusLighter ]
    dynamic var lazyBlendModes:[KVCBox] = []

    dynamic var selectedBlendModeIndex:Int = 0 {
        didSet {
            selectedBlendeMode = blendModes[selectedBlendModeIndex]
        }
    }

    var selectedBlendeMode:CGBlendMode = .Normal{
        didSet {
            update()
        }
    }

    dynamic var backgroundColor:NSColor = NSColor.clearColor() {
        didSet {
            update()
        }
    }
    dynamic var destinationImage:NSImage? {
        didSet {
            update()
        }
    }
    dynamic var sourceImage:NSImage? {
        didSet {
            update()
        }
    }
    dynamic var fillColor:NSColor = NSColor.clearColor() {
        didSet {
            update()
        }
    }
    dynamic var outputImage:NSImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        template.getters["name"] = { String($0.value) }
        lazyBlendModes = self.blendModes.map() { return KVCBox(value:$0, template:template) }

        sourceImage = NSImage(size:CGSize(w:200, h:200)) {
            (context:CGContext) in
            let t1 = Triangle(CGPoint(x:100,y:0), CGPoint(x:200,y:0), CGPoint(x:100,y:150))
            let style = Style(elements: [StyleElement.fillColor(CGColor.blackColor())])
            context.draw(t1, style:style)
        }

        destinationImage = NSImage(size:CGSize(w:200, h:200)) {
            (context:CGContext) in

            let t1 = Triangle(CGPoint(x:100,y:200), CGPoint(x:200,y:200), CGPoint(x:100,y:0))
            let style = Style(elements: [StyleElement.fillColor(CGColor.yellowColor())])
            context.draw(t1, style:style)
        }

        update()
    }

    func update() {

        if let sourceImage = sourceImage, let destinationImage = destinationImage {

            let frame = CGRect(size: CGSize(w:200, h:200))

            let context = CGContext.bitmapContext(frame)
            context.with() {
                context.fillColor = backgroundColor.CGColor
                context.fillRect(frame)

                CGContextDrawImage(context, frame, destinationImage.cgImage)
                context.alpha = 1.0
                context.fillColor = fillColor.CGColor
                context.blendMode = selectedBlendeMode
                CGContextDrawImage(context, frame, sourceImage.cgImage)
            }

            let cgImage = CGBitmapContextCreateImage(context)!
            outputImage = NSImage(CGImage: cgImage, size: cgImage.size)
        }
    }
}

extension NSImage {
    convenience init(size:CGSize, block:CGContext -> Void) {
        let context = CGContext.bitmapContext(size, color:CGColor.clearColor())
        block(context)
        let cgImage = CGBitmapContextCreateImage(context)!
        self.init(CGImage: cgImage, size: size)
    }
}

extension NSImage {
    var cgImage: CGImage {
        return self.CGImageForProposedRect(nil, context: nil, hints: nil)!.takeUnretainedValue()
    }
}

protocol KVCGetterTemplateProtocol {
    var getters:[String:KVCBox -> AnyObject?] { get }
}

struct KVCGetterTemplate: KVCGetterTemplateProtocol {
    var getters:[String:KVCBox -> AnyObject?] = [:]
}

class KVCBox: NSObject {
    typealias ValueType = Any
    let value:ValueType
    let template:KVCGetterTemplateProtocol

    init(value:ValueType, template:KVCGetterTemplateProtocol) {
        self.value = value
        self.template = template
        super.init()
    }

    override func valueForKey(key: String) -> AnyObject? {
        return template.getters[key]?(self)
    }

}