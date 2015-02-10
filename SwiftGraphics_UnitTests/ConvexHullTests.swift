//
//  ConvexHullTests.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 9/17/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import XCTest
import SwiftGraphics

//extension CGPoint : Comparable {
//}
//
//public func < (lhs:CGPoint, rhs:CGPoint) -> Bool {
//    return lhs.y < rhs.y ? true : (lhs.y == rhs.y ? (lhs.x < rhs.x ? true : false) : false)
//}
//
//class ConvexHullTests: XCTestCase {
//    func testMonotoneChain1() {
//        let p = [
//            CGPoint(x:0, y:0),
//            CGPoint(x:10, y:0),
//            CGPoint(x:10, y:10),
//            CGPoint(x:0, y:10),
//            CGPoint(x:5, y:5), // Not in hull
//        ]
//        let hull = monotoneChain(p).sorted(<)
//        let expected = Array <CGPoint> (p[0...3]).sorted(<)
//        XCTAssertEqual(hull, expected)
//    }
//
//    func testMonotoneChain2() {
//        let p = [
//            CGPoint(x:0, y:0),
//            CGPoint(x:10, y:0),
//            CGPoint(x:10, y:10),
//            CGPoint(x:0, y:10),
//        ]
//        let hull = monotoneChain(p).sorted(<)
//        let expected = Array <CGPoint> (p[0...3]).sorted(<)
//        XCTAssertEqual(hull, expected)
//    }
//
//    func testMonotoneChain3() {
//        let p = [
//            CGPoint(x:0, y:0),
//            CGPoint(x:10, y:0),
//            CGPoint(x:10, y:10),
//        ]
//        let hull = monotoneChain(p).sorted(<)
//        let expected = p.sorted(<)
//        XCTAssertEqual(hull, expected)
//    }
//
//    func testMonotoneChain4() {
//        let p = [
//            CGPoint(x:0, y:0),
//            CGPoint(x:10, y:0),
//        ]
//        let hull = monotoneChain(p).sorted(<)
//        let expected = p.sorted(<)
//        XCTAssertEqual(hull, expected)
//    }
//
//    func testMonotoneChain5() {
//        let p = [
//            CGPoint(x:0, y:0),
//        ]
//        let hull = monotoneChain(p).sorted(<)
//        let expected = p.sorted(<)
//        XCTAssertEqual(hull, expected)
//    }
//}
