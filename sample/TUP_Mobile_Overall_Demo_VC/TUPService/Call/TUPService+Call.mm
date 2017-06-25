//
//  TUPService+Call.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/2.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService+Call.h"
#import "call_interface.h"
#import "call_def.h"
#import "call_advanced_interface.h"
#import "TUPService+Notify.h"
#import "ToolUtil.h"
//#import "securec.h"

#import <UIKit/UIKit.h>

@implementation TUPService (Call)



-(void)setCallLog:(CALL_E_LOG_LEVEL)loglevel
{

    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/TUPC60log/call"];
    
    tup_call_log_start(loglevel, 5*1024, 2, (TUP_CHAR*)[path UTF8String]);
    tup_call_hme_log_info(loglevel, 10, loglevel, 50);
   
}

-(BOOL)callInit
{
    NSLog(@"start init tup call");
    [self setCallLog:CALL_E_LOG_DEBUG];
    
    TUP_RESULT result = tup_call_init();
    
    if (![self registerCallBack]) {
        [self callUninit];
        return NO;
    }
    NSLog(@"callInit: tup_call_init result = %#x",result);
    
    return result==TUP_SUCCESS?YES:NO;
}

-(BOOL)callUninit
{
    NSLog(@"callUninit");
    TUP_RESULT result = tup_call_uninit();
    NSLog(@"callUninit: tup_call_uninit result = %#x",result);
    return result==TUP_SUCCESS?YES:NO;
}

