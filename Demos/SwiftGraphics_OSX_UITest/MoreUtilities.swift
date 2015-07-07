//
//  Utilities.swift
//  Sketch
//
//  Created by Jonathan Wight on 8/31/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

import Cocoa

extension UInt32 {
    func asHex() -> String {
        var s = ""
        let characters:[Character] = [
            "0","1","2","3","4","5","6","7","8","9",
            "A","B","C","D","E","F",
            ]
        s.append(characters[Int(self >> 28 & 0x0F)])
        s.append(characters[Int(self >> 24 & 0x0F)])
        s.append(characters[Int(self >> 20 & 0x0F)])
        s.append(characters[Int(self >> 16 & 0x0F)])
        s.append(characters[Int(self >> 12 & 0x0F)])
        s.append(characters[Int(self >> 8 & 0x0F)])
        s.append(characters[Int(self >> 4 & 0x0F)])
        s.append(characters[Int(self & 0x0F)])
        
        return s
    }

}

struct IntegerPoint <T: IntegerType> {
    var x:T
    var y:T
}

typealias UIntPoint = IntegerPoint <UInt>

struct IntegerSize <T: IntegerType> {
    var width:T
    var height:T
}

typealias UIntSize = IntegerSize <UInt>

struct Bitmap {
    let size: UIntSize
    let bitsPerComponent: UInt
    let bitsPerPixel: UInt
    let bytesPerRow: UInt
    let ptr: UnsafeMutablePointer<Void>
    var bytesPerPixel: UInt { get { return bitsPerPixel / 8 } }

    subscript (index:UIntPoint) -> UInt32 {
        assert(index.x < size.width)
        assert(index.y < size.height)
        let offset = index.y * bytesPerRow + index.x * bytesPerPixel
        let offsetPointer = ptr.advancedBy(Int(offset))
        return UnsafeMutablePointer <UInt32> (offsetPointer).memory
    }
}

extension NSColor {
    convenience init(rgba:UInt32, bgra:Bool = true) {
        let (rs:UInt32, gs:UInt32, bs:UInt32) = bgra ? (8, 16, 24) : (24, 16, 8)
    
    
        let r = CGFloat((rgba >> rs) & 0xFF) / 255
        let g = CGFloat((rgba >> gs) & 0xFF) / 255
        let b = CGFloat((rgba >> bs) & 0xFF) / 255
        let a = CGFloat(rgba & 0b1111_1111) / 255
        self.init(deviceRed:r, green:g, blue:b, alpha:a)
    }
    
    var asUInt32:UInt32 {
        get {
            let r = UInt32(redComponent * 255)
            let g = UInt32(greenComponent * 255)
            let b = UInt32(blueComponent * 255)
            let a = UInt32(alphaComponent * 255)
            return r << 24 | g << 16 | b << 8 | a
        }
    }
}


extension NSData {
    convenience init(contentsOfCompressedFile path:String) {
        let data = NSData(contentsOfFile:path)
        let zipFile = gzopen(path, "rb")
        let unzippedData = NSMutableData(length:0)!
        while true {
            let buffer = NSMutableData(length:4 * 1024 * 1024)!
            let result = gzread(zipFile, buffer.mutableBytes, UInt32(buffer.length))
            if result > 0 {
                buffer.length = Int(result)
                unzippedData.appendData(buffer)
            }
            else {
                break
            }
        }
        gzclose(zipFile)
        self.init(data:unzippedData)
    }
}


extension CGFloat {
    init(string:String) {
        self = CGFloat(string._bridgeToObjectiveC().doubleValue)
    }
}

func StringToPoint(s:String) -> CGPoint {
    let f = "([0-9.Ee+-]+)"
    let pair = "\\{\(f), \(f)\\}"
    let match = RegularExpression(pair).match(s)!
    let x = CGFloat(string:match.groups[1].string)
    let y = CGFloat(string:match.groups[2].string)
    return CGPoint(x:x, y:y)
}

func StringToSize(s:String) -> CGSize {
    let f = "([0-9.Ee+-]+)"
    let pair = "\\{\(f), \(f)\\}"
    let match = RegularExpression(pair).match(s)!
    let w = CGFloat(string:match.groups[1].string)
    let h = CGFloat(string:match.groups[2].string)
    return CGSize(w:w, h:h)
}

func StringToRect(s:String) -> CGRect {
    let f = "([0-9.Ee+-]+)"
    let pair = "\\{\(f), \(f)\\}"
    let match = RegularExpression("\\{\(pair), \(pair)\\}").match(s)!
    let x = CGFloat(string:match.groups[1].string)
    let y = CGFloat(string:match.groups[2].string)
    let w = CGFloat(string:match.groups[3].string)
    let h = CGFloat(string:match.groups[4].string)
    return CGRect(x:x, y:y, width:w, height:h)
}

/**
 *  A struct that acts like an array but returns results from a block
 */
struct BlockBackedCollection <T> : CollectionType, SequenceType {
    typealias Element = T
    typealias Index = Int
    typealias Block = (index:Index) -> T
    typealias Generator = BlockBackedCollectionGenerator <T>

    var startIndex: Index { get { return 0 } }
    var endIndex: Index { get { return count } }
    let count: Int
    let block: Block

    init(count:Index, block:Block) {
        self.count = count
        self.block = block
    }

    subscript (index:Index) -> T {
        assert(index > 0 && index < self.count)
        return block(index: index)
    }

    func generate() -> Generator {
        return Generator(sequence:self)
    }
}

struct BlockBackedCollectionGenerator <T> : GeneratorType {
    typealias Sequence = BlockBackedCollection <T>
    typealias Element = Sequence.Element
    typealias Index = Sequence.Index
    typealias Block = Sequence.Block

    let startIndex: Index = 0
    var endIndex: Index { get { return count } }
    let count: Int
    let block: Block
    var nextIndex: Index = 0

    init(sequence:Sequence) {
        self.count = sequence.count
        self.block = sequence.block
    }
        
    mutating func next() -> Element? {
        if nextIndex >= endIndex {
            return nil
        }
        else if nextIndex < endIndex {
            let element = block(index:nextIndex++)
            return element
        }
        else {
            return nil
        }
    }
}
