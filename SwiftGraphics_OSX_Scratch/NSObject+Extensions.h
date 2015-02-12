//
//  NSObject+Extensions.h
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/10/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^selector_block_t)(void);

@interface NSObject (Extensions)

- (selector_block_t)blockForSelector:(SEL)inSelector withObject:(id)inObjact;

@end