-(BOOL)registerCallBack
{
    TUP_RESULT result = tup_call_register_process_notifiy((CALL_FN_CALLBACK_PTR)onTUPCallNotify);
    NSLog(@"registerCallBack: tup_call_register_process_notifiy result = %#x",result);
    return result == TUP_SUCCESS ? YES : NO;
}

 -(void)callConfig:(VCUser *)user
{
    TUP_RESULT configResult = TUP_FAIL;
   
    CALL_E_PRODUCT_TYPE mobileType = CALL_E_PRODUCT_TYPE_MOBILE;
    configResult = tup_call_set_cfg(CALL_D_CFG_ENV_PRODUCT_TYPE, &mobileType);
    NSLog(@"tup_call_set_cfg:CALL_D_CFG_ENV_PRODUCT_TYPE  configResult = %#x",configResult);
    
    NSString *userAgentStr = @"Huawei TE Mobile";
    configResult = tup_call_set_cfg(CALL_D_CFG_ENV_USEAGENT, (TUP_VOID *)[userAgentStr UTF8String]);
    NSLog(@"tup_call_set_cfg:CALL_D_CFG_ENV_USEAGENT  configResult = %#x",configResult);
    
    //data enable
    TUP_BOOL isDataEnable = TUP_TRUE;
    configResult = tup_call_set_cfg(CALL_D_CFG_MEDIA_ENABLE_DATA,&isDataEnable);
    NSLog(@"tup_call_set_cfg:CALL_D_CFG_MEDIA_ENABLE_DATA  configResult = %#x",configResult);
    
    //bfcp enable
    TUP_BOOL isBFCPEnable = TUP_TRUE;
    configResult = tup_call_set_cfg(CALL_D_CFG_MEDIA_ENABLE_BFCP,&isBFCPEnable);
    NSLog(@"tup_call_set_cfg:CALL_D_CFG_MEDIA_ENABLE_BFCP  configResult = %#x",configResult);
    
    TUP_BOOL isNetAddrEnable = TUP_TRUE;
    configResult = tup_call_set_cfg(CALL_D_CFG_SIP_ENABLE_CORPORATE_DIRECTORY,&isNetAddrEnable);
    NSLog(@"tup_call_set_cfg:CALL_D_CFG_SIP_ENABLE_CORPORATE_DIRECTORY  configResult = %#x",configResult);
    
    
    //tup_call_register_capture_screen_func
    CALL_FN_CAPTURE_SCREEN_PTR uiFunc = (CALL_FN_CAPTURE_SCREEN_PTR)onTUPDataCaptureFunc;
    configResult = tup_call_set_cfg(CALL_D_CFG_DATA_CAPTURE_FUNC,(TUP_VOID *)&uiFunc);
    NSLog(@"tup_call_set_cfg: CALL_D_CFG_DATA_CAPTURE_FUNC result = %#x",configResult);

    //Reg server address
    CALL_S_SERVER_CFG serverCfg;
    memset_s(&serverCfg, sizeof(CALL_S_SERVER_CFG), 0, sizeof(CALL_S_SERVER_CFG));
    strncpy(serverCfg.server_address, [user.server_url UTF8String], CALL_D_MAX_URL_LENGTH);
    serverCfg.server_port = (TUP_UINT32)[user.server_port integerValue];
    configResult = tup_call_set_cfg(CALL_D_CFG_SERVER_REG_PRIMARY, &serverCfg);
    NSLog(@"tup_call_set_cfg:CALL_D_CFG_SERVER_REG_PRIMARY  configResult = %#x",configResult);
    
    //Proxy server address
    CALL_S_SERVER_CFG proxyServerCfg;
    memset_s(&proxyServerCfg, sizeof(CALL_S_SERVER_CFG), 0, sizeof(CALL_S_SERVER_CFG));
    strncpy(proxyServerCfg.server_address,  [user.proxy_url UTF8String], CALL_D_MAX_URL_LENGTH);
    proxyServerCfg.server_port = (TUP_UINT32)[user.proxy_port integerValue];
    configResult = tup_call_set_cfg(CALL_D_CFG_SERVER_PROXY_PRIMARY, &proxyServerCfg);
    NSLog(@"tup_call_set_cfg:CALL_D_CFG_SERVER_PROXY_PRIMARY  configResult = %#x",configResult);
    
    CALL_S_IF_INFO IFInfo;
    memset_s(&IFInfo, sizeof(CALL_S_IF_INFO), 0, sizeof(CALL_S_IF_INFO));
    IFInfo.ulType = CALL_E_IP_V4;
    IFInfo.uAddress.ulIPv4 = inet_addr([[ToolUtil selectedIpAddress] UTF8String]);//local ip
    configResult = tup_call_set_cfg(CALL_D_CFG_NET_NETADDRESS, &IFInfo);
    NSLog(@"tup_call_set_cfg: CALL_D_CFG_NET_NETADDRESS configResult = %#x",configResult);
    
    TUP_UINT32 sipPort = 5060;
    configResult = tup_call_set_cfg(CALL_D_CFG_SIP_PORT, &sipPort);
    NSLog(@"tup_call_set_cfg:CALL_D_CFG_SIP_PORT  configResult = %#x",configResult);

}

-(BOOL)callRegister:(VCUser *)user
{
    TUP_RESULT result = tup_call_register([user.user_name UTF8String],
                                                [user.user_name UTF8String],
                                                [user.password UTF8String]);
    NSLog(@"callRegister: tup_call_register user.user_name:%@;user.password %@ result = %#x",user.user_name,user.password,result);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)callDeregister:(NSString *)number
{
    NSLog(@"callDeregister: number:%@",number);
    TUP_RESULT result = tup_call_deregister([number UTF8String]);
    NSLog(@"callDeregister: tup_call_deregister result = %#x",result);
    return result == TUP_SUCCESS ? YES : NO;
}



-(TUP_UINT32)makeCall:(NSString *)number type:(VOIP_CALL_TYPE)callType
{
    RETURN_NO_IF_NSSTRING_NIL(number);
    CALL_E_CALL_TYPE e_callType = (CALL_E_CALL_TYPE)callType;
    TUP_UINT32 callid;
    TUP_RESULT ret = tup_call_start_call(&callid,
                                         e_callType,
                                         [number UTF8String]);
    NSLog(@"makeCall: tup_call_start_call = %@ call id : %d",(TUP_SUCCESS == ret)?@"YES":@"NO",callid);
    
    if (TUP_SUCCESS != ret)
    {
        callid = -1;
    }
    return callid;
}

