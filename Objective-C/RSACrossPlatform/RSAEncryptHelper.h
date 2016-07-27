//
//  RSAEncryptHelper.h
//  RedChat
//
//  Created by Coşkun Güngör on 20/11/15.
//  Copyright © 2015 Big Data Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIHKeyPair.h"

typedef enum ENCRYPT_MODE {
    
    ENCRYPT = 0,
    DECRYPT = 1
    
    
}ENCRYPT_MODE;

typedef enum KEY_MODE {
    
    PUBLIC = 0,
    PRIVATE = 1,
    ME
    
    
}KEY_MODE;


@interface RSAEncryptHelper : NSObject

+(RSAEncryptHelper *)sharedManager;
-(MIHKeyPair *)generateRunTimeKeyPair;
-(NSString *)NewDecryptMessage:(NSString *)_val;
-(NSString *)NewDecryptMessageMe:(NSString *)_val;
-(NSString *)NewEncrtypTextMsg:(NSString *)_text pubKey:(NSString *)_pubKey;
-(NSString *)NewDecryptMessageMZE:(NSString *)_val;


@end
