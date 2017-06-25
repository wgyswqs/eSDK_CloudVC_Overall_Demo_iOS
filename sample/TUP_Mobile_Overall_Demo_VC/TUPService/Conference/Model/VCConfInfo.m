//
//  VCConfInfo.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/28.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "VCConfInfo.h"
#import "call_def.h"

@implementation VCConfInfo
-(id)init
{
    self = [super init];
    if (self) {
        
        self.confHandle = @"";
        self.dConfHandle = @"";
        self.confID = @"";
        self.confType = @"";
        self.confMediaType = @"";
        self.isChairman = @"0";
        self.hostKey = @"";
        self.dConfRole = @"";
        self.userAltId = @"";
        self.attendee = [[VCAttendee alloc] init];
    }
    
    return self;
}



-(id)copyWithZone:(NSZone *)zone
{
    VCConfInfo *newConf = [[[self class] allocWithZone:zone] init];
    newConf.confHandle = self.confHandle;
    newConf.dConfHandle = self.dConfHandle;
    newConf.confID = self.confID;
    newConf.confType = self.confType;
    newConf.confMediaType = self.confMediaType;
    newConf.isChairman = self.isChairman;
    newConf.attendee = self.attendee;
    newConf.hostKey = self.hostKey;
    newConf.dConfRole = self.dConfRole;
    newConf.userAltId = self.userAltId;
    return newConf;
}

-(id)copyFromData:(void *)data
{
    CALL_S_CALL_INFO *callInfo = (CALL_S_CALL_INFO *)data;
    
    self.confID = [NSString stringWithUTF8String:callInfo->acServerConfID];
    self.confType = [NSString stringWithUTF8String:callInfo->acServerConfType];
    self.confMediaType =[NSString stringWithFormat:@"%d",callInfo->ulConfMediaType];
    NSLog(@"VCConfInfo copyFromData %@",self.confID);
    return self;
}



@end
