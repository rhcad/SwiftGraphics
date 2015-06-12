//
//  Random.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 6/12/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

import SwiftUtilities

public extension Random {

    /// Generate random points within the range.
    func arrayOfRandomPoints(count:Int, range:CGRect) -> [CGPoint] {
        return Array <CGPoint> (count:count) {
            return random(range)
        }
    }
}