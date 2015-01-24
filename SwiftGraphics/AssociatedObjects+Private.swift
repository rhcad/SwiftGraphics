//
//  AssociatedObjects+Private.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 1/24/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Foundation

// MARK: Associated Objects

public func getAssociatedObject(object:AnyObject, key: UnsafePointer<Void>) -> AnyObject? {
    return objc_getAssociatedObject(object, key)
}

public func setAssociatedObject(object:AnyObject, key: UnsafePointer<Void>, value:AnyObject) {
    objc_setAssociatedObject(object, key, value, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
}

// TODO: Rename ObjCBox?
@objc class StructWrapper {
    var wrapped:Any
    init(wrapped:Any) {
        self.wrapped = wrapped
    }
}

public func getAssociatedObject(object:AnyObject, key: UnsafePointer<Void>) -> Any? {
    let wrapper = objc_getAssociatedObject(object, key) as StructWrapper?
    if let wrapper = wrapper {
        return wrapper.wrapped
    }
    else {
        return nil
    }
}

public func setAssociatedObject(object:AnyObject, key: UnsafePointer<Void>, value:Any) {
    let wrapper = StructWrapper(wrapped:value)
    objc_setAssociatedObject(object, key, wrapper, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
}


public func getAssociatedObject <T> (object:AnyObject, key: UnsafePointer<Void>, defaultValue:T) -> T {
    let wrapper = objc_getAssociatedObject(object, key) as StructWrapper?
    if let wrapper = wrapper {
        return wrapper.wrapped as T
    }
    else {
        return defaultValue
    }
}

public func setAssociatedObject <T> (object:AnyObject, key: UnsafePointer<Void>, value:T) {
    let wrapper = StructWrapper(wrapped:value)
    objc_setAssociatedObject(object, key, wrapper, UInt(OBJC_ASSOCIATION_RETAIN_NONATOMIC))
}
