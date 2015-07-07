//
//  Handleable.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/11/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

public protocol Handleable {
    var handles:[Handle] { get }
}

public struct Handle {
    var position:CGPoint {
        get {
            return positionGetter()
        }
        set {
            positionSetter(newValue)
        }
    }
    var positionGetter:Void -> CGPoint
    var positionSetter:CGPoint -> Void

}

// MARK: -

extension Rectangle: Handleable {
    public var handles:[Handle] {
        return [
//                Handle(
//                    positionGetter: { return frame.minXMinY },
//                    positionSetter: { var newFrame = frame; newFrame.minXMinY = $0; frame = newFrame }
//                ),
//                Handle(position: self.frame.minXMaxY),
//                Handle(position: self.frame.maxXMinY),
//                Handle(position: self.frame.maxXMaxY),
        ]
    }
}

// MARK: -

//extension Circle: Handleable {
//    public var handles:[Handle] {
//        get {
//            return []
//        }
//    }
//}
//
//// MARK: -
//
//extension Triangle: Handleable {
//    public var handles:[Handle] {
//        get {
//            return []
//        }
//    }
//}
//
//
//
//
//
//
