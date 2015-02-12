//
//  BezierPathTests.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/31/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import XCTest

import SwiftGraphics

class BezierPathTests: XCTestCase {

    func testExample() {

        let points = [
            CGPoint(x:120,y:160),
            CGPoint(x:35,y:200),
            CGPoint(x:220,y:260),
            CGPoint(x:220,y:40),
        ]

        let curve = BezierCurve(points:points)

        XCTAssertEqual(curve.pointAlongCurve(0), points[0])
        XCTAssertNotEqual(curve.pointAlongCurve(0), points[1])
        XCTAssertEqual(curve.pointAlongCurve(1), points[3])
    }

    func testPointAlongCurveDeCasteljaus() {
        let points = [
            CGPoint(x:120,y:160),
            CGPoint(x:35,y:200),
            CGPoint(x:220,y:260),
            CGPoint(x:220,y:40),
        ]
        self.measureBlock() {
            for var t:CGFloat = 0.0; t <= 1.0; t += 0.01 {
                BezierCurve.pointAlongCurveDeCasteljaus(points, t:t)
            }
        }
    }

    func testPointAlongCurveMatrix() {
        let points = [
            CGPoint(x:120,y:160),
            CGPoint(x:35,y:200),
            CGPoint(x:220,y:260),
            CGPoint(x:220,y:40),
        ]
        self.measureBlock() {
            for var t:CGFloat = 0.0; t <= 1.0; t += 0.01 {
                BezierCurve.pointAlongCurveMatrix(points, t:t)
            }
        }
    }
}
