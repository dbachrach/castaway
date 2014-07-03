//
//  NSObject+Castaway.h
//  Castaway
//
//  Created by Dustin Bachrach on 7/3/14.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (Castaway)

- (BOOL(^)(void(^)(id)))as;

- (BOOL(^)(NSArray*))match;

@end
