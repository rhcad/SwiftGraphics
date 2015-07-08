#!/bin/bash

xcodebuild -version | grep "Xcode 7." > /dev/null || { echo 'Not running Xcode 7' ; exit 1; }

cd `git rev-parse --show-toplevel`

xctool -project SwiftGraphics.xcodeproj -scheme SwiftGraphics_OSX build test || exit $!
#xctool -project SwiftGraphics.xcodeproj -scheme SwiftGraphics_OSX_Playground build test  || exit $!
#xctool -project SwiftGraphics.xcodeproj -scheme SwiftGraphics_OSX_Scratch build test
#xctool -project SwiftGraphics.xcodeproj -scheme SwiftGraphics_OSX_UITest build test
#xctool -project SwiftGraphics.xcodeproj -scheme SwiftGraphics_iOS -sdk iphonesimulator build
