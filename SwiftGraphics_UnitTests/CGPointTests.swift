//
//  CGPointTests.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa
import XCTest
import SwiftGraphics

class CGPointTests: XCTestCase {

    func testInit() {
        XCTAssertEqual(CGPoint((100, 100)), CGPoint(x:100, y:100))
//        XCTAssertEqual(CGPoint(100, 100), CGPoint(x:100, y:0))
        XCTAssertEqual(CGPoint(x:100), CGPoint(x:100, y:0))
        XCTAssertEqual(CGPoint(y:100), CGPoint(x:0, y:100))
    }
        
    func testArithmeticOperators() {        
        XCTAssertEqual(CGPoint(x:1, y:1) + CGPoint(x:1, y:1), CGPoint(x:2, y:2))
        XCTAssertEqual(CGPoint(x:2, y:2) - CGPoint(x:1, y:1), CGPoint(x:1, y:1))
        XCTAssertEqual(CGPoint(x:1, y:1) * 2, CGPoint(x:2, y:2))
        XCTAssertEqual(2 * CGPoint(x:1, y:1), CGPoint(x:2, y:2))
        XCTAssertEqual(CGPoint(x:1, y:1) / 2, CGPoint(x:0.5, y:0.5))
//        XCTAssertEqual(CGPoint(x:2, y:2) * CGPoint(x:2, y:2), CGPoint(x:4, y:4))
    }

    func testAssignmentOperators() {        
        var p = CGPoint(x:10, y:10)
        p += CGPoint(x:1, y:1)
        XCTAssertEqual(p, CGPoint(x:11, y:11))

        p = CGPoint(x:10, y:10)
        p -= CGPoint(x:1, y:1)
        XCTAssertEqual(p, CGPoint(x:9, y:9))

        p = CGPoint(x:10, y:10)
        p *= 2
        XCTAssertEqual(p, CGPoint(x:20, y:20))

        p = CGPoint(x:10, y:10)
        p /= 2
        XCTAssertEqual(p, CGPoint(x:5, y:5))
    }

    func testClamped() {
        let r = CGRect(size:CGSize(width:100, height:200))

        XCTAssertEqual(CGPoint(x:50, y:100).clamped(r), CGPoint(x:50, y:100))
        XCTAssertEqual(CGPoint(x:-50, y:100).clamped(r), CGPoint(x:0, y:100))
        XCTAssertEqual(CGPoint(x:150, y:100).clamped(r), CGPoint(x:100, y:100))
        XCTAssertEqual(CGPoint(x:50, y:-50).clamped(r), CGPoint(x:50, y:0))
        XCTAssertEqual(CGPoint(x:50, y:250).clamped(r), CGPoint(x:50, y:200))
    }
    
    func testRound() {
        XCTAssertEqual(round(CGPoint((100.1, 100.5)), 0), CGPoint(x:100, y:101))
        XCTAssertEqual(round(CGPoint((-10.1, -10.5)), 0), CGPoint(x:-10, y:-10))
        XCTAssertEqual(round(CGPoint((14.49, 15.44999)), 1), CGPoint(x:14.5, y:15.4))
        XCTAssertEqual(round(CGPoint((14.99999, 15.0)), -1), CGPoint(x:10, y:20))
    }

//    func testDotProduct() {
//
//        let p = CGPoint(x:100, y:50)
//
//        XCTAssertEqualWithAccuracy(p.magnitude, CGFloat(111.803), 0.01)
//        XCTAssertEqual(dotProduct(p, p), p.magnitude ** 2)
//    }


// TODO: Casting problems in newest beta.
//    func testTrig() {
//        let theta = DegreesToRadians(30) as CGFloat
//        let length = 100 as CGFloat
//        
//        let p = CGPoint(length:length, theta:theta)
//        XCTAssertEqualWithAccuracy(p.x, 86.6025403784439, CGFloat(FLT_EPSILON))
//        XCTAssertEqualWithAccuracy(p.y, 50, CGFloat(FLT_EPSILON))
//
//        XCTAssertEqualWithAccuracy(atan2(p), theta, CGFloat(FLT_EPSILON))
//
//        XCTAssertEqualWithAccuracy(p.length, length, CGFloat(FLT_EPSILON))
//
//        let n = p.normalized
//        XCTAssertEqualWithAccuracy(n.x, 0.866025403784439, CGFloat(FLT_EPSILON))
//        XCTAssertEqualWithAccuracy(n.y, 0.5, CGFloat(FLT_EPSILON))
//    }
}
