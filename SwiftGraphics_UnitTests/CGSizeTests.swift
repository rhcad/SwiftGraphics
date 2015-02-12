//
//  CGSizeTests.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import XCTest
import SwiftGraphics

class CGSizeTests: XCTestCase {

    func testOrientation() {
        XCTAssertEqual(CGSize(width:100, height:100).orientation, Orientation.Square)
        XCTAssertEqual(CGSize(width:100, height:50).orientation, Orientation.Landscape)
        XCTAssertEqual(CGSize(width:1, height:2).orientation, Orientation.Portrait)

        XCTAssertEqual(CGSize(width:100, height:-100).orientation, Orientation.Square)
        XCTAssertEqual(CGSize(width:-100, height:50).orientation, Orientation.Landscape)
        XCTAssertEqual(CGSize(width:1, height:-2).orientation, Orientation.Portrait)

        // TODO: Are CGSizes with zero width or height actually NOT landscape or portrait?
        XCTAssertEqual(CGSize(width:0, height:0).orientation, Orientation.Square)
        XCTAssertEqual(CGSize(width:100, height:0).orientation, Orientation.Landscape)
        XCTAssertEqual(CGSize(width:0, height:2).orientation, Orientation.Portrait)
    }

}
