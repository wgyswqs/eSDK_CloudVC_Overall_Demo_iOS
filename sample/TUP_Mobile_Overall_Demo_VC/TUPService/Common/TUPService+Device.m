//
//  TUPService+Device.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/6.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService+Device.h"
#import "call_interface.h"
#import "call_def.h"
#import "call_advanced_interface.h"
#import "CommonDefine.h"

@implementation TUPService (Device)

- (void)resetVideoOrient:(unsigned int)callid cameraIndex:(CAMERA_TYPE)type
{
    CALL_S_VIDEO_ORIENT orient;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        orient.ulChoice = 1;
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        orient.ulChoice = 2;
    }
    orient.ulPortrait = 0;
    orient.ulLandscape = 0;
    orient.ulSeascape = 0;
    tup_call_set_video_orient(callid, type, &orient);
}

-(BOOL)videoControl:(VC_VIDEO_OPERATION)control module:(VC_VIDEO_OPERATION_MODULE)module callId:(unsigned int)callid
{
    NSLog(@"videoControl :%d module: %d callid:%d",control,module,callid);
    CALL_S_VIDEOCONTROL videoControlInfos;
    memset_s(&videoControlInfos, sizeof(CALL_S_VIDEOCONTROL), 0, sizeof(CALL_S_VIDEOCONTROL));
    videoControlInfos.ulCallID = (TUP_UINT32)callid ;
    videoControlInfos.ulModule = module;
    videoControlInfos.ulOperation = control;
    
    if (STOP|CLOSE == control || control == STOP ||control == CLOSE)
    {
        videoControlInfos.bIsSync = TUP_TRUE;
    }
    else
    {
        videoControlInfos.bIsSync = TUP_FALSE;
    }
    TUP_RESULT ret = tup_call_video_control(&videoControlInfos);
    NSLog(@"Call_Log: tup_call_video_control result= %@",(TUP_SUCCESS == ret)?@"YES":@"NO");
    return ret == TUP_SUCCESS ? YES : NO;
}

-(BOOL)muteMic:(BOOL)mute callId:(unsigned int)callId
{
    TUP_RESULT result = tup_call_media_mute_mic(callId , mute);
    NSLog(@"muteMic: tup_call_media_mute_mic result= %@",(TUP_SUCCESS == result)?@"YES":@"NO");
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)muteSpeak:(BOOL)mute callId:(unsigned int)callId
{
    TUP_RESULT result = tup_call_media_mute_speak(callId , mute);
    NSLog(@"muteSpeak: tup_call_media_mute_speak result= %@",(TUP_SUCCESS == result)?@"YES":@"NO");
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)getDeviceList:(CALL_E_DEVICE_TYPE)deviceType
{
    NSLog(@"getDeviceList:current device type: %d",deviceType);
    TUP_UINT32 deviceNum = 0;
    CALL_S_DEVICEINFO *deviceInfo;
    TUP_RESULT ret = tup_call_media_get_devices(&deviceNum, deviceInfo, deviceType);
    NSLog(@"getDeviceList: tup_call_media_get_devices = %#x,count:%d",ret,deviceNum);
    for (int i = 0; i<deviceNum; i++)
    {
        NSLog(@"getDeviceList: ulIndex:%d,strName:%s,string:%@",deviceInfo[i].ulIndex,deviceInfo[i].strName,[NSString stringWithUTF8String:deviceInfo[i].strName]);
    }
    return ret == TUP_SUCCESS ? YES : NO;
}

-(CALL_E_MOBILE_AUIDO_ROUTE)getAudioRoute
{
    CALL_E_MOBILE_AUIDO_ROUTE route;
    tup_call_get_mobile_audio_route(&route);
    NSLog(@"getAudioRoute:tup_call_get_mobile_audio_route: %d",route);
    return route;
}



-(BOOL)changeAudioRoute:(ROUTE_TYPE)route
{
    CALL_E_MOBILE_AUIDO_ROUTE audioRoute = (CALL_E_MOBILE_AUIDO_ROUTE)route;
    TUP_RESULT result = tup_call_set_mobile_audio_route(audioRoute);
    NSLog(@"tup_call_set_mobile_audio_route result is %@, audioRoute is :%d",result == TUP_SUCCESS ? @"YES" : @"NO",audioRoute);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)startVideoPreview:(id) viewHandler
{
    TUP_RESULT ret = tup_call_open_preview((TUP_UPTR)viewHandler, (TUP_UINT32)1);
    NSLog(@"Camera_Log:tup_call_open_preview result is %d", ret);
    
    NSString *tempCallId = nil;
    ret |= tup_call_set_capture_rotation((TUP_UINT32)[tempCallId integerValue], (TUP_UINT32)1, (TUP_UINT32)0);
    NSLog(@"tup_call_set_capture_rotation result is %d", ret);
    ret |= tup_call_set_display_rotation((TUP_UINT32)[tempCallId integerValue], CALL_E_VIDEOWND_CALLLOCAL, (TUP_UINT32)1);
    NSLog(@"tup_call_set_display_rotation result is %d", ret);
    
    return ret == TUP_SUCCESS ? YES : NO;
}

-(BOOL)stopVideoPreview
{
    TUP_RESULT ret = tup_call_close_preview();
    return ret == TUP_SUCCESS ? YES : NO;
}

-(BOOL)closeVideo:(BOOL)isClose callId:(unsigned int)callId
{
    TUP_RESULT ret = TUP_FAIL;
    TUP_BOOL isMute = isClose?1:0;
    ret = tup_call_media_mute_video(callId,isMute);
    NSLog(@"tup_call_media_mute_video result is %d", ret);
    
    return ret == TUP_SUCCESS ? YES : NO;
}



@end
