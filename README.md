# castaway

[![CI Status](http://img.shields.io/travis/Dustin Bachrach/castaway.svg?style=flat)](https://travis-ci.org/Dustin Bachrach/castaway)
[![Version](https://img.shields.io/cocoapods/v/castaway.svg?style=flat)](http://cocoadocs.org/docsets/castaway)
[![License](https://img.shields.io/cocoapods/l/castaway.svg?style=flat)](http://cocoadocs.org/docsets/castaway)
[![Platform](https://img.shields.io/cocoapods/p/castaway.svg?style=flat)](http://cocoadocs.org/docsets/castaway)

## What is it?

**castaway** is a simple library to add an `as` language construct to Objective-C.

```objc
id obj = /* get an object */;

obj.as(^(id<Drawable> drawable) {
    [drawable draw];
});
```

The typical way to do this without castaway is:

```objc
id obj = /* get an object */;

if ([obj conformsToProtocol:@protocol(Drawable)]) {
    [(id<Drawable>)obj draw];
}
```

It's verbose, repetitive, and the compiler isn't checking that you cast to the same protocol you checked for.

castaway makes it dead simple to write concise and declarative code that's safe.

castaway also includes a `match` construct to write safe type-dependent code for multiple cases.

```objc
id result = /* get a result */;

result.match(@[
    ^(NSArray* manyThings) {
        for (id thing in manyThings) { /* ... */ }
    },
    ^(NSString* str) {
        NSLog(@"The string: %@", str);
    },
    ^(UIView* view) {
        [view removeFromSuperview];
    }
]);
```

## Installation

castaway is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "castaway"

## Author

Dustin Bachrach, ahdustin@gmail.com

## Special thanks to [PromiseKit](https://github.com/mxcl/PromiseKit) by [Max Howell](https://github.com/mxcl) for  [NSMethodSignatureForBlock](https://github.com/mxcl/PromiseKit/blob/master/objc/Private/NSMethodSignatureForBlock.m).

## License

castaway is available under the MIT license. See the LICENSE file for more info.

