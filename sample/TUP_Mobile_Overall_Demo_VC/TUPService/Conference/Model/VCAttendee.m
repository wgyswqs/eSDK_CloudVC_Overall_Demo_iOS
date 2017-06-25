//
//  VCAttendee.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/28.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "VCAttendee.h"
#import "tup_confctrl_def.h"

@implementation VCAttendee
-(id)init
{
    self = [super init];
    if (self) {
        
        self.TerminalNum = @"";
        self.McuNum = @"";
        self.volumn = @"";
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    VCAttendee *newAttendee = [[[self class] allocWithZone:zone] init];
    newAttendee.TerminalNum = self.TerminalNum;
    newAttendee.McuNum = self.McuNum;
    newAttendee.volumn = self.volumn;
    return newAttendee;
}

-(id)copyFromData:(void *)data
{
    if (!data)
    {
        NSLog(@"data is NULL");
        return nil;
    }
    CONFCTRL_S_ATTENDEE_VC *attendee = (CONFCTRL_S_ATTENDEE_VC *)data;
    if (attendee != nil)
    {
        self.TerminalNum = [NSString stringWithFormat:@"%d",attendee->ucTerminalNum];
        self.McuNum = [NSString stringWithFormat:@"%d",attendee->ucMcuNum];
    }
    else
    {
        TE_FLOOR_ATTENDEE *floorAttendee = (TE_FLOOR_ATTENDEE *)data;
        self.TerminalNum = [NSString stringWithFormat:@"%d",floorAttendee->ucT];
        self.McuNum = [NSString stringWithFormat:@"%d",floorAttendee->ucT];
        self.volumn = [NSString stringWithFormat:@"%d",floorAttendee->ucVolumn];
    }
    
    return self;
}

-(BOOL)isEqual:(id)object
{
    VCAttendee *newObj = (VCAttendee *)object;
    if (!newObj)
    {
        return NO;
    }
    
    if ([newObj.TerminalNum isEqualToString:self.TerminalNum] && [newObj.McuNum isEqualToString:self.McuNum]) {
        return YES;
    }
    return NO;
}


@end
