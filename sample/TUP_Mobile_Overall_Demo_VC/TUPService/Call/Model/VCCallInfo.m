//
//  VCCallInfo.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/16.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "VCCallInfo.h"
#import "call_def.h"

@implementation VCCallInfo
-(id)init
{
    self = [super init];
    if (self) {
        self.callID = @"";
        self.bHaveSDP = @"";
        self.callType = @"";
        self.callNum = @"";
        self.confInfo = [[VCConfInfo alloc] init];
        
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    VCCallInfo *newCall = [[[self class] allocWithZone:zone] init];
    newCall.callID = self.callID;
    newCall.bHaveSDP = self.bHaveSDP;
    newCall.callType = self.callType;
    newCall.callNum = self.callNum;
    newCall.confInfo = self.confInfo;

    return newCall;
}



-(id)copyFromData:(void *)data
{
    CALL_S_CALL_INFO *callInfo = (CALL_S_CALL_INFO *)data;
    
    self.callID = [NSString stringWithFormat:@"%d",callInfo->stCallStateInfo.ulCallID];
    self.bHaveSDP = [NSString stringWithFormat:@"%d",callInfo->stCallStateInfo.bHaveSDP];
    self.callType = [NSString stringWithFormat:@"%d",callInfo->stCallStateInfo.enCallType];
    self.callNum = [NSString stringWithUTF8String:callInfo->stCallStateInfo.acTelNum];
    
    [self.confInfo copyFromData:data];
    
    return self;
}

@end
