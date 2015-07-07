//
//  MagicConsole.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/9/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa

extension NSMutableArray {
    func append(anObject:AnyObject) {
        addObject(anObject)
    }
}

class MagicConsole: NSObject {

    class Row: NSObject {
        @objc var name:NSString?
        @objc var stringValue:NSString?
    }

    @objc var rows = NSMutableArray()
    var rowsForKey:[String:Row] = [:]

    override init() {
        super.init()
    }

    func logValue(key:String, value:CustomStringConvertible) {
        if let row = rowsForKey[key] {
            row.willChangeValueForKey("stringValue")
            row.stringValue = value.description as NSString
            row.didChangeValueForKey("stringValue")
        }
        else {
            let row = Row()
            row.name = key as NSString
            row.stringValue = value.description as NSString
            self.willChangeValueForKey("rows")
            rows.append(row)
            self.didChangeValueForKey("rows")
            rowsForKey[key] = row
        }
    }
}

func MagicLog(name:String, _ value:CustomStringConvertible) {
    sharedMagicConsole.logValue(name, value: value)
}

let sharedMagicConsole = MagicConsole()

class MagicConsoleViewController: NSViewController {

    var magicConsole:MagicConsole? = sharedMagicConsole

}