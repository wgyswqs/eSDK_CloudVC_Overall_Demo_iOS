//
//  TUPService.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/2/28.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonDefine.h"
#import "VCUser.h"
#import "VCCallInfo.h"
#import "VCConfInfo.h"
#import "VCSiteInfo.h"
#import "VCDConfRecord.h"

#import <UIKit/UIKit.h>

@class TupHistory;

@protocol TUPVCCallDelegate <NSObject>
@optional
-(void)vcCallDeregister;
-(void)vcOutgoingCall:(VCCallInfo *)callInfo;
-(void)vcIncommingCall:(VCCallInfo *)callInfo;
-(void)vcCallRingBack:(VCCallInfo *)callInfo;
-(void)vcCallConnect:(VCCallInfo *)callInfo;
-(void)vcCallEnd:(VCCallInfo *)callInfo;
-(void)vcCallDataConfParam:(CALL_S_DATACONF_PARAM *)data;
-(void)vcUpgradeVideoCall:(unsigned int)callId;
-(void)vcUpdateCallType:(BOOL)isVideo;

//BFCP
-(void)vcCallBFCPReceive;
-(void)vcCallBFCPStop;
@end

@protocol TUPVCConfDelegate <NSObject>
@optional

-(void)vcConfBookResult:(int)result;
-(void)vcConfConnect:(VCAttendee *)attendee confHandle:(int) confHandle;
-(void)vcConfUpdateSites:(VCSiteInfo *)siteInfo type:(int)type confHandle:(int) confHandle;
-(void)vcConfUpdateAttendee:(VCAttendee *)attendee role:(int)role confHandle:(int) confHandle;
-(void)vcConfUpdateChair:(int)confhandle result:(int)errCode isReq:(BOOL)isReq;

-(void)vcDataConfJoin:(int)result;
-(void)vcDataConfUpdateRecord:(VCDConfRecord *)record type:(int)type;
-(void)vcDataConfShareStop;
-(void)vcDataConfShareData:(UIImage *)image type:(int)type;
-(void)vcDataConfOld:(int)oldRole newId:(int)newRole role:(int)role result:(int) result;
-(void)vcDataConfSync:(int)dataConfHandle docId:(int)docId pageId:(long)pageId;

@end


@interface TUPService : NSObject

@property (nonatomic, copy)AuthoriseResultBlock loginResultBlock;
@property (nonatomic, copy)ChangePwdResultBlock changepwdResultBlock;


@property (nonatomic, assign) id<TUPVCCallDelegate> callDelegate;
@property (nonatomic, assign) id<TUPVCConfDelegate> confDelegate;

@property (nonatomic, copy) VCUser *user;
@property (nonatomic, retain)  dispatch_source_t heartBeatTimer;
@property (nonatomic, assign) unsigned int dHandle;
@property (nonatomic, assign) unsigned int serverType;
@property (nonatomic, strong) TupHistory * currentHRecord;

+ (TUPService *)instance;

+ (void)releaseInstance;


@end
