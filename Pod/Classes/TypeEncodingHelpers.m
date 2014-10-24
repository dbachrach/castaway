//
//  TypeEncodingHelpers.m
//  Castaway
//
//  Created by Dustin Bachrach on 7/3/14.
//
//

#import "TypeEncodingHelpers.h"

@class Protocol;

BOOL NSClassAndProtocolFromTypeEncoding(NSString* type, Class* cls, Protocol** prt)
{
    *cls = nil;
    *prt = nil;
    
    static NSRegularExpression* regex = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"@\"(.*)\""
                                                          options:0
                                                            error:nil];
    });
    
    if (!regex) {
        return NO;
    }
    
    NSTextCheckingResult* result = [regex firstMatchInString:type
                                                     options:0
                                                       range:NSMakeRange(0, type.length)];
    
    if (result.range.location != NSNotFound) {
        NSString* name = [type substringWithRange:[result rangeAtIndex:1]];
        if ([name hasPrefix:@"<"]) {
            *prt = NSProtocolFromString([name substringWithRange:NSMakeRange(1, name.length - 2)]);
            return YES;
        }
        else {
            *cls = NSClassFromString(name);
            return YES;
        }
    }
    
    return NO;
}
