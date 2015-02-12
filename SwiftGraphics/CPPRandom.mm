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

#if defined(__cplusplus)
extern "C" {
#endif

void *NewMT19937Engine(UInt64 seed) {
    auto engine = new std::mt19937_64();
    engine->seed(seed);
    return engine;
}

void DeallocMT19937Engine(void *MT19937Engine) {
    auto engine = reinterpret_cast <std::mt19937_64 *> (MT19937Engine);
    delete engine;
}

UInt64 MT19937EngineGenerate(void *MT19937Engine, UInt64 lower, UInt64 upper) {
    auto engine = reinterpret_cast <std::mt19937_64 *> (MT19937Engine);
    std::uniform_int_distribution<UInt64> uniform(lower, upper);
    return uniform(*engine);
}


#if defined(__cplusplus)
}
#endif
