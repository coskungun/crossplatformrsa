//
//  NSData+HexDump.h
//  RedChat
//
//  Created by Coşkun Güngör on 17/12/15.
//  Copyright © 2015 Big Data Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (HexDump)
- (NSString *)hexval;
- (NSData *)hexdump:(NSString *)_asasa;
- (NSString *) stringToHex:(NSString *)str;
- (NSString *) stringFromHex:(NSString *)str;
-(id)dataWithHexString:(NSString *)hex;
@end
