//
//  CGTypes+String.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/17/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation
import SwiftUtilities

public extension CGFloat {
    init(string:String) {
        self = CGFloat(string._bridgeToObjectiveC().doubleValue)
    }
}

public func StringToPoint(s:String) throws -> CGPoint {
    let f = "([0-9.Ee+-]+)"
    let pair = "\\{\(f), \(f)\\}"
    let match = try RegularExpression(pair).match(s)!
    let x = CGFloat(string:match.strings[1])
    let y = CGFloat(string:match.strings[2])
    return CGPoint(x:x, y:y)
}

public func StringToSize(s:String) throws -> CGSize {
    let f = "([0-9.Ee+-]+)"
    let pair = "\\{\(f), \(f)\\}"
    let match = try RegularExpression(pair).match(s)!
    let w = CGFloat(string:match.strings[1])
    let h = CGFloat(string:match.strings[2])
    return CGSize(width:w, height:h)
}

public func StringToRect(s:String) throws -> CGRect {
    let f = "([0-9.Ee+-]+)"
    let pair = "\\{\(f), \(f)\\}"
    let match = try! RegularExpression("\\{\(pair), \(pair)\\}").match(s)!
    let x = CGFloat(string:match.strings[1])
    let y = CGFloat(string:match.strings[2])
    let w = CGFloat(string:match.strings[3])
    let h = CGFloat(string:match.strings[4])
    return CGRect(x:x, y:y, width:w, height:h)
}
