//
//  NSObject+Extensions.m
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/10/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

#import "NSObject+Extensions.h"

@implementation NSObject (Extensions)

- (selector_block_t)blockForSelector:(SEL)inSelector withObject:(id)inObjact {

    __weak id weak_self = self;

    selector_block_t block = ^{
        [weak_self performSelector:inSelector withObject:inObjact];
    };
    return block;
}

@end
