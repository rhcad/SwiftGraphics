//
//  Quadrant.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

// MARK: Quadrants

public enum Quadrant {
    case minXMinY
    case maxXMinY
    case minXMaxY
    case maxXMaxY
}

public extension Quadrant {
    static func fromPoint(point:CGPoint) -> Quadrant {
        if (point.y >= 0) {
            if (point.x >= 0) {
                return .maxXMaxY
            }
            else {
                return .minXMaxY
            }
        }
        else {
            if (point.x >= 0) {
                return .maxXMinY
            }
            else {
                return .minXMinY
            }
        }
    }

    func toPoint() -> CGPoint {
        switch self {
            case .minXMinY:
                return CGPoint(x:-1, y:-1)
            case .maxXMinY:
                return CGPoint(x:1, y:-1)
            case .minXMaxY:
                return CGPoint(x:-1, y:1)
            case .maxXMaxY:
                return CGPoint(x:1, y:1)
        }
    }

    static func fromPoint(point:CGPoint, origin:CGPoint) -> Quadrant {
        return Quadrant.fromPoint(point - origin)
    }

    static func fromPoint(point:CGPoint, rect:CGRect) -> Quadrant? {
        // TODO:  can be ouside
        return Quadrant.fromPoint(point - rect.mid)
    }

    // TODO: Deprecate
    func quadrantRectOfRect(rect:CGRect) -> CGRect {
        return rect.quadrant(self)
    }
}

public extension CGRect {
    func quadrant(quadrant:Quadrant) -> CGRect {
        let size = CGSize(width:self.size.width * 0.5, height:self.size.height * 0.5)
        switch quadrant {
        case .minXMinY:
            return CGRect(origin:CGPoint(x:minX, y:minY), size:size)
        case .maxXMinY:
            return CGRect(origin:CGPoint(x:midX, y:minY), size:size)
        case .minXMaxY:
            return CGRect(origin:CGPoint(x:minX, y:midY), size:size)
        case .maxXMaxY:
            return CGRect(origin:CGPoint(x:midX, y:midY), size:size)
        }
    }
}


