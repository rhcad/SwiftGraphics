//
//  QuadrantTests.swift
//  SwiftGraphics
//
//  Created by Dzianis Lebedzeu on 1/17/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import XCTest
import SwiftGraphics


class QuadrantTests: XCTestCase {

    let p1 = CGPointMake(-1, -1)
    let p2 = CGPointMake(-1, 1)
    let p3 = CGPointMake(1, -1)
    let p4 = CGPointMake(1, 1)
    
    func testCGRectFromQuadrant() {
        let rect = CGRectMake(0, 0, 20, 20)
        
        XCTAssertEqual(rect.quadrant(.minXMinY), CGRectMake(0, 0, 10, 10))
        XCTAssertEqual(rect.quadrant(.maxXMinY), CGRectMake(10, 0, 10, 10))
        XCTAssertEqual(rect.quadrant(.minXMaxY), CGRectMake(0, 10, 10, 10))
        XCTAssertEqual(rect.quadrant(.maxXMaxY), CGRectMake(10, 10, 10, 10))
    }
    
    func testQuadrantFromPoint() {
        XCTAssertEqual(Quadrant.minXMinY, Quadrant.fromPoint(p1))
        XCTAssertEqual(Quadrant.minXMaxY, Quadrant.fromPoint(p2))
        XCTAssertEqual(Quadrant.maxXMinY, Quadrant.fromPoint(p3))
        XCTAssertEqual(Quadrant.maxXMaxY, Quadrant.fromPoint(p4))
    }
    
    func testQuadrantFromPointWithOrigin() {
        XCTAssertEqual(Quadrant.maxXMinY, Quadrant.fromPoint(p1, origin: p2))
        XCTAssertEqual(Quadrant.minXMaxY, Quadrant.fromPoint(p2, origin: p3))
        XCTAssertEqual(Quadrant.maxXMinY, Quadrant.fromPoint(p3, origin: p4))
        XCTAssertEqual(Quadrant.maxXMaxY, Quadrant.fromPoint(p4, origin: p1))
    }
    
    func testQuadrantFromPointWithRect() {
        // TODO: add tests
    }
    
    func testQuadrantToPoint() {
        XCTAssertEqual(p1, Quadrant.minXMinY.asPoint())
        XCTAssertEqual(p2, Quadrant.minXMaxY.asPoint())
        XCTAssertEqual(p3, Quadrant.maxXMinY.asPoint())
        XCTAssertEqual(p4, Quadrant.maxXMaxY.asPoint())
    }

}
