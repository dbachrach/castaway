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

#import <objc/runtime.h>


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
    
    if ([type isEqualToString:@"#"] && class_isMetaClass(object_getClass(obj))) {
        // If the type is `Class`
        return YES;
    }
    
    if ([type isEqualToString:@"@"]) {
        // If the type is `id`, consider that a succesful cast.
        return YES;
    }
    
    return NO;
}

/**
 * Calls a block passing data as its only argument.
 * Supports calling blocks with any return type, and normalizes it to returning id.
 * Modified from PromiseKit
 */
static id CASCallDynamicBlock(id block, id data)
{
    NSMethodSignature *sig = NSMethodSignatureForBlock(block);
    const char rtype = sig.methodReturnType[0];
    
    switch (rtype) {
        case 'v':
            ((void(^)(id))block)(data);
            return nil;
        case '@':
            return ((id(^)(id))block)(data);
        case '#':
            return ((Class(^)(id))block)(data);
        case '*': {
            char *str = ((char*(^)(id))block)(data);
            return str ? @(str) : nil;
        }
        case 'c': return @(((char(^)(id))block)(data));
        case 'i': return @(((int(^)(id))block)(data));
        case 's': return @(((short(^)(id))block)(data));
        case 'l': return @(((long(^)(id))block)(data));
        case 'q': return @(((long long(^)(id))block)(data));
        case 'C': return @(((unsigned char(^)(id))block)(data));
        case 'I': return @(((unsigned int(^)(id))block)(data));
        case 'S': return @(((unsigned short(^)(id))block)(data));
        case 'L': return @(((unsigned long(^)(id))block)(data));
        case 'Q': return @(((unsigned long long(^)(id))block)(data));
        case 'f': return @(((float(^)(id))block)(data));
        case 'd': return @(((double(^)(id))block)(data));
        case 'B': return @(((_Bool(^)(id))block)(data));
        case '^':
            if (strcmp(sig.methodReturnType, "^v") == 0) {
                ((void(^)(id))block)(data);
                return nil;
            }
            // else fall through!
        default:
            @throw [NSException exceptionWithName:@"castaway" reason:@"castaway: unknown return type" userInfo:nil];
    }
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
    for (id block in patterns) {
        if (CASObjectCastsToBlock(self, block)) {
            return CASCallDynamicBlock(block, self);
        }
    }
    return nil;
}

@end
