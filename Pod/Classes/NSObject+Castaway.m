//
//  NSObject+Castaway.m
//  Castaway
//
//  Created by Dustin Bachrach on 7/3/14.
//
//

#import "NSObject+Castaway.h"
#import "NSMethodSignatureForBlock.m"
#import "TypeEncodingHelpers.m"


@implementation NSObject (Castaway)

- (BOOL(^)(void(^)(id)))as
{
    return [^BOOL(void(^block)(id)) {
        NSMethodSignature* methodSignature = NSMethodSignatureForBlock(block);
        const char* argType = [methodSignature getArgumentTypeAtIndex:1];
        
        Protocol* protocol = NSProtocolFromTypeEncoding(argType);
        
        if (protocol && [self conformsToProtocol:protocol]) {
            block(self);
            return YES;
        }
        else {
            Class class = NSClassFromTypeEncoding(argType);
            if (class && [self isKindOfClass:class]) {
                block(self);
                return YES;
            }
        }
        return NO;
    } copy];
}

- (BOOL(^)(NSArray*))match
{
    return [^(NSArray* patterns) {
        for (void(^block)(id) in patterns) {
            if (self.as(block)) {
                return YES;
            }
        }
        return NO;
    } copy];
}

@end
