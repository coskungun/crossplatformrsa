//
//  NSString+Hex.m
//  RedChat
//
//  Created by Coşkun Güngör on 18/12/15.
//  Copyright © 2015 Big Data Labs. All rights reserved.
//

#import "NSString+Hex.h"

@implementation NSString (Hex)


- (NSString *)validateHex {
    
    // Squeeze out whitespace and detect illegal chars
    NSMutableString *string = [NSMutableString stringWithCapacity:[self length]];
    for (int i = 0; i < [self length]; i++) {
        unichar ch = [self characterAtIndex:i];
        if (isspace(ch))
            continue;
        if (!isxdigit(ch))
            return nil;
        [string appendFormat:@"%c", ch];
    }
    
    // Check length
    if ([string length] % 2 != 0)
        return nil;
    
    // Done
    return string;
}

- (NSData *)parseHex {
    NSMutableData *data = [NSMutableData data];
    for (const char *utf8 = [self UTF8String]; *utf8 != '\0'; utf8 += 2) {
        char substr[3] = { utf8[0], utf8[1], '\0' };
        int value;
        uint8_t byte;
        if (sscanf(substr, "%x", &value) != 1)
            return nil;
        byte = (uint8_t)value;
        [data appendBytes:&byte length:1];
    }
    return data;
}
@end
