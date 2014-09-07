//
//  OmniGraffle.swift
//  Sketch
//
//  Created by Jonathan Wight on 8/31/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

class OmniGraffleNode : NSObject, Node {
    weak var parent : Node?
    var dictionary: NSDictionary!
    var ID:String { get { return dictionary["ID"]!.stringValue } }
}

class OmniGraffleGroup : OmniGraffleNode, GroupNode {
    var children : [Node] = []
    
    init(children:[Node]) {
        self.children = children
    }
}

class OmniGraffleShape : OmniGraffleNode {
    var shape:String { get { return dictionary["Shape"] as String } }
    var bounds:CGRect { get { return StringToRect(dictionary["Bounds"] as String) } }
}

class OmniGraffleLine : OmniGraffleNode {
    var start:CGPoint {
        get {
            let strings = dictionary["Points"] as [String]
            return StringToPoint(strings[0])
        }
    }
    var end:CGPoint {
        get {
            let strings = dictionary["Points"] as [String]
            return StringToPoint(strings[1])
        }
    }
    var head:OmniGraffleNode?
    var tail:OmniGraffleNode?
}

//extension NSDictionary {
//
//    subscript (keys:NSArray) -> AnyObject? { get {
//    
//        var d:AnyObject? = self
//        
//        for key in keys {
//            if d == nil {
//                return d
//            }
//            d = d![key]
//        }
//        return d
//    } }
//}

class OmniGraffleDocumentModel {
    let path: String
    var frame: CGRect!
    var rootNode: OmniGraffleGroup!
    var nodesByID: [String:OmniGraffleNode] = [:]
    
    init(path: String) {
        self.path = path
        self.load()
    }

    func load() {
        let data = NSData(contentsOfCompressedFile:path)
        var error:NSString?
        let d = NSPropertyListSerialization.propertyListFromData(data, mutabilityOption: NSPropertyListMutabilityOptions(), format: nil, errorDescription:&error) as NSDictionary!
        self._processRoot(d)
        let origin = StringToPoint(d["CanvasOrigin"] as String)
        let size = StringToSize(d["CanvasSize"] as String)
        self.frame = CGRect(origin:origin, size:size)
        println(nodesByID)
        
        let nodes = nodesByID.values.filter {
            (node:Node) -> Bool in
            return node is OmniGraffleLine
        }
        for node in nodes {
            let line = node as OmniGraffleLine
            println(line.dictionary)
            if let headID = line.dictionary["Head"]?["ID"]? as String {
                println(headID)
                println(headID.dynamicType)
            }
            
        }
        
    }
    
    func _processRoot(d:NSDictionary) {
        let graphicslist = d["GraphicsList"] as [NSDictionary]
        var children:[Node] = []
        for graphic in graphicslist {
            if let node = _processDictionary(graphic) {
                children.append(node)
            }
        }
        let group = OmniGraffleGroup(children:children)
        rootNode = group
    }
    
    func _processDictionary(d:NSDictionary) -> OmniGraffleNode! {
        if let className = d["Class"] as? String {
            switch className {
                case "Group":
                    var children:[Node] = []
                    if let graphics = d["Graphics"] as? [NSDictionary] {
                        children = map(graphics) {
                            (d:NSDictionary) -> OmniGraffleNode in
                            return self._processDictionary(d)
                        }
                    }
                    let group = OmniGraffleGroup(children:children)
                    group.dictionary = d
                    nodesByID[group.ID] = group
                    return group
                case "ShapedGraphic":
                    let shape = OmniGraffleShape()
                    shape.dictionary = d
                    nodesByID[shape.ID] = shape
                    return shape
                case "LineGraphic":
                    let line = OmniGraffleLine()
                    line.dictionary = d
                    nodesByID[line.ID] = line
                    return line
                default:
                    println("Unknown: \(className)")
            }
        }
        return nil
    }
}

