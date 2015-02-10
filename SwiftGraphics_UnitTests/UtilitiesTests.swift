//
//  UtilitesTests.swift
//  SwiftGraphics
//
//  Created by Dzianis Lebedzeu on 1/17/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import XCTest
import SwiftGraphics

class UtilitesTests: XCTestCase {

    func testPower() {
        XCTAssertEqual(2.0 ** 2.0, 4.0)
        XCTAssertEqual(CGFloat(2) ** CGFloat(2), CGFloat(4))
    }
    
    func testClamp() {
        XCTAssert(clamp(2, 0, 10) == 2)
        XCTAssert(clamp(12, 0, 10) == 10)
        XCTAssert(clamp(-1, 0, 10) == 0)
    }
    
    func testLerpFloat() {
        XCTAssert(lerp(Double(1.0), Double(2.0), Double(2.0)) == Double(3.0))
    }
    
    func testLerpPoint() {
        let result = lerp(CGPointMake(1, 1), CGPointMake(2, 2), 2)
        XCTAssertEqual(result, CGPointMake(3, 3))
    }
    
    func testLerpSize() {
        let result = lerp(CGSizeMake(1, 1), CGSizeMake(2, 2), 2)
        XCTAssertEqual(result, CGSizeMake(3, 3))
    }
    
    func testLerpRect() {
        let result = lerp(CGRectMake(1, 1, 1, 1), CGRectMake(1, 1, 2, 2), 2)
        XCTAssertEqual(result, CGRectMake(1, 1, 3, 3))
    }
    
    func testDegreesToRadians() {
        let rad30 = 0.52359877559829882
        XCTAssert(DegreesToRadians(30.0) == rad30)
        XCTAssert(DegreesToRadians(CGFloat(30)) == CGFloat(rad30))
    }
    
    func testRadiansToDegrees() {
        let rad30 = 0.52359877559829882
        XCTAssert(RadiansToDegrees(rad30) ==% 30)
        XCTAssert(RadiansToDegrees(CGFloat(rad30)) ==% CGFloat(30))
    }

}
