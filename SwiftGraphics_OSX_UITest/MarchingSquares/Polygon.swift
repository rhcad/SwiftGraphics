//
//  Polygon.swift
//  Metaballs
//
//  Created by Jonathan Wight on 9/20/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

// TODO: Remove all this.

public struct GenericVector3 <T> {
    var x:T
    var y:T
//    var z:T = 0
    
    public init(x:T, y:T) {
        self.x = x
        self.y = y
    }
}

typealias CGVector3 = GenericVector3 <CGFloat>

public struct Edge {
    public let start:CGPoint
    public let end:CGPoint
    
    public init(start:CGPoint, end:CGPoint) {
        self.start = start
        self.end = end
    }
    
    public init(_ start:CGPoint, _ end:CGPoint) {
        self.start = start
        self.end = end
    }
    
    public init(x1:CGFloat, y1:CGFloat, x2:CGFloat, y2:CGFloat) {
        self.start = CGPoint(x:x1, y:y1)
        self.end = CGPoint(x:x2, y:y2)
    }
    
    var flipped:Edge {
        get {
            return Edge(start:end, end:start)
        }
    }
}

public struct Polygon {
    public let edges:[Edge]

    public init(edges:[Edge]) {
        self.edges = edges
    }
    
    var connected:Bool {
        get {
            return edges.count >= 3 && edges[0].start == edges.last!.end
        }
    }
}

public extension Polygon {
    static func constructPolygonsFromUnconnectedEdges(var unconnectedEdges:[Edge]) -> [Polygon] {
    
        var polygons:[Polygon] = []
    
        while unconnectedEdges.isEmpty == false {
            var edges:[Edge] = [unconnectedEdges[0]]
            unconnectedEdges.removeAtIndex(0)

            var consumedIndexes:[Int] = []
            for (index, edge) in enumerate(unconnectedEdges) {
                println(edges.count >= 3 && edges[0].start == edges.last!.end)

                var lastEdge = edges.last!
                if  edge.start == lastEdge.end {
                    edges.append(edge)
                    consumedIndexes.append(index)
                    continue
                }

                lastEdge = lastEdge.flipped
                if  edge.start == lastEdge.end {
                    edges.append(edge)
                    consumedIndexes.append(index)
                    continue
                }

                var firstEdge = edges[0]
                if  edge.start == firstEdge.end {
                    edges.append(edge)
                    consumedIndexes.append(index)
                    continue
                }

                firstEdge = firstEdge.flipped
                if  edge.start == firstEdge.end {
                    edges.append(edge)
                    consumedIndexes.append(index)
                    continue
                }
            }
            
            let polygon = Polygon(edges:edges)
            
            
            polygons.append(polygon)
            println("Count \(edges.count)")

//            if consumedIndexes.count == unconnectedEdges.count {
//                break
//            }

            consumedIndexes.sort(>)
            for index in consumedIndexes {
                unconnectedEdges.removeAtIndex(index)
            }


        }
    
        return polygons
    }
}