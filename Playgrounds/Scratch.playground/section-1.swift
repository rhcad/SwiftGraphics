// Playground - noun: a place where people can play

import Cocoa

import SwiftGraphics

let context = CGContext.bitmapContext(CGRect(x:100, y:100, w:100, h:100), color:CGColor.redColor())


context.fillColor = CGColor.blueColor()
context.fillRect(CGRect(x:110, y:110, w:80, h:80))

context.nsimage
