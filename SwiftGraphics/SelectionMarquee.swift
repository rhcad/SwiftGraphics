//
//  SelectionMarquee.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/3/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import QuartzCore

public class SelectionMarquee {
    public enum Mode {
        case rectangular
        case polygonal
    }
    public enum Value {
        case empty
        case rect(CGRect)
        case polygon(Polygon)

        var polygon:Polygon? {
            get {
                switch self {
                    case .polygon(let polygon):
                        return polygon
                    default:
                        return nil
                }
            }
        }
    }

    public var mode = Mode.polygonal
    public var value = Value.empty

    public var layer:CAShapeLayer

    public init() {
        active = false
        layer = CAShapeLayer()
        layer.fillColor = CGColor.blueColor().withAlpha(0.1)
        layer.strokeColor = CGColor.whiteColor().withAlpha(0.9)
        layer.lineWidth = 1.0
    }

    public var active:Bool {
        didSet {
            if active == false {
                panBeganLocation = nil
                panLocation = nil
                value = .empty
                layer.path = nil
            }
        }
    }

    public var panBeganLocation:CGPoint!
    public var panLocation:CGPoint! {
        didSet {
            if active == false {
                return
            }

            if panBeganLocation == nil {
                panBeganLocation = panLocation
            }

            let selectionFrame = CGRect(p1:panBeganLocation, p2:panLocation)

            var newPath:CGPath!
            var newFrame:CGRect!

            switch mode {
                case .rectangular:
                    value = Value.rect(selectionFrame)
                    newPath = CGPathCreateWithRect(selectionFrame.offsetBy(-selectionFrame.origin), nil)
                    newFrame = selectionFrame
                case .polygonal:
                    let polygon = value.polygon
                    var points = polygon?.points ?? []

                    points.append(panLocation)
                    points = monotoneChain(points, sorted:false)

                    let new_polygon = Polygon(points:points)
                    value = Value.polygon(new_polygon)
                    newPath = new_polygon.cgpath
                    newFrame = CGRect(x:0, y:0, w:1000, h:1000) // TODO: Total hack
            }


            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.path = newPath
            layer.frame = newFrame
            CATransaction.commit()
        }
    }

}