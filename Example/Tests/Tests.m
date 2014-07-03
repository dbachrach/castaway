//
//  castawayTests.m
//  castawayTests
//
//  Created by Dustin Bachrach on 07/03/2014.
//  Copyright (c) 2014 Dustin Bachrach. All rights reserved.
//

#import <castaway/NSObject+Castaway.h>

static const NSInteger INITIAL_VALUE = 0;
static const NSInteger SHAPE_AREA = 10;
static const NSInteger DRAW_VALUE = 20;
static const NSInteger SPLIT_VALUE = 30;
static const NSInteger SPIN_VALUE = 40;


@protocol Drawable <NSObject>

- (NSInteger)draw;

@end


@protocol Splitable <NSObject>

- (NSInteger)split;

@end


@protocol Printable <NSObject>

- (NSInteger)print;

@end


@interface Shape : NSObject

- (NSInteger)area;

@end


@implementation Shape

- (NSInteger)area
{
    return SHAPE_AREA;
}

@end


@interface Circle : Shape <Drawable, Splitable>

- (NSInteger)spin;

@end


@implementation Circle

- (NSInteger)spin
{
    return SPIN_VALUE;
}

- (NSInteger)draw
{
    return DRAW_VALUE;
}

- (NSInteger)split
{
    return SPLIT_VALUE;
}

@end


SpecBegin(InitialSpecs)

describe(@"[NSObject as]", ^{

    it(@"can cast to a protocol it supports", ^{
        __block NSInteger i = INITIAL_VALUE;
        
        Circle* c = [Circle new];
        c.as(^(id<Drawable> drawable) {
            i = [drawable draw];
        });
        expect(i).to.equal(DRAW_VALUE);
    });
    
    it(@"cannot cast to a protocol it does not support", ^{
        __block NSInteger i = INITIAL_VALUE;
        
        Circle* c = [Circle new];
        c.as(^(id<Printable> printable) {
            i = [printable print];
        });
        expect(i).to.equal(INITIAL_VALUE);
    });

    it(@"can cast to a class it inherits from", ^{
        __block NSInteger i = INITIAL_VALUE;
        
        Circle* c = [Circle new];
        c.as(^(Shape* shape) {
            i = [shape area];
        });
        expect(i).to.equal(SHAPE_AREA);
    });
    
    it(@"cannot cast to a class it does not inherit from", ^{
        __block NSInteger i = INITIAL_VALUE;
        
        Circle* c = [Circle new];
        c.as(^(NSString* string) {
            i = [string length];
        });
        expect(i).to.equal(INITIAL_VALUE);
    });
});

describe(@"[NSObject match]", ^{
    
    it(@"can match to a protocol it supports", ^{
        __block NSInteger i = INITIAL_VALUE;
        
        Circle* c = [Circle new];
        c.match(@[^(id<Drawable> drawable) {
            i = [drawable draw];
        }]);
        expect(i).to.equal(DRAW_VALUE);
    });
    
    it(@"cannot match to a protocol it does not support", ^{
        __block NSInteger i = INITIAL_VALUE;
        
        Circle* c = [Circle new];
        c.match(@[^(id<Printable> printable) {
            i = [printable print];
        }]);
        expect(i).to.equal(INITIAL_VALUE);
    });
    
    it(@"can match to a class it inherits from", ^{
        __block NSInteger i = INITIAL_VALUE;
        
        Circle* c = [Circle new];
        c.match(@[^(Shape* shape) {
            i = [shape area];
        }]);
        expect(i).to.equal(SHAPE_AREA);
    });
    
    it(@"cannot match to a class it does not inherit from", ^{
        __block NSInteger i = INITIAL_VALUE;
        
        Circle* c = [Circle new];
        c.match(@[^(NSString* string) {
            i = [string length];
        }]);
        expect(i).to.equal(INITIAL_VALUE);
    });
    
    it(@"matches to only the first protocol it supports", ^{
        __block NSInteger i = INITIAL_VALUE;
        
        Circle* c = [Circle new];
        c.match(@[
            ^(id<Drawable> drawable) {
                i = [drawable draw];
            },
            ^(id<Splitable> splitable) {
                i = [splitable split];
            },
        ]);
        expect(i).to.equal(DRAW_VALUE);
    });
    
    it(@"matches to only the first class it supports", ^{
        __block NSInteger i = INITIAL_VALUE;
        
        Circle* c = [Circle new];
        c.match(@[
            ^(Circle* circle) {
                i = [circle spin];
            },
            ^(NSObject* obj) {
                i = [obj hash];
            },
        ]);
        expect(i).to.equal(SPIN_VALUE);
    });
});

SpecEnd
