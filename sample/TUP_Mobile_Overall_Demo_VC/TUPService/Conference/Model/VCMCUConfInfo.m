//
//  VCMCUConfInfo.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/22.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "VCMCUConfInfo.h"

@implementation VCMCUConfInfo
-(id)init
{
    self = [super init];
    if (self) {
        self.callID = @"";
        self.callProtType = @"";
        self.passcode = @"";
        self.localName = @"";
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    VCMCUConfInfo *newMCU = [[[self class] allocWithZone:zone] init];
    newMCU.callID = self.callID;
    newMCU.callProtType = self.callProtType;
    newMCU.passcode = self.passcode;
    newMCU.localName = self.localName;
    return newMCU;
}
@end
