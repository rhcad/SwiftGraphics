# SwiftGraphics

## **IMPORTANT**

This branch is used only for Xcode 6.1 and Swift 1.1
The newest development happens on the [develop][develop] branch.

[develop]: https://github.com/schwa/SwiftGraphics/tree/develop

## Bringing Swift goodness to Quartz.

[![Travis][travis_img]][travis]
[![Version][podver_img]][podver_url]
[![Platform][platform_img]][podver_url]
[![Carthage][carthage_img]][carthage_url]

[travis]: https://travis-ci.org/rhcad/SwiftGraphics
[travis_img]: https://travis-ci.org/rhcad/SwiftGraphics.svg?branch=xcode61
[podver_url]: http://cocoadocs.org/docsets/SwiftGraphics
[podver_img]: https://img.shields.io/cocoapods/v/SwiftGraphics.svg
[platform_img]: https://img.shields.io/cocoapods/p/SwiftGraphics.svg
[carthage_img]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg
[carthage_url]: https://github.com/Carthage/Carthage

See "Help Wanted" section of this document for how you can contribute to SwiftGraphics.

[TODO]: TODO.markdown

## Philosophy

Wrap Quartz (and other related Frameworks such as CoreImage) in a nice "Swifthonic" API.

Provide wrappers and operators to help make working with graphics primitives in swift as 
convenient as possible.

## What's included

* Pragmatic operator overloading for CoreGraphics types including: CGPoint, CGSize, CGRect, CGAffineTransform
* Object Oriented extensions for CGContext (including easy creation of bitmap context), CGPath
* A bezier curve object that can represent curves of any order (including quadratic and
cubic of course)
* A path object that represents a bezier path - can be used to create and manipulate paths in a more natural way than CGPath or NSBezierPath can do 
* Fleshed out Geometry objects (Triangle, Ellipse, etc) allowing creating and introspection.
* Convex Hull Generation
* QuadTree data structure
* Metaballs (Marching Squares algorithm) implementation

![Convex Hull Screenshot](Documentation/ConvexHull.png)
![Metaballs Screenshot](Documentation/Metaballs.png)
![QuadTree Screenshot](Documentation/QuadTree.png)
![Ellipse Screenshot](Documentation/Ellipse.png)


## In Progress

All of this code is very much a _*work in progress*_. I'm adding and changing functionality as needed. As such I'm trying not to add code that isn't used (with some
exceptions).

## Project Structure

SwiftGraphics is made up of:

* Two SwiftGraphics dynamic frameworks (one for iOS and one for Mac OS X),
* A Mac OS X only SwiftGraphicsPlayground framework (containing code generally useful when using Playground)
* A directory of Playground files
* A Mac OS X testbed app “SwiftGraphics_OSX_UITest” that highlights some of the more interactive code
* Unit Test Targets

## Installation

You can add SwiftGraphics in your project as one of the following ways:

- Add SwiftGraphics.xcodeproj to your project and set up your dependencies appropriately.
  You can add SwiftGraphics as a submodule by opening the Terminal, trying to enter the command:
  
  ```sh
  git submodule add https://github.com/rhcad/SwiftGraphics.git
  ```

- Install with [Carthage][carthage_url] (Recommended):
 
  1. Add `github "rhcad/SwiftGraphics"` to your project Cartfile.
  2. Run `carthage update` to download and build SwiftGraphics.
  3. Drag SwiftGraphics.framework to your project and link it.

- Install with CocoaPods [v0.36.0+][CocoaPods beta] and add the following to your project Podfile:

  ```
  platform :ios, '8.0'
  use_frameworks!
  pod 'SwiftGraphics/iOS'
  ```
  
  or
  
  ```
  platform :osx, '10.9'
  use_frameworks!
  pod 'SwiftGraphics/OSX'
  ```

[CocoaPods beta]: https://github.com/CocoaPods/swift

## Usage

SwiftGraphics builds iOS and OS X frameworks. Just add SwiftGraphics.xcodeproj to your project and set up your dependencies appropriately.

You can play with SwiftGraphics in Xcode 6 Playgrounds. **IMPORTANT** just make sure you compile the SwiftGraphicsPlayground target before trying to run any Playgrounds.

## Help Wanted

Your help wanted. I would definitely appreciate contributions from other members of the Swift/Cocoa community. Please fork this project and submit pull requests.

You can help by using Swift Graphics in your projects and discovering its shortcomings. I encourage you to file [issues][issues] against this project.

[issues]: https://github.com/schwa/SwiftGraphics/issues

Contributions are always welcome in the following areas:

* Header doc comments explaining what the functions do
* Unit tests
* Playgrounds showing graphically what SwiftGraphics can do
* New graphical algorithms (take your pick from [wikipedia][wikipedia])
* New geometry structs

[wikipedia]: https://en.wikipedia.org/wiki/Category:Computer_graphics_algorithms

## Code Life Cycle

All development occurs on the develop branch. New code starts either as a Playground or as a tab inside the houseSwiftGraphics_OSX_UITest application target.

As code proves itself to be useful it is added to the SwiftGraphicsPlayground target and shared with all Playgrounds.

If code is generally useful it is moved directly to the SwiftGraphics target.

## License

See LICENSE for more information
