# SwiftGraphics

## **IMPORTANT**

All development happens on the [develop][develop] branch. Code is merged back on master branch infrequently.

[develop]: https://github.com/schwa/SwiftGraphics/tree/develop

Also note this project is moving to Swift 1.2, which requires Xcode 6.3 and Mac OS X 10.10. Note that this changes breaks [Travis CI][issue58].

[issue58]:https://github.com/schwa/SwiftGraphics/issues/58

## Bringing Swift goodness to Quartz.

[![Travis][travis_img]][travis]

[travis]: https://travis-ci.org/schwa/SwiftGraphics
[travis_img]: https://travis-ci.org/schwa/SwiftGraphics.svg?branch=master

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
