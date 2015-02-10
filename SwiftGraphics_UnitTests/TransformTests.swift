//
//  TransformTests.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 11/12/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import XCTest
import SwiftGraphics

typealias Transform = CGAffineTransform

class TransformTests: XCTestCase {

    func testExample() {
        var t = Transform.identity
        XCTAssertEqual(t, CGAffineTransformIdentity)

        t.scale(100, 100)
        XCTAssertEqual(t, Transform(sx:100, sy:100))

        var p = CGPoint(x:1, y:2)
        p *= t
        XCTAssertEqual(p, CGPoint(x:100, y:200))
    }

//    func test_rotationAroundPoint_0() {
//        let input = CGPoint(x:200, y:0)
//        let origin = CGPoint(x:0, y:0)
//        let angle:CGFloat = DegreesToRadians(90)
//        let output = round(input * Transform.rotationAroundPoint(origin, angle:angle))
//        let expected = CGPoint(x:0, y:200)
//        XCTAssertEqual(output, expected)
//    }


//    func test_rotationAroundPoint_1() {
//        let input = CGPoint(x:200, y:0)
//        let origin = CGPoint(x:100, y:0)
//        let angle:CGFloat = DegreesToRadians(90)
//        let output = round(input * Transform.rotationAroundPoint(origin, angle:angle))
//        let expected = CGPoint(x:100, y:100)
//        XCTAssertEqual(output, expected)
//    }

}
