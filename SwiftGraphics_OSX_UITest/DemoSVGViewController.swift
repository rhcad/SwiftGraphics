//
//  DemoSVGViewController.swift
//  SwiftGraphicsDemo
//
//  Created by Jonathan Wight on 9/7/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

import Cocoa

import SwiftGraphics

class DemoSVGViewController: NSViewController {

    var svgView:SVGView! { get { return view as! SVGView } }

    override func viewDidLoad() {
        super.viewDidLoad()
//        let URL = NSBundle.mainBundle().URLForResource("SwiftOutline", withExtension:"svg")
//        let XMLDocument = NSXMLDocument(contentsOfURL:URL!, options:0, error:nil)
//        var parser = SVGParser()
//        let document = parser.parseDocument(XMLDocument)
//        svgView.document = document
    }
}
