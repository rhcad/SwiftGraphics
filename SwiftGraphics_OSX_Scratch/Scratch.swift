//
//  Scratch.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/26/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import SwiftGraphics

// MARK: -

var kUserInfoKey:Int = 0

extension NSToolbarItem {
    var userInfo:AnyObject? {
        get {
            return getAssociatedObject(self, key: &kUserInfoKey)
        }
        set {
            // TODO: What about nil
            setAssociatedObject(self, key: &kUserInfoKey, value: newValue!)
        }
    }
}

extension NSMenuItem {
    var userInfo:AnyObject? {
        get {
            return getAssociatedObject(self, key: &kUserInfoKey)
        }
        set {
            // TODO: What about nil
            setAssociatedObject(self, key: &kUserInfoKey, value: newValue!)
        }
    }
}

// MARK: -

extension NSGestureRecognizerState: CustomStringConvertible {
    public var description:String {
        get {
            switch self {
                case .Possible:
                    return "Possible"
                case .Began:
                    return "Began"
                case .Changed:
                    return "Changed"
                case .Ended:
                    return "Ended"
                case .Cancelled:
                    return "Cancelled"
                case .Failed:
                    return "Failed"
            }
        }
    }
}

// MARK: -

extension Array {
    func isSorted(isEqual: (T, T) -> Bool, isOrderedBefore: (T, T) -> Bool) -> Bool {
        let sortedCopy = sort(isOrderedBefore)
        for (lhs, rhs) in Zip2(self, sortedCopy) {
            if isEqual(lhs, rhs) == false {
                return false
            }
        }
        return true
    }

    mutating func insert(newElement: T, orderedBefore: (T, T) -> Bool) {
        for (index, element) in self.enumerate() {
            if orderedBefore(newElement, element) {
                insert(newElement, atIndex: index)
                return
            }
        }
        append(newElement)
    }
}

//extension Array {
//    mutating func removeObjectsAtIndices(indices:NSIndexSet) {
//        var index = indices.lastIndex
//
//        while index != NSNotFound {
//            removeAtIndex(index)
//            index = indices.indexLessThanIndex(index)
//        }
//    }
//}

// MARK: -

extension NSIndexSet {

    func with <T>(array:Array <T>, maxCount:Int = 512, block:Array <T> -> Void) {
        with(maxCount) {
            (buffer:UnsafeBufferPointer<Int>) -> Void in
            var items:Array <T> = []
            for index in buffer {
                items.append(array[index])
            }
            block(items)
        }
    }

    func with(maxCount:Int = 512, block:UnsafeBufferPointer <Int> -> Void) {

        var range = NSRange(location:0, length:self.count)
        var indices = Array <Int> (count:maxCount, repeatedValue: NSNotFound)
        indices.withUnsafeMutableBufferPointer() {
            (inout buffer:UnsafeMutableBufferPointer<Int>) -> Void in

            var count = 0
            repeat  {
                count = self.getIndexes(buffer.baseAddress, maxCount: maxCount, inIndexRange: &range)
                if count > 0 {
                    let constrained_buffer = UnsafeBufferPointer<Int> (start: buffer.baseAddress, count: count)
                    block(constrained_buffer)
                }
            }
            while count > 0
        }
    }
}