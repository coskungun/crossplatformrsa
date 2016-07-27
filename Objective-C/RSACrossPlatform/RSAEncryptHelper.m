//
//  RSAEncryptHelper.m
//  RedChat
//
//  Created by Coşkun Güngör on 20/11/15.
//  Copyright © 2015 Big Data Labs. All rights reserved.
//

#import "RSAEncryptHelper.h"
#import "MIHRSAKeyFactory.h"
#import "MIHKeyPair.h"
#import "MIHRSAPublicKey.h"
#import "MIHRSAPrivateKey.h"
#import "MIHPublicKey.h"
#import "MIHBigInteger.h"
#import "NSData+Conversion.h"
#import "NSData+HexDump.h"
#import "NSString+Hex.h"
@implementation RSAEncryptHelper


+(RSAEncryptHelper *)sharedManager
{
    static RSAEncryptHelper *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    
    return manager;
}

-(MIHKeyPair *)generateRunTimeKeyPair
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    MIHKeyPair *retrievedDictionary;
    if (![[def objectForKey:@"keyGenereted"]isEqualToString:@"1"])
    {
    
        MIHRSAKeyFactory *mm = [[MIHRSAKeyFactory alloc]init];
        mm.preferedKeySize = 128;
        MIHKeyPair *kPair = [mm generateKeyPair];
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setValue:[NSKeyedArchiver archivedDataWithRootObject:kPair] forKey:@"MyData"];
        [def setValue:@"1" forKey:@"keyGenereted"];
        [def synchronize];
        NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
        NSData *data = [defa objectForKey:@"MyData"];
        retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }else
    {
        NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
        NSData *data = [defa objectForKey:@"MyData"];
        retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return retrievedDictionary;
}

-(NSString *)NewEncrtypTextMsg:(NSString *)_text pubKey:(NSString *)_pubKey /// calisan
{
    NSData *mData = [_text dataUsingEncoding:NSUTF8StringEncoding];
    NSData *newData = [self myblockYap:mData mode:ENCRYPT pubKey:_pubKey];
    Byte *bb = (Byte *)newData.bytes;
    NSString *sasasas = [[[NSData dataWithBytes:bb length:newData.length] hexadecimalString]lowercaseString];
    return sasasas;
}

