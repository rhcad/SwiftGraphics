//
//  Grid.swift
//  Metaballs
//
//  Created by Jonathan Wight on 9/14/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import CoreGraphics

import SwiftGraphics

class Grid_Array <T> {
    let size:(width:Int,height:Int)
    var buffer:Array<T>
    
    init(width:Int, height:Int, defaultValue:T) {
        size = (width, height)
        
        let count = width * height
        buffer = Array<T> (count:count, repeatedValue:defaultValue)
    }
 
    subscript (index:IntPoint) -> T {
        get {
            return buffer[index.x + index.y * size.width]
        }
        set {
            buffer[index.x + index.y * size.width] = newValue
        }
    }
}

class Grid_Buffer <T> { 

    let size:(width:Int,height:Int)
    var count:Int
    var bytes:UnsafeMutablePointer<T>
    var buffer2:UnsafeMutableBufferPointer<T>
    
    init(width:Int, height:Int, defaultValue:T) {
        size = (width, height)
        
        count = width * height
        
        var memory = sizeof(T) * count
        bytes = UnsafeMutablePointer<T>(malloc(memory))
        buffer2 = UnsafeMutableBufferPointer <T>(start:bytes, count:count)
        for N in 0..<count {
            buffer2[N] = defaultValue
        }

    }
 
    subscript (index:IntPoint) -> T {
        get {
            let offset = index.x + index.y * size.width
            assert(offset >= 0)
            assert(offset < count)
            return buffer2[offset]
        }
        set {
            buffer2[index.x + index.y * size.width] = newValue
        }
    }
}