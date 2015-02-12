//
//  RegularPolygonTests.swift
//  SwiftGraphics
//
//  Created by Zhang Yungui on on 15/1/23.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import XCTest
import SwiftGraphics

class RegularPolygonTests: XCTestCase {

    func testWithTriangle() {
        let p = RegularPolygon(nside:3, center:CGPoint.zeroPoint, vertex:CGPoint(x:0, y:100))
        let pts = p.points
        let t = Triangle(points:pts)
        let tolerance = CGFloat(FLT_EPSILON)
        let half = CGFloat(50*sqrt(3.0))
        
        XCTAssert(t.isEquilateral)
        XCTAssertEqual(pts.count, 3)
        XCTAssertEqual(p.startAngle, CGFloat(M_PI_2))
        XCTAssertEqual(p.centralAngle, CGFloat(2*M_PI/3))
        XCTAssertEqual(p.interiorAngle, CGFloat(M_PI/3))
        XCTAssertEqual(p.radius, CGFloat(100))
        XCTAssertEqualWithAccuracy(p.inradius, CGFloat(50), tolerance)
        XCTAssertEqualWithAccuracy(p.sideLength, 2*half, tolerance)
        XCTAssertEqualWithAccuracy(p.area, CGFloat(150*half), tolerance)
        
        XCTAssertEqualWithAccuracy(pts[0].x, CGFloat(0), tolerance)
        XCTAssertEqualWithAccuracy(pts[0].y, CGFloat(100), tolerance)
        XCTAssertEqualWithAccuracy(pts[1].x, -half, tolerance)
        XCTAssertEqualWithAccuracy(pts[1].y, CGFloat(-50), tolerance)
        XCTAssertEqualWithAccuracy(pts[2].x, half, tolerance)
        XCTAssertEqualWithAccuracy(pts[2].y, CGFloat(-50), tolerance)
        
        XCTAssertEqualWithAccuracy(p.center.x, t.circumcenter.x, tolerance)
        XCTAssertEqualWithAccuracy(p.center.y, t.circumcenter.y, tolerance)
        XCTAssertEqualWithAccuracy(p.length, {let s=t.lengths; return s.0+s.1+s.2}(), tolerance)
        
        // TODO: There are some issues in Triangle class, so comment the following lines.
        XCTAssertEqualWithAccuracy(p.area, t.area, tolerance)
        XCTAssertEqualWithAccuracy(p.circumcircle.radius, t.circumcircle.radius, tolerance)
        XCTAssertEqualWithAccuracy(p.inradius, t.inradius, tolerance)
        //XCTAssertEqualWithAccuracy(p.center.x, t.incenter.x, tolerance)
        //XCTAssertEqualWithAccuracy(p.center.y, t.incenter.y, tolerance)
    }

}
