//
//  Turn.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

public enum Turn: Int {
    case Left = 1
    case None = 0
    case Right = -1
}


public extension Turn {

    // TODO: Swift 1.2 - can no longer init() enums via custom init methods. Workaround is to make the init failable. Fix this in fufture.
    public init?(_ p:CGPoint, _ q:CGPoint, _ r:CGPoint) {
        let c = (q.x - p.x) * (r.y - p.y) - (r.x - p.x) * (q.y - p.y)
        let turn:Turn = c == 0 ? .None : (c > 0 ? .Left : .Right)
        self = turn
    }
}

extension Turn: Comparable {
}

public func < (lhs:Turn, rhs:Turn) -> Bool {
    return lhs.rawValue < rhs.rawValue
}

extension Turn: CustomStringConvertible {
    public var description: String {
        get {
            switch self {
                case .None:
                    return "None"
                case .Left:
                    return "Left"
                case .Right:
                    return "Right"
            }
        }
    }
}