-(NSString *)NewDecryptMessage:(NSString *)_val ////calisan
{
    NSData *aada = [_val dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *mString = [[NSMutableString alloc]init];
    Byte *bytes = (Byte *)aada.bytes;
    for (NSInteger aa = 0; aa<aada.length; aa++) {
        [mString appendString:[NSString stringWithFormat:@"%c",bytes[aa]]];
    }
    NSString *asdasd= [self stringFromHex:mString];
    NSData *newData = [self myblockCoz:asdasd mode:DECRYPT];
    if (newData.length == 0)
    {
        asdasd= [self stringFromHexMe:mString];
        newData = [self myblockCoz:asdasd mode:DECRYPT];
    }
    return [[NSString alloc]initWithData:newData encoding:NSUTF8StringEncoding];
}

-(NSString *)NewDecryptMessageMZE:(NSString *)_val ////calisan
{
    MIHKeyPair *retrievedDictionary = [[MIHKeyPair alloc]init];
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    NSData *data = [defa objectForKey:@"MyData"];
    retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSError *err;
    NSData *_bytes = [[NSData alloc]initWithBase64EncodedString:_val options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *ddPrivate = [retrievedDictionary.private dataValue];
    MIHRSAPrivateKey *pKey = [[MIHRSAPrivateKey alloc]initWithData:ddPrivate];
    
    //NSData *aada = [_val dataUsingEncoding:NSUTF8StringEncoding];
    
    
    NSData *newData = [pKey decrypt:_bytes error:&err];
    return [[NSString alloc]initWithData:newData encoding:NSUTF8StringEncoding];
}




-(NSString *)NewDecryptMessageMe:(NSString *)_val ////calisan
{
    NSData *aada = [_val dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *mString = [[NSMutableString alloc]init];
    UInt8 *bytes = (UInt8 *)aada.bytes;
    for (NSInteger aa = 0; aa<aada.length; aa++) {
        [mString appendString:[NSString stringWithFormat:@"%c",bytes[aa]]];
    }
    NSString *asdasd= [self stringFromHex:mString];
    NSData *newData = [self myblockCoz:asdasd mode:DECRYPT];
    return [[NSString alloc]initWithData:newData encoding:NSUTF8StringEncoding];
}

- (NSString *) stringFromHexMe:(NSString *)str
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    
    return [[NSString alloc] initWithData:stringData encoding:NSASCIIStringEncoding];
}

- (NSString *) stringFromHex:(NSString *)str
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    NSData *aa = [stringData base64EncodedDataWithOptions:NSUTF8StringEncoding];
    return [[NSString alloc] initWithData:aa encoding:NSUTF8StringEncoding];
}


- (NSString *) stringToHex:(NSString *)str
{
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    
    return hexString;
}

-(NSString *)encrtypTextMessageMe:(NSString *)_message
{
    MIHKeyPair *retrievedDictionary = [[MIHKeyPair alloc]init];
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    NSData *data = [defa objectForKey:@"MyData"];
    
    retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSData *datam2 = [[NSData alloc]initWithBase64EncodedString:[NSString stringWithFormat:@"%@",retrievedDictionary.public] options:NSDataBase64DecodingIgnoreUnknownCharacters];
    MIHRSAPublicKey *public = [[MIHRSAPublicKey alloc]initWithData:datam2];
    NSData *ddaa = [_message dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSData *ddadsad = [public encrypt:ddaa error:&err];
    NSData *aa = [ddadsad base64EncodedDataWithOptions:NSUTF8StringEncoding];
    return [[NSString alloc]initWithData:aa encoding:NSUTF8StringEncoding];
}
-(NSData *)myblockYap:(NSData *)_bytes mode:(ENCRYPT_MODE)_mode pubKey:(NSString *)_pubKey
{
    NSData *datam2 = [[NSData alloc]initWithBase64EncodedString:_pubKey options:NSDataBase64DecodingIgnoreUnknownCharacters];
    MIHRSAPublicKey *public = [[MIHRSAPublicKey alloc]initWithData:datam2];
    NSError *err;
    NSMutableData *scramled = [[NSMutableData alloc]init];
    [scramled setLength:0];
    NSMutableData *toReturn = [[NSMutableData alloc]init];
    [toReturn setLength:0];
    
    NSInteger length = 0;
    if (_mode == ENCRYPT)
        length = 100;
    else
        length = 128;
    
    NSMutableData *buffer = [[NSMutableData alloc]init];
    [buffer setLength:length];
    
    UInt8 *bytes = (UInt8 *)_bytes.bytes;
    
    for (NSInteger i = 0; i< _bytes.length; i++) {
   
        if ((i > 0) && (i % length == 0))
        {
       
            
            [scramled setData:[public encrypt:buffer error:&err]];
            
            
            toReturn = [self customAppend:toReturn suffix:scramled];
            // toReturn method gelecek
            
            
            NSInteger newLength = length;
            
            if (i+length > _bytes.length)
            {
                newLength = _bytes.length - i;
            }
            
            buffer =  [NSMutableData new];
            [buffer setLength:newLength];
            
        }
         
        UInt8 *bufferbytes = (UInt8 *)buffer.bytes;
        bufferbytes[i%length] = bytes[i];
    }
    
    [scramled setData:[public encrypt:buffer error:&err]];
    
    toReturn = [self customAppend:toReturn suffix:scramled];
    
    return toReturn;
}

-(NSData *)myblockCoz:(NSString*)_val mode:(ENCRYPT_MODE)_mode
{
    MIHKeyPair *retrievedDictionary = [[MIHKeyPair alloc]init];
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    NSData *data = [defa objectForKey:@"MyData"];
    retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSError *err;
    NSData *_bytes = [[NSData alloc]initWithBase64EncodedString:_val options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *ddPrivate = [retrievedDictionary.private dataValue];
    MIHRSAPrivateKey *pKey = [[MIHRSAPrivateKey alloc]initWithData:ddPrivate];

    
    NSMutableData *scramled = [[NSMutableData alloc]init];
    [scramled setLength:0];
    NSMutableData *toReturn = [[NSMutableData alloc]init];
    [toReturn setLength:0];
    
    NSInteger length = 0;
    if (_mode == ENCRYPT)
        length = 100;
    else
        length = 128;
    
    NSMutableData *buffer = [[NSMutableData alloc]init];
    [buffer setLength:length];
    
    UInt8 *bytes = (UInt8 *)_bytes.bytes;
    for (NSInteger i = 0; i< _bytes.length; i++) {

        if ((i > 0) && (i % length == 0))
        {
           [scramled setData:[pKey decrypt:buffer error:&err]];
            
            toReturn = [self customAppend:toReturn suffix:scramled];
            
            NSInteger newLength = length;
            
            if (i+length > _bytes.length)
            {
                newLength = _bytes.length - i;
            }
            
            buffer =  [NSMutableData new];
            [buffer setLength:newLength];
            
        }
    
        UInt8 *bufferbytes = (UInt8 *)buffer.bytes;
        bufferbytes[i%length] = bytes[i];
    }
    
    [scramled setData:[pKey decrypt:buffer error:&err]];
    
    toReturn = [self customAppend:toReturn suffix:scramled];
    
 
    
    return toReturn;
}

-(NSMutableData *)customAppend:(NSData *)_prefix suffix:(NSData *)_suffix
{
    NSMutableData *toReturn = [[NSMutableData alloc]init];
    [toReturn setLength:[_prefix length]+_suffix.length];
    
    Byte *_preffixBytes = (Byte *)_prefix.bytes;
    Byte *_suffixBytes = (Byte *)_suffix.bytes;
    Byte *_toReturnBytes = (Byte *)toReturn.bytes;
    
    
    for (int i=0; i< _prefix.length; i++){
        _toReturnBytes[i] = [[NSString stringWithFormat:@"%d",_preffixBytes[i]]integerValue];
    }
    for (int i=0; i< _suffix.length; i++){
        //NSLog(@"%c",(signed char)_suffixBytes[i]);
        _toReturnBytes[i+_prefix.length] = [[NSString stringWithFormat:@"%d",_suffixBytes[i]]integerValue];
    }
    
    return toReturn;
}

-(NSString *)returnUTCDate
{
    NSDate *currentDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    NSString *localDateString = [dateFormatter stringFromDate:currentDate];
    return localDateString;
}



@end
