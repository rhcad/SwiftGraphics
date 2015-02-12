//
//  C++Random.m
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <random>

// TODO: Thread safety?

// See: http://www.johndcook.com/blog/cpp_TR1_random/

static std::mt19937_64 engine;
static std::uniform_int_distribution<UInt64> unif(0, UINT64_MAX);

#if defined(__cplusplus)
extern "C" {
#endif

void mt19937_64_srand(UInt64 seed) {
    engine.seed(seed);
}

UInt64 mt19937_64_rand(void) {
    return unif(engine);
}

#if defined(__cplusplus)
}
#endif
