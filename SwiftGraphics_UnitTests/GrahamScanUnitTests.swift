//
//  GrahamScanUnitTests.swift
//  SwiftGraphics
//
//  Created by Dzianis Lebedzeu on 1/17/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import XCTest
import SwiftGraphics

class GrahamScanUnitTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    func testGrahamScan() {
        let points = [
            CGPointMake(100, 100),
            CGPointMake(10, 300),
            CGPointMake(30, 30),
            CGPointMake(200, 100),
            CGPointMake(150, 40)
        ]

        let hull = grahamScan(points)
        XCTAssertEqual(hull, [CGPointMake(30, 30), CGPointMake(10, 300), CGPointMake(200, 100), CGPointMake(150, 40)])
    }
}
