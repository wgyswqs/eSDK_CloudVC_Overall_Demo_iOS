//
//  VCUser.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/6.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "VCUser.h"

@implementation VCUser

-(id)init
{
    self = [super init];
    if (self) {
        self.user_name = @"";
        self.user_id = @"";
        self.proxy_url = @"";
        self.server_url = @"";
        self.proxy_port = @"";
        self.password = @"";
        self.server_port = @"";
        self.auth_server_addr = @"";
         self.auth_server_port = @"";
        self.auth_token = @"";
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    VCUser *newUser = [[[self class] allocWithZone:zone] init];
    newUser.user_name = self.user_name;
    newUser.user_id = self.user_id;
    newUser.proxy_url = self.proxy_url;
    newUser.server_url = self.server_url;
    newUser.proxy_port = self.proxy_port;
    newUser.password = self.password;
    newUser.server_port = self.server_port;
    newUser.auth_server_addr = self.auth_server_addr;
    newUser.auth_token = self.auth_token;
    newUser.auth_server_port = self.auth_server_port;
    
    return newUser;
}

@end
