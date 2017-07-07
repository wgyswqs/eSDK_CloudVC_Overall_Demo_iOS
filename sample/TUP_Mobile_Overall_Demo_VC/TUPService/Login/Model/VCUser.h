//
//  VCUser.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/6.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCUser : NSObject

//uportal
@property(nonatomic,copy)NSString *user_id;
@property(nonatomic,copy)NSString *user_name;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *server_port;
@property(nonatomic,copy)NSString *server_url;
@property(nonatomic,copy)NSString *proxy_port;
@property(nonatomic,copy)NSString *proxy_url;
@property(nonatomic,copy)NSString *auth_token;
@property(nonatomic,copy)NSString *auth_server_addr;
@property(nonatomic,copy)NSString *auth_server_port;
@end
