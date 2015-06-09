// Playground - noun: a place where people can play

import Cocoa

import SwiftGraphics
import SwiftGraphicsPlayground

public typealias BitmapContextParameters = (width:UInt,height:UInt,bitsPerComponent:UInt,bytesPerRow:UInt,colorSpace:CGColorSpace,bitmapInfo:CGBitmapInfo)

enum BitmapContextMode {
    case RGBA_UINT8
    case RGBA_UINT16
}

public func expandBitmapContextParameters(size:CGSize, bitsPerComponent:Int, colorSpace:CGColorSpaceRef, alphaInfo:CGImageAlphaInfo, bitmapInfo:CGBitmapInfo) -> BitmapContextParameters? {

    let colorModel = CGColorSpaceGetModel(colorSpace)

    let numberOfColorComponents:Int = {
        switch colorModel.value {
            case kCGColorSpaceModelMonochrome.value:
                return 1
            case kCGColorSpaceModelRGB.value:
                return 3
            case kCGColorSpaceModelCMYK.value:
                return 4
            default:
                assert(false)
                return 0
        }
    }()

    if (bitmapInfo.rawValue & CGBitmapInfo.FloatComponents.rawValue != 0)
        {
        if bitsPerComponent != sizeof(Float) * 8 {
            return nil
        }
    }

    let hasAlphaComponent = alphaInfo != .None && alphaInfo != .Only
    let numberOfComponents:UInt = numberOfColorComponents + (hasAlphaComponent ? 1 : 0)

    let width = UInt(size.width)
    let height = UInt(size.height)
    let bitsPerPixel = UInt(bitsPerComponent) * numberOfComponents
    let bytesPerComponent = bitsPerPixel * numberOfComponents / 8
    let bytesPerRow = width * bytesPerComponent

    let tuple = (width, height, UInt(bitsPerComponent), bytesPerRow, colorSpace, bitmapInfo | CGBitmapInfo(alphaInfo.rawValue))

    return tuple
    }

public extension CGContext {
    class func bitmapContext(size:CGSize, bitsPerComponent:Int, colorSpace:CGColorSpaceRef, alphaInfo:CGImageAlphaInfo, bitmapInfo:CGBitmapInfo) -> CGContext! {

        let p = expandBitmapContextParameters(size, bitsPerComponent, colorSpace, alphaInfo, bitmapInfo)!

        return CGBitmapContextCreate(nil, p.width, p.height, p.bitsPerComponent, p.bytesPerRow, p.colorSpace, p.bitmapInfo)
    }
}


let size = CGSize(w:10, h:10)
let colorSpace = CGColorSpaceCreateDeviceRGB()

//     class func bitmapContext(size:CGSize, bitsPerComponent:UInt, colorSpace:CGColorSpaceRef, alphaInfo:CGImageAlphaInfo, bitmapInfo:CGBitmapInfo) -> CGContext! {

let alphaInfo = CGImageAlphaInfo.NoneSkipLast
let bitmapInfo = CGBitmapInfo() // CGBitmapInfo.FloatComponents
typealias ComponentType = UInt8

print(validParametersForBitmapContext(colorSpace:colorSpace, bitsPerPixel:sizeof(ComponentType) * 8 * 4, bitsPerComponent:sizeof(ComponentType) * 8, alphaInfo:alphaInfo, bitmapInfo:bitmapInfo))

let context = CGContextRef.bitmapContext(size, bitsPerComponent:sizeof(ComponentType) * 8, colorSpace: colorSpace, alphaInfo: alphaInfo, bitmapInfo: bitmapInfo)


CGContextSetAllowsAntialiasing(context, false)

context.setFillColor(CGColor.redColor())
CGContextFillRect(context, CGRect(size:size))

CGContextSetBlendMode(context, kCGBlendModeCopy)

context.setFillColor(CGColor.greenColor())
CGContextFillRect(context, CGRect(size:size))

let data = UnsafePointer <ComponentType> (CGBitmapContextGetData(context))
data[0]
data[1]
data[2]
data[3]


context.nsimage










