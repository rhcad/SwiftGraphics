//
//  Matrix.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/31/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation
import Accelerate

public struct Matrix {
    let data:NSData?
    var pointer:UnsafePointer <CGFloat>
    let columns:Int
    let rows:Int
    let stride:Int = 1

    init(data:NSData, columns:Int, rows:Int, start:Int = 0, stride:Int = 1) {
        self.data = data
        self.pointer = UnsafePointer <CGFloat> (data.bytes).advancedBy(start)
        self.columns = columns
        self.rows = rows
        self.stride = stride
    }

    init(pointer:UnsafePointer <CGFloat>, columns:Int, rows:Int, start:Int = 0, stride:Int = 1) {
        self.pointer = pointer.advancedBy(start)
        self.columns = columns
        self.rows = rows
        self.stride = stride
    }

    init(values:[CGFloat], columns:Int, rows:Int) {
        data = NSData(bytes:values, length:values.count * sizeof(CGFloat))
        self.pointer = UnsafePointer <CGFloat> (data!.bytes)
        self.columns = columns
        self.rows = rows
    }
}

public func * (lhs:Matrix, rhs:Matrix) -> Matrix {

    let resultRows = lhs.rows
    let resultColumns = rhs.columns

    var resultData = NSMutableData(length:resultRows * resultColumns * sizeof(CGFloat))!

    assert(sizeof(Double) == sizeof(CGFloat))
    var resultPointer = UnsafeMutablePointer <Double> (resultData.mutableBytes)
    vDSP_mmulD(UnsafePointer <Double> (lhs.pointer), lhs.stride, UnsafePointer <Double> (rhs.pointer), rhs.stride, resultPointer, 1, vDSP_Length(lhs.rows), vDSP_Length(rhs.columns), vDSP_Length(lhs.columns))

    return Matrix(data:resultData, columns:resultColumns, rows:resultRows, stride:1)
}
