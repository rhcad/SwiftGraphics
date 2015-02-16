//
//  SwiftGraphicsHelper.h
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/27/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>

typedef void (^CGPathApplierBlock)(const CGPathElement *element);

extern void CGPathApplyWithBlock(CGPathRef inPath, CGPathApplierBlock block);

extern void CGPathFromSVGPath(CGMutablePathRef inPath, const char* s);
