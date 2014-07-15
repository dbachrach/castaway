//
//  NSObject+Castaway.h
//  Castaway
//
//  Created by Dustin Bachrach on 7/3/14.
//
//

#import <Foundation/Foundation.h>


/**
 * castaway extensions to NSObject add safe and simple casting operations to all NSObjects.
 * To cast an object to a specific type use `-as`. To match an object to a series of types use `-match`.
 */
@interface NSObject (Castaway)

/**
 * Returns a function which performs the as operation.
 * The returned function takes a single argument -- the `As Block`, and it returns whether the cast was succesful.
 * The `As Block` is in the form `void(^)(id)`. Its only parameter is an object with the cast's intended type.
 * The `As Block` is executed if the cast succeeds.
 * 
 * Example:
 *
 *     NSObject* myObj;
 *     myObj.as(^(NSString* str) {
 *         // ...
 *     });
 * 
 * If myObj is (or is a subclass of) NSString, then the block will be executed and `str` will be `myObj` as an NSString.
 */
- (BOOL(^)(void(^)(id)))as;

/**
 * Attempts to cast this object to a specific type.
 * Returns whether the cast succeeded or not.
 * The `As Block` is in the form `void(^)(id)`. Its only parameter is an object with the cast's intended type.
 * The `As Block` is executed if the cast succeeds.
 *
 * Example:
 *
 *     id myObj;
 *     [myObj as:^(NSString* str) {
 *         // ...
 *     }];
 *
 * If myObj is (or is a subclass of) NSString, then the block will be executed and `str` will be `myObj` as an NSString.
 */
- (BOOL)as:(void(^)(id))block;

/**
 * Returns a function which performs the match operation.
 * The returned function takes an NSArray of `As Blocks`, and it returns the result of the `As Block` that is executed.
 * The `As Blocks` are in the form `id(^)(id)`. Their only parameter is an object with the cast's intended type.
 * The `As Block` is executed if the cast succeeds.
 * Only the first cast that succeeds is executed.
 * The return value from the executed `As Block` is returned from the call to -match.
 *
 * Example:
 *     NSObject* myObj;
 *     myObj.match(@[
 *         ^(NSString* str) {
 *              // ...
 *         },
 *         ^(NSNumber* num) {
 *              // ...
 *         }
 *     ]);
 *
 *   If myObj is (or is a subclass of) NSString, then the first block will be executed and `str` will be `myObj` as an NSString.
 *   If, instead, myObj is an NSNumber, then the second block will be executed and `num` will be `myObj` as an NSNumber.
 *   If myObj is not an NSString or NSNumber, neither block is executed.
 */
- (id(^)(NSArray*))match;

/**
 * Attempts to cast this object to one of the specified types.
 * Returns the result of the `As Block` that was executed.
 * Takes an NSArray of `As Blocks`, and it returns the result of the `As Block` that is executed.
 * The `As Blocks` are in the form `id(^)(id)`. Their only parameter is an object with the cast's intended type.
 * The `As Block` is executed if the cast succeeds.
 * Only the first cast that succeeds is executed.
 *
 * Example:
 *     id myObj;
 *     [myObj match:@[
 *         ^(NSString* str) {
 *              // ...
 *         },
 *         ^(NSNumber* num) {
 *              // ...
 *         }
 *     ]];
 *
 *   If myObj is (or is a subclass of) NSString, then the first block will be executed and `str` will be `myObj` as an NSString.
 *   If, instead, myObj is an NSNumber, then the second block will be executed and `num` will be `myObj` as an NSNumber.
 *   If myObj is not an NSString or NSNumber, neither block is executed.
 */
- (id)match:(NSArray*)patterns;

@end
