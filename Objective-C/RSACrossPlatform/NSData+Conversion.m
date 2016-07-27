//
//  NSData+Conversion.m
//  RedChat
//
//  Created by Coşkun Güngör on 01/12/15.
//  Copyright © 2015 Big Data Labs. All rights reserved.
//

#import "NSData+Conversion.h"

@implementation NSData (Conversion)
#pragma mark - String Conversion
- (NSString *)hexadecimalString {
    NSUInteger capacity = self.length * 2;
    NSMutableString *sbuf = [NSMutableString stringWithCapacity:capacity];
    const unsigned char *buf = self.bytes;
    NSInteger i;
    for (i=0; i<self.length; ++i) {
        [sbuf appendFormat:@"%02lX", (unsigned long)buf[i]];
    }
    
    return sbuf;
}


- (NSString *)hexadecimalStringNew {

    Byte *bytes = (Byte *)[self bytes];
    NSString *hexStr=@"";
    for(int i=0;i<[self length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///Hexdecimal
        if([newHexStr length]==1) {
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        } else {
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
        }
        
        //NSLog(@"bytes to hexadecimal:%@",hexStr);
        
    }

    return hexStr;

}
@end
