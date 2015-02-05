//
//  AppDelegate.swift
//  SwiftGraphics_OSX_Scratch
//
//  Created by Jonathan Wight on 1/25/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBAction func dumpResponderChain(sender:AnyObject?) {
        let window = NSApplication.sharedApplication().mainWindow
        let firstResponder = window?.firstResponder
        let contentView = window?.contentViewController?.view
        var responder:NSResponder? = contentView
        while responder != nil {
            println(responder!)
            if responder === firstResponder {
                println("^ FIRST RESPONDER")
            }
            responder = responder!.nextResponder
        }
    }
}

