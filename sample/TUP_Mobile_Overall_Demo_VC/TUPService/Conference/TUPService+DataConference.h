//
//  TUPService+DataConference.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/23.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService.h"
#import "TUPService+Notify.h"
#import "VCDocInfo.h"

@interface TUPService (DataConference)
-(void)dataConferenceInit;
-(void)dataConferenceUninit;
-(CONF_HANDLE)createDataConference:(void *)data;
-(BOOL)getDataConfParam:(NSString *)confId;
-(BOOL)getDataConfParam:(void *)data confid:(NSString *)confId;
- (BOOL)leaveDataConference:(CONF_HANDLE)dataConfHandle;
- (BOOL)endDataConference:(CONF_HANDLE)dataConfHandle;
- (BOOL)joinDataConference:(CONF_HANDLE)dataConfHandle;
- (void)startHeartBeat;
- (void)stopHeartBeatTimer;
- (BOOL)releaseDataConference:(CONF_HANDLE)dataConfHandle;

-(void)loadComponent:(CONF_HANDLE)dataConfHandle;
-(BOOL)componentDSConfig:(CONF_HANDLE)dataConfHandle compId:(COMPONENT_IID)compId;

-(BOOL)setDConfPage:(CONF_HANDLE)dataConfHandle compId:(COMPONENT_IID)component docId:(int)docId pageId:(long)pageId sync:(TUP_BOOL)sync;

-(void)handleDConfPageChanged:(CONF_HANDLE)dataConfHandle docId:(int)docId pageId:(long)pageId;

-(UIImage*)getDConfSuraceBmp:(CONF_HANDLE)dataConfHandle compId:(COMPONENT_IID)component;

-(VCDocInfo *)getDConfDSSyncInfo:(CONF_HANDLE)dataConfHandle;

-(BOOL)setUser:(NSString *)userid role:(int)role confHandle:(CONF_HANDLE)dataConfHandle;

-(BOOL)kickOutUser:(NSString *)userid confHandle:(CONF_HANDLE)dataConfHandle;



-(BOOL)setVideoParam:(TUP_UINT32)deviceId confHandle:(CONF_HANDLE)dataConfHandle;
-(BOOL)openDConfVideo:(TUP_UINT32)deviceId confHandle:(CONF_HANDLE)dataConfHandle;

- (BOOL)attachDConfVideo:(NSObject *)cameraInfo confHandle:(CONF_HANDLE)dataConfHandle;
- (BOOL)detachDConfVideo:(NSObject *)cameraInfo confHandle:(CONF_HANDLE)dataConfHandle;

-(BOOL)setCaptureRotaion:(int)rotation confHandle:(CONF_HANDLE)dataConfHandle;
@end
