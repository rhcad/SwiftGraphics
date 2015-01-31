//
//  Matrix.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/30/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Accelerate

import SwiftGraphics

// MARK: Matrix

public struct Matrix <T:Equatable> {
    public let values:[T]
    public let width:Int = 0
    public let height:Int = 0

    public init(values:[T], width:Int, height:Int) {
        self.values = values
        self.width = width
        self.height = height
    }
}

// MARK: Useful computed properties.

public extension Matrix {

    var size:IntSize {
        get {
            return IntSize(width: width, height: height)
        }
    }
    var area:Int {
        get {
            return width * height
        }
    }
}

// MARK: Useful alternative init methods.

public extension Matrix {

    init(values:[T], size:IntSize) {
        self.values = values
        width = size.width
        height = size.height
    }

    init(values:[T], transposed:Bool = false) {
        var size = IntSize(width:values.count, height:1)
        if transposed {
            size = size.transposed
        }

        self.init(values:values, size:size)
    }

    init(size:IntSize, repeatedValue:T) {
        let values = Array <T> (count:size.width * size.height, repeatedValue:repeatedValue)
        self.init(values:values, size:size)
    }
}

// MARK: All matrices are not created equal.

extension Matrix: Equatable {
}

public func == <T> (lhs:Matrix <T>, rhs:Matrix <T>) -> Bool {
    if lhs.size != rhs.size {
        return false
    }

    // Hope this is performant...
    if lhs.values != rhs.values {
        return false
    }
    return true
}

// MARK: Matrix <CGFloat> operations.

public func * (lhs:Matrix <CGFloat>, rhs:Matrix <CGFloat>) -> Matrix <CGFloat> {
    assert(lhs.size.columns == rhs.size.rows)
    var size = IntSize(rows:lhs.size.rows, columns:rhs.size.columns)
    var resultValue = Array <CGFloat> (count: size.area, repeatedValue: CGFloat.NaN)
    resultValue.withUnsafeMutableBufferPointer() {
        (inout buffer:UnsafeMutableBufferPointer<CGFloat>) -> Void in

#if os(OSX)
        let lhsPointer = UnsafePointer<Double> (UnsafePointer<CGFloat> (lhs.values))
        let rhsPointer = UnsafePointer<Double> (UnsafePointer<CGFloat> (rhs.values))
        let outPointer = UnsafeMutablePointer<Double> (buffer.baseAddress)

        vDSP_mmulD(lhsPointer, 1, rhsPointer, 1, outPointer, 1, vDSP_Length(lhs.size.rows), vDSP_Length(rhs.size.columns), vDSP_Length(lhs.size.columns))
#else
        let lhsPointer = UnsafePointer<Float> (UnsafePointer<CGFloat> (lhs.values))
        let rhsPointer = UnsafePointer<Float> (UnsafePointer<CGFloat> (rhs.values))
        let outPointer = UnsafeMutablePointer<Float> (buffer.baseAddress)

        vDSP_mmul(lhsPointer, 1, rhsPointer, 1, outPointer, 1, vDSP_Length(lhs.size.rows), vDSP_Length(rhs.size.columns), vDSP_Length(lhs.size.columns))
#endif

    }
    return Matrix(values:resultValue, size:size)
}


// MARK: Matrix <Float> operations.

public func + (lhs:Matrix <Float>, rhs:Matrix <Float>) -> Matrix <Float> {
    assert(lhs.size == rhs.size)
    var resultValue = Array <Float> (count: lhs.values.count, repeatedValue: 0)
    resultValue.withUnsafeMutableBufferPointer() {
        (inout buffer:UnsafeMutableBufferPointer<Float>) -> Void in
        vDSP_vadd(lhs.values, 1, rhs.values, 1, buffer.baseAddress, 1, vDSP_Length(lhs.area))
    }
    return Matrix(values:resultValue, size:lhs.size)
}

public func * (lhs:Matrix <Float>, rhs:Matrix <Float>) -> Matrix <Float> {
    assert(lhs.size.columns == rhs.size.rows)
    var size = IntSize(rows:lhs.size.rows, columns:rhs.size.columns)
    var resultValue = Array <Float> (count: size.area, repeatedValue: Float.NaN)
    resultValue.withUnsafeMutableBufferPointer() {
        (inout buffer:UnsafeMutableBufferPointer<Float>) -> Void in
        vDSP_mmul(lhs.values, 1, rhs.values, 1, buffer.baseAddress, 1, vDSP_Length(lhs.size.rows), vDSP_Length(rhs.size.columns), vDSP_Length(lhs.size.columns))
    }
    return Matrix(values:resultValue, size:size)
}

public func transpose(m:Matrix <Float>) -> Matrix <Float> {
    // TODO: width or height == 1 we can just return same data but transpose the size

    var resultValues = Array <Float> (count:m.area, repeatedValue:Float.NaN)
    resultValues.withUnsafeMutableBufferPointer {
        (inout buffer:UnsafeMutableBufferPointer<Float>) -> Void in
        vDSP_mtrans(m.values, 1, buffer.baseAddress, 1, vDSP_Length(m.size.width), vDSP_Length(m.size.height))
    }
    return Matrix(values: resultValues, size: m.size.transposed)
}

// MARK: We need some (somewhat) Matric specifics added to GenericSize

public extension GenericSize {
    init(rows:T, columns:T) {
        width = columns
        height = rows
    }
    var rows:T { get { return height } }
    var columns:T { get { return width } }

    var transposed:GenericSize {
        get {
            return GenericSize(width: height, height: width)
        }
    }

    var area:T {
        get {
            return width * height
        }
    }
}

