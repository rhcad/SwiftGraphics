//
//  C++Random.h
//  SwiftGraphics
//
//  Created by Jonathan Wight on 2/12/15.
//  Copyright (c) 2015 schwa.io. All rights reserved.
//

#ifndef SwiftGraphics_C__Random_h
#define SwiftGraphics_C__Random_h

#if defined(__cplusplus)
extern "C" {
#endif

    void *NewMT19937Engine(UInt64 seed);
    void DeallocMT19937Engine(void *MT19937Engine);
    UInt64 MT19937EngineGenerate(void *MT19937Engine, UInt64 lower, UInt64 upper);
#if defined(__cplusplus)
}
#endif

#endif
