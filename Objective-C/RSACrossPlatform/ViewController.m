//
//  ViewController.m
//  RSACrossPlatform
//
//  Created by Coşkun Güngör on 27/07/16.
//  Copyright © 2016 Coşkun Güngör. All rights reserved.
//

#import "ViewController.h"
#import "MIHKeyPair.h"
#import "RSAEncryptHelper.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

     MIHKeyPair *retrievedDictionary = [[RSAEncryptHelper sharedManager]generateRunTimeKeyPair];
     NSMutableDictionary *dicParam = [[NSMutableDictionary alloc]init];
     [dicParam setObject:[NSString stringWithFormat:@"%@",retrievedDictionary.public] forKey:@"publickey"];
    
    
    NSLog(@"%@",[dicParam objectForKey:@"publickey"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
