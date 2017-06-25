//
//  TUPService+Call.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/2.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService.h"

@interface TUPService (Call)

-(BOOL)callInit;
-(BOOL)callUninit;
-(void)callConfig:(VCUser *)user;
-(BOOL)callRegister:(VCUser *)user;
-(BOOL)callDeregister:(NSString *)number;
- (void)configLocalVideo:(id)localView remoteVideo:(id)remoteView callId:(unsigned int)callId;
-(BOOL)configRemoteBFCP:(id)remoteBFCPView callId:(unsigned int)callId;

-(TUP_UINT32)makeCall:(NSString *)number type:(VOIP_CALL_TYPE)callType;
-(BOOL)answerCall:(VOIP_CALL_TYPE)callType callId:(unsigned int)callId;
-(BOOL)endCall:(unsigned int)callId;
- (BOOL)sendDTMF:(NSString *)number callId:(unsigned int)callId;
-(BOOL)upgradeAudio2Video:(unsigned int)callId;
-(BOOL)downgradeVideo2Audio:(unsigned int)callId;

-(BOOL)replyVideoCall:(BOOL)accept callId:(unsigned int)callId;

-(BOOL)holdCall:(unsigned int)callId;
-(BOOL)unholdCall:(unsigned int)callId;

-(int)startPlayRingFile:(NSString *)filePath;
-(BOOL)stopPlayRingHandle:(int)playHandle;



@end
