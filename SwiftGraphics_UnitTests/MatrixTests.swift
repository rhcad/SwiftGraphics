//
//  MatrixTests.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/31/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics
import XCTest

class MatrixTests: XCTestCase {

    func testMatrixMultiplication() {
        let m1 = Matrix(values:[1,2,3,4,5,6], columns:3, rows:2)
        let m2 = Matrix(values:[7,8,9,10,11,12], columns:2, rows:3)
        let m3 = m1 * m2

        XCTAssertEqual(m3[(0,0)], CGFloat(58.0))

        let m4 = Matrix(values:[58.0, 64.0, 139.0, 154.0], columns:2, rows:2)
        m3 == m4

        XCTAssertEqual(m3, m4)
    }
}
