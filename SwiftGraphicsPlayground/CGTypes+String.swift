//
//  CGTypes+String.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/17/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

public extension CGFloat {
    init(string:String) {
        self = CGFloat(string._bridgeToObjectiveC().doubleValue)
    }
}

public func StringToPoint(s:String) -> CGPoint {
    let f = "([0-9.Ee+-]+)"
    let pair = "\\{\(f), \(f)\\}"
    let match = RegularExpression(pair)!.match(s)!
    let x = CGFloat(string:match.groups[1].string)
    let y = CGFloat(string:match.groups[2].string)
    return CGPoint(x:x, y:y)
}

public func StringToSize(s:String) -> CGSize {
    let f = "([0-9.Ee+-]+)"
    let pair = "\\{\(f), \(f)\\}"
    let match = RegularExpression(pair)!.match(s)!
    let w = CGFloat(string:match.groups[1].string)
    let h = CGFloat(string:match.groups[2].string)
    return CGSize(width:w, height:h)
}

public func StringToRect(s:String) -> CGRect {
    let f = "([0-9.Ee+-]+)"
    let pair = "\\{\(f), \(f)\\}"
    let match = RegularExpression("\\{\(pair), \(pair)\\}")!.match(s)!
    let x = CGFloat(string:match.groups[1].string)
    let y = CGFloat(string:match.groups[2].string)
    let w = CGFloat(string:match.groups[3].string)
    let h = CGFloat(string:match.groups[4].string)
    return CGRect(x:x, y:y, width:w, height:h)
}
