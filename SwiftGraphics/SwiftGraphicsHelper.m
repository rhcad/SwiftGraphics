//
//  SwiftGraphicsHelper.m
//  SwiftGraphics
//
//  Created by Jonathan Wight on 8/27/14.
//  Copyright (c) 2014 schwa.io. All rights reserved.
//

#import "SwiftGraphicsHelper.h"

static void MyCGPathApplierFunction(void *info, const CGPathElement *element);

void CGPathApplyWithBlock (CGPathRef inPath, __attribute__((noescape)) CGPathApplierBlock block) {
    CGPathApply(inPath, (__bridge void *)block, MyCGPathApplierFunction);
}
    
static void MyCGPathApplierFunction(void *info, const CGPathElement *element) {
    CGPathApplierBlock block = (__bridge CGPathApplierBlock)info;
    block(element);
}
