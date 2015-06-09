//
//  File.swift
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/10/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa
import SwiftGraphics

extension NSGestureRecognizer {

    typealias Callback = Void -> Void

    convenience init(callback:Callback?) {
        self.init(target:callbackHelper, action:Selector("event:"))

        if let callback = callback {
            addCallback(callback)
        }
    }

    var callbacks:[Callback] {
        get {
            let callbacks = getAssociatedWrappedObject(self, key: &callbackKey) as? [Callback]
            if let callbacks = callbacks {
                return callbacks
            }
            else {
                return []
            }
        }
        set {
            setAssociatedWrappedObject(self, key: &callbackKey, value: newValue)
        }
    }

    func addCallback(callback:Callback) {

        if target !== callbackHelper && action != Selector("event:") {
            convert()
        }

        var callbacks = self.callbacks
        callbacks.append(callback)
        self.callbacks = callbacks
    }

//    func removeCallback(callback:Callback) {
//        var callbacks = self.callbacks
//        callbacks.append(callback)
//
//        self.callbacks = callbacks
//
//    }

    internal func convert() {
        let savedTarget: AnyObject? = target
        let savedAction = action

        target = callbackHelper
        action = Selector("event:")

        addCallback() {
            [unowned self] in
            if let actionBlock = savedTarget?.blockForSelector(savedAction, withObject: self) {
                actionBlock()
            }
        }
    }
}

class CallbackHelper: NSObject {

    func event(gestureRecognizer:NSGestureRecognizer) {
        for callback in gestureRecognizer.callbacks {
            callback()
        }
    }
}

var callbackKey = 0

let callbackHelper = CallbackHelper()