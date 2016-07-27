//
//  NSString+Hex.h
//  RedChat
//
//  Created by Coşkun Güngör on 18/12/15.
//  Copyright © 2015 Big Data Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Hex)
- (NSString *)validateHex;
- (NSData *)parseHex;
@end
