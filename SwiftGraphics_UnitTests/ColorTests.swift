//
//  ColorTests.swift
//  SwiftGraphics
//
//  Created by Dzianis Lebedzeu on 1/16/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import XCTest
import SwiftGraphics

class ColorTests: XCTestCase {

    func testHSVtoRGB() {
        let redRGB = convert(HSV(h:0, s:1, v:1))
        XCTAssertEqual(RGB(r:1 ,g:0, b: 0), redRGB)
        
        let greenRGB = convert(HSV(h:1/3 ,s:1, v: 1))
        XCTAssertEqual(RGB(r:0 ,g:1, b: 0), greenRGB)
    }
    
    func testRGBtoHSV() {
        let redHSV = convert(RGB(r:1, g:0, b:0))
        XCTAssertEqual(HSV(h:0 ,s:1, v: 1), redHSV)

        let greenHSV = convert(RGB(r:0, g:1, b:0))
        XCTAssertEqual(HSV(h:1/3 ,s:1, v: 1), greenHSV)
    }
}
