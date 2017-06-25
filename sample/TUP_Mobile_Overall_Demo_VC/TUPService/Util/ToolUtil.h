//
//  ToolUtil.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/3.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <ifaddrs.h>
#include <net/if.h>
#include <arpa/inet.h>

@interface ToolUtil : NSObject
+(NSString *)selectedIpAddress;
@end
