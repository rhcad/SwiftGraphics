//
//  Utilities.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/11/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

extension NSData {
    convenience init(contentsOfCompressedFile path:String) {
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

