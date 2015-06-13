//
//  DrawCache.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 6/12/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation
import SwiftGraphics


class Cache <Key, Value:AnyObject> {

    let cache = NSCache()

    func get(key:Key) -> Value? {
        return cache.objectForKey(key as! AnyObject) as? Value
    }

    func set(key:Key, value:Value) {
        return cache.setObject(value, forKey:key as! AnyObject)
    }

//    subscript (key:Key) -> Value? {
//        get {
//            return cache.objectForKey(key as! AnyObject) as? Value
//        }
//        set(newValue) {
//            cache.setObject(newValue!, forKey: key as! AnyObject)
//        }
//    }

}



let cache = Cache <String, CGImage> ()

func drawCache(key:String, frame:CGRect, block:CGContext -> Void) -> CGImage? {

    if let image = cache.get(key) {
        return image
    }

    let context = CGContext.bitmapContext(frame)
    context.with() {
        print("MISS")
        block(context)
    }

    let image = CGBitmapContextCreateImage(context)!

    cache.set(key, value: image)



    return image
}



