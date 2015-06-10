//
//  RegularExpression.swift
//  Sketch
//
//  Created by Jonathan Wight on 8/31/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Foundation

struct RegularExpression {

    let expression: NSRegularExpression

    init?(_ pattern:String, options:NSRegularExpressionOptions = NSRegularExpressionOptions()) {
        do {
            self.expression = try NSRegularExpression(pattern:pattern, options:options)
        } catch {
            return nil
        }
    }

    func match(string:String, options:NSMatchingOptions = NSMatchingOptions()) -> Match? {
        let range = 0..<string._bridgeToObjectiveC().length
        if let result = expression.firstMatchInString(string, options:options, range:NSRange(range)) {
            return Match(string:string, result:result)
        }
        else {
            return nil
        }
    }

    struct Match {
        let string: String
        let result: NSTextCheckingResult
        
        init(string:String, result:NSTextCheckingResult) {
            self.string = string
            self.result = result
        }

        typealias Groups = BlockBackedCollection <Group>

        var groups: Groups {
            let count = result.numberOfRanges
            let groups = Groups(count:count) {
                (index:Int) -> Group in
                let range = self.result.rangeAtIndex(index)
                let string = self.string._bridgeToObjectiveC().substringWithRange(range)
                let group = Group(string:string, range:range)
                return group
                }
            return groups
        }

        struct Group {
            let string: String
            let range: NSRange
            
            init(string:String, range:NSRange) {
                self.string = string
                self.range = range
            }
        }
    }
}

//let groups = RegularExpression("([A-Za-z]+) ([A-Za-z]+)").match("Hello world").groups
//
//for f in groups {
//    print(f.string)
//}
