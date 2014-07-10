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


@interface CASAsResult : NSObject

@property (nonatomic) BOOL matched;
@property (strong, nonatomic) id result;

+ (instancetype)matchedWithResult:(id)result;
+ (instancetype)unmatched;

@end


@implementation CASAsResult

+ (instancetype)matchedWithResult:(id)result
{
    CASAsResult* asResult = [[CASAsResult alloc] init];
    asResult.matched = YES;
    asResult.result = result;
    return asResult;
}

+ (instancetype)unmatched
{
    CASAsResult* asResult = [[CASAsResult alloc] init];
    asResult.matched = NO;
    return asResult;
}

@end


@implementation NSObject (Castaway)

- (CASAsResult*(^)(id(^)(id)))CASInternalAs
{
    return [^CASAsResult*(id(^block)(id)) {
        NSMethodSignature* methodSignature = NSMethodSignatureForBlock(block);
        
        const char* argType = [methodSignature getArgumentTypeAtIndex:1];
        NSString* type = [NSString stringWithUTF8String:argType];
        
        Protocol* protocol = NSProtocolFromTypeEncoding(type);
        if (protocol && [self conformsToProtocol:protocol]) {
            id result = block(self);
            return [CASAsResult matchedWithResult:result];
        }
        
        Class class = NSClassFromTypeEncoding(type);
        if (class && [self isKindOfClass:class]) {
            id result = block(self);
            return [CASAsResult matchedWithResult:result];
        }
        
        if ([type isEqualToString:@"@"]) {
            // If the type is `id`, consider that a succesful cast.
            id result = block(self);
            return [CASAsResult matchedWithResult:result];
        }
        
        return [CASAsResult unmatched];
    } copy];
}

- (BOOL(^)(id(^)(id)))as
{
    return [^BOOL(id(^block)(id)) {
        CASAsResult* asResult = self.CASInternalAs(block);
        return asResult.matched;
    } copy];
}

- (id(^)(NSArray*))match
{
    return [^id(NSArray* patterns) {
        for (id(^block)(id) in patterns) {
            CASAsResult* asResult = self.CASInternalAs(block);
            if (asResult.matched) {
                return asResult.result;
            }
        }
        return nil;
    } copy];
}

@end
