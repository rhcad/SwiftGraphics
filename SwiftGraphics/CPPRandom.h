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
    void mt19937_64_srand(UInt64 seed);
    UInt64 mt19937_64_rand(void);
#if defined(__cplusplus)
}
#endif

#endif
