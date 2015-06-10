//
//  QuadTree.swift
//  QuadTree
//
//  Created by Jonathan Wight on 8/6/14.
//  Copyright (c) 2014 schwa. All rights reserved.
//

import CoreGraphics

// TODO - this is a "Point" quadtree - see http://www.codeproject.com/Articles/30535/A-Simple-QuadTree-Implementation-in-C for a discussion of point vs "region' quad tree

private struct QuadTreeConfig {
    let minimumNodeSize: CGSize
    let maximumObjectsPerNode: Int
}

public class QuadTree <T> {
    public var frame: CGRect { return rootNode.frame }
    public var rootNode: QuadTreeNode <T>!
    private let config: QuadTreeConfig

    public required init(frame:CGRect, minimumNodeSize:CGSize = CGSize(w:1, h:1), maximumObjectsPerNode:Int = 8) {
        self.config = QuadTreeConfig(minimumNodeSize:minimumNodeSize, maximumObjectsPerNode:maximumObjectsPerNode)
        self.rootNode = QuadTreeNode(config:config, frame:frame)
    }
    
    public func addObject(object:T, point:CGPoint) {
        assert(frame.contains(point))
        rootNode.addObject(object, point:point)
    }
    
    public func objectsInRect(rect:CGRect) -> [T] {
        assert(frame.intersects(rect))
        return rootNode.objectsInRect(rect)
    }
}

public class QuadTreeNode <T> {

    typealias Item = (point:CGPoint, object:T)

    public let frame: CGRect
    private let config: QuadTreeConfig
    public var subnodes: [QuadTreeNode]?

//    var topLeft: QuadTreeNode?
//    var topRight: QuadTreeNode?
//    var bottomLeft: QuadTreeNode?
//    var bottomRight: QuadTreeNode?

    // Optional because this can be nil-ed out later.
    public lazy var items: [Item]? = []
    public var objects: [T]? {
        if let items = items {
            return items.map() { return $0.object }
        }
        else {
            return nil
        }
    }

    internal var isLeaf: Bool { return subnodes == nil }
    internal var canExpand: Bool { return frame.size.width >= config.minimumNodeSize.width * 2.0 && frame.size.height >= config.minimumNodeSize.height * 2.0 }

    private init(config:QuadTreeConfig, frame:CGRect) {
        self.config = config
        self.frame = frame
    }

    func addItem(item:Item) {
        if isLeaf {
            items!.append(item)
            if items!.count >= config.maximumObjectsPerNode && canExpand {
                expand()
            }
        } else {
            let subnode = subnodeForPoint(item.point)
            subnode.addItem(item)
        }
    }

    func addObject(object:T, point:CGPoint) {
        let item = Item(point:point, object:object)
        addItem(item)
    }

    func itemsInRect(rect:CGRect) -> [Item] {
        var foundItems:[Item] = []
        if let items = items {
            for item in items {
                if rect.contains(item.point) {
                    foundItems.append(item)
                }
            }
        } else {
            for subnode in subnodes! {
                if CGRectIntersectsRect(subnode.frame, rect) {
                    foundItems += subnode.itemsInRect(rect)
                }
            }
        }
        return foundItems
    }

    func objectsInRect(rect:CGRect) -> [T] {
        return itemsInRect(rect).map { return $0.object }
    }
    
    internal func expand() {
        assert(canExpand)
        subnodes = [
            QuadTreeNode(config:config, frame:frame.quadrant(.minXMinY)),
            QuadTreeNode(config:config, frame:frame.quadrant(.maxXMinY)),
            QuadTreeNode(config:config, frame:frame.quadrant(.minXMaxY)),
            QuadTreeNode(config:config, frame:frame.quadrant(.maxXMaxY)),
            ]
        for item in items! {
            let node = subnodeForPoint(item.point)
            node.addItem(item)
        }
        
        items = nil
    }

    internal func subnodeForPoint(point:CGPoint) -> QuadTreeNode! {
        assert(frame.contains(point))
        let quadrant = Quadrant.fromPoint(point, rect:frame)
        let subnode = subnodeForQuadrant(quadrant!)
        return subnode
    }

    internal func subnodeForQuadrant(quadrant:Quadrant) -> QuadTreeNode! {
        if let subnodes = subnodes {
            switch (quadrant) {
                case .minXMinY:
                    return subnodes[0]
                case .maxXMinY:
                    return subnodes[1]
                case .minXMaxY:
                    return subnodes[2]
                case .maxXMaxY:
                    return subnodes[3]
            }
        } else {
            return nil
        }
    }
}
