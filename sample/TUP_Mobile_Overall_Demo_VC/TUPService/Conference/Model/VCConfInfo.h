//
//  VCConfInfo.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/28.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCAttendee.h"

@interface VCConfInfo : NSObject
@property(nonatomic,copy)NSString *confHandle;
@property(nonatomic,copy)NSString *dConfHandle;
@property(nonatomic,copy)NSString *dConfRole;
@property(nonatomic,copy)NSString *confMediaType;
@property(nonatomic,copy)NSString *confType;
@property(nonatomic,copy)NSString *confID;
@property(nonatomic,copy)NSString *isChairman;
@property(nonatomic,copy)NSString *hostKey;
@property(nonatomic,strong)VCAttendee *attendee;

@property(nonatomic,copy)NSString *userAltId;

-(id)copyFromData:(void *)data;

@end