- (void)configLocalVideo:(id)localView remoteVideo:(id)remoteView callId:(unsigned int)callId
{
    CALL_S_VIDEOWND_INFO videoInfo[2];

    memset_s(videoInfo, sizeof(CALL_S_VIDEOWND_INFO) * 2, 0, sizeof(CALL_S_VIDEOWND_INFO) * 2);
    videoInfo[0].ulVideoWndType = CALL_E_VIDEOWND_CALLLOCAL;
    videoInfo[0].ulRender = (TUP_UPTR)localView;
    videoInfo[0].ulDisplayType = CALL_E_VIDEOWND_DISPLAY_FULL;
    videoInfo[1].ulVideoWndType = CALL_E_VIDEOWND_CALLREMOTE;
    videoInfo[1].ulRender = (TUP_UPTR)remoteView;
    videoInfo[1].ulDisplayType = CALL_E_VIDEOWND_DISPLAY_CUT;
    
    TUP_RESULT ret = tup_call_set_video_window(2, videoInfo, callId);
    NSLog(@"tup_call_set_video_window result : %d",ret);
    
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
    orient.ulSeascape = 2;
    ret = tup_call_set_video_orient(callId, CAMERA_TYPE_FRONT, &orient);
    NSLog(@"tup_call_set_video_orient result : %d",ret);
}


-(BOOL)updateVideoWindow:(id)localVideoView remote:(id)remoteVideoView callId:(unsigned int)callId
{
    CALL_S_VIDEOWND_INFO videoInfo[2];
    memset_s(videoInfo, sizeof(CALL_S_VIDEOWND_INFO) * 2, 0, sizeof(CALL_S_VIDEOWND_INFO) * 2);
    videoInfo[0].ulVideoWndType = CALL_E_VIDEOWND_CALLLOCAL;
    videoInfo[0].ulRender = (TUP_UPTR)localVideoView;
    videoInfo[0].ulDisplayType = CALL_E_VIDEOWND_DISPLAY_FULL;
    videoInfo[1].ulVideoWndType = CALL_E_VIDEOWND_CALLREMOTE;
    videoInfo[1].ulRender = (TUP_UPTR)remoteVideoView;
    videoInfo[1].ulDisplayType = CALL_E_VIDEOWND_DISPLAY_CUT;
    TUP_RESULT ret = tup_call_update_video_window(2, videoInfo, (TUP_UINT32)callId);
    NSLog(@"updateVideoWindow: tup_call_update_video_window = %@",SDK_CONFIG_RESULT(ret));
    return (TUP_SUCCESS == ret);
}

-(BOOL)configRemoteBFCP:(id)remoteBFCPView callId:(unsigned int)callId
{
    //set remote bfcp view
    CALL_S_VIDEOWND_INFO bfcpWindowInfo;
    memset_s(&bfcpWindowInfo, sizeof(CALL_S_VIDEOWND_INFO), 0, sizeof(CALL_S_VIDEOWND_INFO));
    bfcpWindowInfo.ulRender = (TUP_UPTR)remoteBFCPView;
    bfcpWindowInfo.ulVideoWndType = CALL_E_VIDEOWND_CALLDATA;
  
    bfcpWindowInfo.ulDisplayType = VIDEO_S_STRETCH_MODE;//see VIDEO_S_STRETCH_MODE
    
    TUP_RESULT ret = tup_call_set_video_window(1, &bfcpWindowInfo,(TUP_UINT32)callId);
    NSLog(@"BFCP_Log: tup_call_set_video_window,return %d",ret);
    return (TUP_SUCCESS == ret);
}

- (BOOL)answerCall:(VOIP_CALL_TYPE)callType callId:(unsigned int)callId
{
    TUP_RESULT ret = tup_call_accept_call((TUP_UINT32)callId, callType == VOIP_CALL_TYPE_AUDIO ? TUP_FALSE : TUP_TRUE);
    NSLog(@"answerCall:tup_call_accept_call type is %d,result is %d, callid: %d",callType,ret,callId);
    return ret == TUP_SUCCESS ? YES : NO;
}

