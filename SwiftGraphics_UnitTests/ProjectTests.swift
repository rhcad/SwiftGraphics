//
//  ProjectTests.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/31/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa
import XCTest

class ProjectTests: XCTestCase {
    func testProjectConfiguration() {

// TODO: Flip this when we switch unit tests to RELEASE builds
#if DEBUG && !RELEASE
        XCTAssert(true)
#else
        XCTAssert(false, "Unit tests not running in correct build configuration.")
#endif
    }

}
