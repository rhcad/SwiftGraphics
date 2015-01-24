//
//  Bitmap.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/17/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

public struct Bitmap {
    public let size: UIntSize
    public let bitsPerComponent: UInt
    public let bitsPerPixel: UInt
    public let bytesPerRow: UInt
    public let ptr: UnsafeMutablePointer<Void>
    public var bytesPerPixel: UInt { get { return bitsPerPixel / 8 } }

    public init(size:UIntSize, bitsPerComponent:UInt, bitsPerPixel:UInt, bytesPerRow:UInt, ptr:UnsafeMutablePointer <Void>) {
        self.size = size
        self.bitsPerComponent = bitsPerComponent
        self.bitsPerPixel = bitsPerPixel
        self.bytesPerRow = bytesPerRow
        self.ptr = ptr
    }

    public subscript (index:UIntPoint) -> UInt32 {
        assert(index.x < size.width)
        assert(index.y < size.height)
        let offset = index.y * bytesPerRow + index.x * bytesPerPixel
        let offsetPointer = ptr.advancedBy(Int(offset))
        return UnsafeMutablePointer <UInt32> (offsetPointer).memory
    }
}
