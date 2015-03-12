// Playground - noun: a place where people can play

import SwiftGraphics

var m1 = Matrix(values:[1,2,3,4,5,6], columns:3, rows:2)
var m2 = Matrix(values:[7,8,9,10,11,12], columns:2, rows:3)
let m3 = m1 * m2

m1[(0,0)]

m3.description
let m4 = Matrix(values:[58.0, 64.0, 139.0, 154.0], columns:2, rows:2)
m3 == m4