-(BOOL)endCall:(unsigned int)callId
{
    TUP_RESULT ret = tup_call_end_call(callId);
    NSLog(@"endCall: tup_call_end_call = %d, callid:%d",ret,callId);
    return ret == TUP_SUCCESS ? YES : NO;
}

- (BOOL)sendDTMF:(NSString *)number callId:(unsigned int)callId
{
    CALL_E_DTMF_TONE dtmfTone = (CALL_E_DTMF_TONE)[number intValue];
    if ([number isEqualToString:@"*"])
    {
        dtmfTone = CALL_E_DTMFSTAR;
    }
    else if ([number isEqualToString:@"#"])
    {
        dtmfTone = CALL_E_DTMFJIN;
    }
    TUP_UINT32 callid = callId;
    NSLog(@"callId : %d,dtmfTone : %d",callId,dtmfTone);
    TUP_RESULT ret = tup_call_send_DTMF((TUP_UINT32)callid,dtmfTone);//134226178
    NSLog(@"sendDTMF: tup_call_send_DTMF = %@ err:%o",(TUP_SUCCESS == ret)?@"YES":@"NO",ret);
    return ret == TUP_SUCCESS ? YES : NO;
}

-(BOOL)upgradeAudio2Video:(unsigned int)callId
{
    TUP_RESULT ret = tup_call_add_video((TUP_UINT32)callId);
    NSLog(@"upgradeAudio2Video: tup_call_add_video = %d",ret);
    return ret == TUP_SUCCESS ? YES : NO;
}

-(BOOL)downgradeVideo2Audio:(unsigned int)callId
{
    TUP_RESULT ret = tup_call_del_video((TUP_UINT32)callId);
    NSLog(@"downgradeVideo2Audio: tup_call_del_video = %d",ret);
    return ret == TUP_SUCCESS ? YES : NO;
}

-(BOOL)replyVideoCall:(BOOL)accept callId:(unsigned int)callId
{
    TUP_BOOL isAccept = accept;
    TUP_RESULT ret = tup_call_reply_add_video((TUP_UINT32)callId , isAccept);
    return ret == TUP_SUCCESS ? YES : NO;
}

-(BOOL)holdCall:(unsigned int)callId
{
    TUP_RESULT ret = tup_call_hold_call(callId);
    NSLog(@"holdCall: tup_call_hold_call = %@",(TUP_SUCCESS == ret)?@"YES":@"NO");
    return ret == TUP_SUCCESS ? YES : NO;
}

-(BOOL)unholdCall:(unsigned int)callId
{
    TUP_RESULT ret = tup_call_unhold_call(callId);
    NSLog(@"unholdCall: tup_call_unhold_call = %@",(TUP_SUCCESS == ret)?@"YES":@"NO");
    return ret == TUP_SUCCESS ? YES : NO;
}

-(int)startPlayRingFile:(NSString *)filePath
{
    int playHandle;
    TUP_RESULT result = tup_call_media_startplay(0, (TUP_CHAR *)[filePath UTF8String], &playHandle);
    NSLog(@"startPlayRingFile: tup_call_media_startplay result= %xd , playhandle = %d",result,playHandle);
 
    return result == TUP_SUCCESS ? playHandle : -1;
}

-(BOOL)stopPlayRingHandle:(int)playHandle
{
    TUP_RESULT result = tup_call_media_stopplay(playHandle);
    NSLog(@"stopPlayRingHandle: tup_call_media_stopplay result= %d",result);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)startBFCPData:(unsigned int)callId
{
    TUP_RESULT result = tup_call_start_data(callId);
    NSLog(@"startBFCPData: tup_call_start_data result= %d",result);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)stopBFCPData:(unsigned int)callId
{
    TUP_RESULT result = tup_call_stop_data(callId);
    NSLog(@"stopBFCPData: tup_call_stop_data result= %d",result);
    return result == TUP_SUCCESS ? YES : NO;
}


@end
