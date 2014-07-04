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
        NSString* type = [NSString stringWithUTF8String:argType];
        
        Protocol* protocol = NSProtocolFromTypeEncoding(type);
        if (protocol && [self conformsToProtocol:protocol]) {
            block(self);
            return YES;
        }
        
        Class class = NSClassFromTypeEncoding(type);
        if (class && [self isKindOfClass:class]) {
            block(self);
            return YES;
        }
        
        if ([type isEqualToString:@"@"]) {
            // If the type is `id`, consider that a succesful cast.
            block(self);
            return YES;
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
