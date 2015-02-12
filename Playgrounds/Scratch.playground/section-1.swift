// Playground - noun: a place where people can play

import Cocoa

struct Foo {
    var bar:Int {
        didSet {
            println("DIDSET \(bar)")
        }
    }

    init() {
        bar = 100
    }

}

var f = Foo()
f.bar = 200
