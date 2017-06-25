//
//  TUPService+Conference.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/16.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService.h"
#import "VCMCUConfInfo.h"

@interface TUPService (Conference)

-(void)conferenceInit;
-(void)conferenceConfig:(NSString *)serverAddr port:(int)port;
-(BOOL)setAuthCode:(NSString *)account pwd:(NSString *)password;
-(BOOL)conferenceBook:(NSArray *)siteInfo type:(VC_CONF_TYPE)type;
-(int)createConfHandle:(VCMCUConfInfo *)mcuInfo;

-(BOOL)addAttendee:(NSString *)siteInfo confHandle:(int)confHandle;
-(BOOL)removeAttendee:(NSArray *)attendeeArray confHandle:(int)confHandle;
-(BOOL)handupAttendee:(VCAttendee *)attendee  confHandle:(int)confHandle;
-(BOOL)recallAttendee:(VCAttendee *)attendee  confHandle:(int)confHandle;
-(BOOL)leaveConference:(unsigned int)callId confHandle:(unsigned int)confHandle;
-(BOOL)endConference:(int)confHandle;
-(BOOL)distroyConfHandle:(int)confHandle;
-(BOOL)muteAttendee:(VCAttendee *)attendee isMute:(BOOL)isMute confHandle:(int)confHandle;
-(BOOL)watchAttendee:(VCAttendee *)attendee confHandle:(int)confHandle;
-(BOOL)broadcast:(BOOL)toBroadcast attendee:(VCAttendee *)attendee confHandle:(int)confHandle;
-(BOOL)releaseChairman:(NSString *)attendeeNumber confHandle:(int)confHandle;
-(BOOL)requestChairman:(NSString *)password number:(NSString *)attendeeNumber confHandle:(int)confHandle;
-(BOOL)postponeConference:(int)confHandle time:(int)time;
-(BOOL)upgradeConference:(int)confHandle;
@end
