//
//  TypeEncodingHelpers.h
//  castaway
//
//  Created by Dustin Bachrach on 7/16/14.
//
//

#import <Foundation/Foundation.h>

Protocol* NSProtocolFromTypeEncoding(NSString* type);

Class NSClassFromTypeEncoding(NSString* type);
