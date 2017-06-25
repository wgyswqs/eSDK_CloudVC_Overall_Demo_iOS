//
//  VCAttendeeData.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/28.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "VCSiteInfo.h"
#import "tup_confctrl_def.h"

@implementation VCSiteInfo
-(id)init
{
    self = [super init];
    if (self) {
        
        self.attendee = [[VCAttendee alloc] init];
        self.dataConfRecord = [[VCDConfRecord alloc] init];
        self.attendeeName = @"";
        self.attendeeNumber = @"";
        self.unJoinReason = @"";
        self.autoViewSeq = @"";
        self.autoBroadSeq = @"";
        self.autoView = @"";
        self.autoBroad = @"";
        self.siteNum = @"";
        self.isUsed = @"";
        self.joinConf = @"";
        
        self.isPSTN = @"";
        self.getName = @"";
        self.getNumber = @"";
        self.mute = @"";
        self.silent = @"";
        self.reqTalk = @"";
        self.TPMain = @"";
        self.screenNum = @"";
        self.hasRefresh = @"";
        self.isChair = @"";
        self.localMute = @"";
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    VCSiteInfo *newSite = [[[self class] allocWithZone:zone] init];
    newSite.attendee = self.attendee;
    newSite.attendeeName = self.attendeeName;
    newSite.attendeeNumber = self.attendeeNumber;
    newSite.unJoinReason = self.unJoinReason;
    newSite.autoViewSeq = self.autoViewSeq;
    newSite.autoBroadSeq = self.autoBroadSeq;
    newSite.autoView = self.autoView;
    newSite.autoBroad = self.autoBroad;
    newSite.siteNum = self.siteNum;
    newSite.isUsed = self.isUsed;
    newSite.joinConf = self.joinConf;
    
    newSite.isPSTN = self.isPSTN;
    newSite.getName = self.getName;
    newSite.getNumber = self.getNumber;
    newSite.mute = self.mute;
    newSite.silent = self.silent;
    newSite.reqTalk = self.reqTalk;
    newSite.TPMain = self.TPMain;
    newSite.screenNum = self.screenNum;
    newSite.hasRefresh = self.hasRefresh;
    newSite.isChair = self.isChair;
    newSite.localMute = self.localMute;
    newSite.dataConfRecord = self.dataConfRecord;
    
    return newSite;
}

-(id)copyFromData:(void *)data
{
    TE_ATTENDEE_DATA_IN_LIST *site = (TE_ATTENDEE_DATA_IN_LIST *)data;
    
    self.attendee.TerminalNum = [NSString stringWithFormat:@"%d",site->ucT];
    self.attendee.McuNum = [NSString stringWithFormat:@"%d",site->ucM];
    
    self.attendeeName = [NSString stringWithUTF8String: site->aucName];
    self.attendeeNumber =[NSString stringWithUTF8String:site->aucNumber];
    self.unJoinReason = [NSString stringWithFormat:@"%d",site->udwUnJoinReason];
    self.autoViewSeq = [NSString stringWithFormat:@"%d",site->uwAutoViewSeq];
    self.autoBroadSeq = [NSString stringWithFormat:@"%d",site->uwAutoBroadSeq];
    self.autoView =[NSString stringWithFormat:@"%d",site->ucAutoView];
    self.autoBroad = [NSString stringWithFormat:@"%d",site->ucAutoBroad];
    self.siteNum = [NSString stringWithFormat:@"%d",site->ucSiteNum];
    self.isUsed = [NSString stringWithFormat:@"%d",site->ucIsUsed];
    self.joinConf = [NSString stringWithFormat:@"%d",site->ucJoinConf];
    
    self.isPSTN = [NSString stringWithFormat:@"%d",site->ucIsPSTN];
    self.getName = [NSString stringWithFormat:@"%d",site->ucGetName];
    self.getNumber = [NSString stringWithFormat:@"%d",site->ucGetNumber];
    self.mute = [NSString stringWithFormat:@"%d",site->ucMute];
    self.silent = [NSString stringWithFormat:@"%d",site->ucSilent];
    self.reqTalk = [NSString stringWithFormat:@"%d",site->ucReqTalk];
    self.TPMain = [NSString stringWithFormat:@"%d",site->ucTPMain];
    self.screenNum = [NSString stringWithFormat:@"%d",site->ucScreenNum];
    self.hasRefresh = [NSString stringWithFormat:@"%d",site->ucHasRefresh];
    self.isChair = [NSString stringWithFormat:@"%d",site->ucChair];
    self.localMute = [NSString stringWithFormat:@"%d",site->ucLocalMute];
    
    NSLog(@"attendeeName %s,attendeeNumber %s",site->aucName,site->aucNumber);

    
    return self;
}

-(BOOL)isEqual:(id)object
{
    VCSiteInfo *newObj = (VCSiteInfo *)object;
    if (!newObj)
    {
        return NO;
    }
    
    if ([newObj.attendee isEqual:self.attendee]) {
        return YES;
    }
    return NO;
}
@end
