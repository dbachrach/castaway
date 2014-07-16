//
//  TypeEncodingHelpers.m
//  Castaway
//
//  Created by Dustin Bachrach on 7/3/14.
//
//

#import "TypeEncodingHelpers.h"

Protocol* NSProtocolFromTypeEncoding(NSString* type)
{
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"@\"<(.*)>\""
                                                                           options:0
                                                                             error:&error];
    if (error) {
        return nil;
    }
    
    NSTextCheckingResult* result = [regex firstMatchInString:type
                                                     options:0
                                                       range:NSMakeRange(0, type.length)];
    
    if (result.range.location != NSNotFound) {
        NSString* protocolName = [type substringWithRange:[result rangeAtIndex:1]];
        return NSProtocolFromString(protocolName);
    }
    
    return nil;
}

Class NSClassFromTypeEncoding(NSString* type)
{
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"@\"(.*)\""
                                                                           options:0
                                                                             error:&error];
    if (error) {
        return nil;
    }
    
    NSTextCheckingResult* result = [regex firstMatchInString:type
                                                     options:0
                                                       range:NSMakeRange(0, type.length)];
    
    if (result.range.location != NSNotFound) {
        NSString* className = [type substringWithRange:[result rangeAtIndex:1]];
        return NSClassFromString(className);
    }
    
    return nil;
}