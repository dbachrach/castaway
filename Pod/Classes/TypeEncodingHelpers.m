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
    
    static NSRegularExpression* s_regex = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_regex = [NSRegularExpression regularExpressionWithPattern:@"@\"(.*)\""
                                                          options:0
                                                            error:nil];
    });
    
    if (!s_regex) {
        return NO;
    }
    
    NSTextCheckingResult* result = [s_regex firstMatchInString:type
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
