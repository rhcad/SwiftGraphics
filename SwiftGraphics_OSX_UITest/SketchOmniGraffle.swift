//
//  SketchOmniGraffle.swift
//  Sketch
//
//  Created by Jonathan Wight on 9/2/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

import SwiftGraphics
import SwiftGraphicsPlayground

class OmniGraffleLoader {

    let path:String
    let doc:OmniGraffleDocumentModel
    var root:Node!
    
    init(path:String) {
        self.path = path
        doc = OmniGraffleDocumentModel(path: path)

// TODO: Swift 1.2
        root = convert(doc.rootNode)
    }

    internal func convert(input:OmniGraffleNode) -> Node! {
        switch input {
            case let input as OmniGraffleGroup:
                return convert(input)
            case let input as OmniGraffleShape:
                return convert(input)
            case let input as OmniGraffleLine:
                return convert(input)
            default:
                return nil
        }
    }

    internal func convert(input:OmniGraffleGroup) -> Node! {
        let group = GroupGeometryNode()
        group.children = input.children.map {
            (node:Node) -> Node in
            return self.convert(node as! OmniGraffleNode)
        }
        return group
    }

    internal func convert(input:OmniGraffleShape) -> Node! {
        let shapeName = input.dictionary["Shape"] as! String
        switch shapeName {
            case "Circle":
                let bounds = input.bounds.flipped(.TopLeft, insideRect:doc.frame)
                return CircleNode(center:bounds.mid, radius:bounds.size.width * 0.5)
            case "Rectangle":
                let bounds = input.bounds.flipped(.TopLeft, insideRect:doc.frame)
                return RectangleNode(frame:bounds)
    ////                    case "Bezier":
    ////                        println(d)
    //                        return nil
            default:
                println("Unknown shape: \(shapeName)")
                return nil
        }
    }

    internal func convert(input:OmniGraffleLine) -> Node! {
        let start = input.start.flipped(.TopLeft, insideRect:doc.frame)
        let end = input.end.flipped(.TopLeft, insideRect:doc.frame)

        let shape = LineSegmentNode(start:start, end:end)
        return shape
    }

}