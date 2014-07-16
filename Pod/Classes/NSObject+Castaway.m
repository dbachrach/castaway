//
//  NSObject+Castaway.m
//  Castaway
//
//  Created by Dustin Bachrach on 7/3/14.
//
//

#import "NSObject+Castaway.h"
#import "NSMethodSignatureForBlock.h"
#import "TypeEncodingHelpers.h"


/**
 * Returns whether the object can be cast to the type of the block's first argument.
 */
static BOOL CASObjectCastsToBlock(id obj, id block)
{
    NSMethodSignature* methodSignature = NSMethodSignatureForBlock(block);
    
    const char* argType = [methodSignature getArgumentTypeAtIndex:1];
    NSString* type = [NSString stringWithUTF8String:argType];
    
    Protocol* protocol = NSProtocolFromTypeEncoding(type);
    if (protocol && [obj conformsToProtocol:protocol]) {
        return YES;
    }
    
    Class class = NSClassFromTypeEncoding(type);
    if (class && [obj isKindOfClass:class]) {
        return YES;
    }
    
    if ([type isEqualToString:@"@"]) {
        // If the type is `id`, consider that a succesful cast.
        return YES;
    }
    
    return NO;
}

@implementation NSObject (Castaway)

- (BOOL(^)(void(^)(id)))as
{
    return [^BOOL(void(^block)(id)) {
        return [self as:block];
    } copy];
}

- (BOOL)as:(void(^)(id))block
{
    if (CASObjectCastsToBlock(self, block)) {
        block(self);
        return YES;
    }
    return NO;
}

- (id(^)(NSArray*))match
{
    return [^id(NSArray* patterns) {
        return [self match:patterns];
    } copy];
}

- (id)match:(NSArray*)patterns
{
    for (id(^block)(id) in patterns) {
        if (CASObjectCastsToBlock(self, block)) {
            return block(self);
        }
    }
    return nil;
}

@end
