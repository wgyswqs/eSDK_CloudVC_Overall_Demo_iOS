//
//  TUPService+Device.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/6.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService.h"

@interface TUPService (Device)

-(BOOL)muteMic:(BOOL)mute callId:(unsigned int)callId;
-(BOOL)muteSpeak:(BOOL)mute callId:(unsigned int)callId;
-(BOOL)changeAudioRoute:(ROUTE_TYPE)route;
-(BOOL)startVideoPreview:(id) viewHandler;
-(BOOL)stopVideoPreview;
-(BOOL)closeVideo:(BOOL)isClose callId:(unsigned int)callId;
-(BOOL)videoControl:(VC_VIDEO_OPERATION)control module:(VC_VIDEO_OPERATION_MODULE)module callId:(unsigned int)callid;
-(CALL_E_MOBILE_AUIDO_ROUTE)getAudioRoute;
- (void)resetVideoOrient:(unsigned int)callid cameraIndex:(CAMERA_TYPE)type;
@end
