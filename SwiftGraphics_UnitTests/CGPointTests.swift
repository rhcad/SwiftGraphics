//
//  CGPointTests.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/24/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import XCTest
import SwiftGraphics
import SwiftUtilities

class CGPointTests: XCTestCase {

    func testSingleAxisInitializers() {
        XCTAssertEqual(CGPoint(x:100), CGPoint(x:100, y:0))
        XCTAssertEqual(CGPoint(y:100), CGPoint(x:0, y:100))
    }

    func testTuples() {

        let pt = CGPoint((100, 200))
        XCTAssertEqual(pt, CGPoint(x:100, y:200))
        XCTAssertEqual(pt.toTuple.0, CGFloat(100))
        XCTAssertEqual(pt.toTuple.1, CGFloat(200))
    }

    func testUnaryOperators() {
        XCTAssertEqual(+CGPoint(x:10, y:20), CGPoint(x:10, y:20))
        XCTAssertEqual(-CGPoint(x:10, y:20), CGPoint(x:-10, y:-20))
    }


    func testArithmeticOperators() {        
        XCTAssertEqual(CGPoint(x:10, y:20) + CGPoint(x:1, y:2), CGPoint(x:11, y:22))
        XCTAssertEqual(CGPoint(x:10, y:20) - CGPoint(x:1, y:2), CGPoint(x:9, y:18))
    }

    func testArithmeticOperatorsWithScalar() {
        XCTAssertEqual(CGPoint(x:10, y:20) * 2, CGPoint(x:20, y:40))
        XCTAssertEqual(2 * CGPoint(x:10, y:20), CGPoint(x:20, y:40))
        XCTAssertEqual(CGPoint(x:10, y:20) / 2, CGPoint(x:5, y:10))
    }

    func testArithmeticAssignmentOperators() {
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

        XCTAssertEqual(CGPoint(x:50, y:100).clampedTo(r), CGPoint(x:50, y:100))
        XCTAssertEqual(CGPoint(x:-50, y:100).clampedTo(r), CGPoint(x:0, y:100))
        XCTAssertEqual(CGPoint(x:150, y:100).clampedTo(r), CGPoint(x:100, y:100))
        XCTAssertEqual(CGPoint(x:50, y:-50).clampedTo(r), CGPoint(x:50, y:0))
        XCTAssertEqual(CGPoint(x:50, y:250).clampedTo(r), CGPoint(x:50, y:200))
    }
    
    func testRound() {
        XCTAssertEqual(round(CGPoint((100.1, 100.5)), 0), CGPoint(x:100, y:101))
        XCTAssertEqual(round(CGPoint((-10.1, -10.5)), 0), CGPoint(x:-10, y:-10))
        XCTAssertEqual(round(CGPoint((14.49, 15.44999)), 1), CGPoint(x:14.5, y:15.4))
        XCTAssertEqual(round(CGPoint((14.99999, 15.0)), -1), CGPoint(x:10, y:20))
    }
    
    func testCollinear() {
        XCTAssert( collinear(CGPoint((0, 0)), CGPoint((10, 0)), CGPoint((5, 0))))
        XCTAssert(!collinear(CGPoint((0, 0)), CGPoint((10, 0)), CGPoint((5, 1e-5))))
        XCTAssert( collinear(CGPoint((0, 0)), CGPoint((10, 0)), CGPoint((5, 1e-5)), tolerance: 1e-4))
    }
    
    func testAngle() {
        XCTAssertEqual(angle(CGPoint((0, 0)), CGPoint((10, 0)), CGPoint((5, 0))), CGFloat(0))
        XCTAssertEqual(angle(CGPoint((0, 0)), CGPoint((10, 0)), CGPoint((-5, 0))), CGFloat(M_PI))
        XCTAssertEqual(angle(CGPoint((0, 0)), CGPoint((10, 0)), CGPoint((10, 10))), CGFloat(M_PI_4))
        XCTAssertEqual(angle(CGPoint((0, 0)), CGPoint((10, 0)), CGPoint((10, -10))), CGFloat(M_PI_4))
    }

    func testDotProduct() {
        let p = CGPoint(x:100, y:50)
        XCTAssertEqualWithAccuracy(p.magnitude, CGFloat(111.803), accuracy: 0.01)
        XCTAssertEqual(dotProduct(p, p), p.magnitude ** 2)
    }


// TODO: Casting problems in newest beta.
    func testTrig() {
        let theta:CGFloat = DegreesToRadians(30)
        let length = 100 as CGFloat
        
        let p = CGPoint(magnitude:length, direction:theta)
        XCTAssertEqualWithAccuracy(p.x, CGFloat(86.6025403784439), accuracy: 0.01)
        XCTAssertEqualWithAccuracy(p.y, CGFloat(50), accuracy: 0.01)

        XCTAssertEqualWithAccuracy(atan2(p), theta, accuracy: 0.01)

        XCTAssertEqualWithAccuracy(p.magnitude, length, accuracy: 0.01)

        let n = p.normalized
        XCTAssertEqualWithAccuracy(n.x, CGFloat(0.866025403784439), accuracy: 0.01)
        XCTAssertEqualWithAccuracy(n.y, CGFloat(0.5), accuracy: 0.01)
    }
}
