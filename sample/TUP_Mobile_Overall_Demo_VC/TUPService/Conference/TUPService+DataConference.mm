//
//  TUPService+DataConference.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/23.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService+DataConference.h"
#import "tup_conf_extendapi.h"
#import "tup_confctrl_def.h"
#import "tup_confctrl_interface.h"



@implementation TUPService (DataConference)

-(void)dataConferenceInit
{
    Init_param initParam;
    initParam.os_type = CONF_OS_IOS;
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        initParam.dev_type = CONF_DEV_PHONE;
    }
    else
    {
        initParam.dev_type = CONF_DEV_PAD;
    }
    initParam.dev_dpi_x = 0;
    initParam.dev_dpi_y = 0;
    initParam.media_log_level = LOG_LEVEL_DEBUG;
    initParam.sdk_log_level = LOG_LEVEL_DEBUG;
    initParam.conf_mode = 0;
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/TUPC60log/dataConf"];
    strncpy(initParam.log_path, [path UTF8String], TC_MAX_PATH);
    strncpy(initParam.temp_path, [path UTF8String], TC_MAX_PATH);
    
    tup_conf_init(false, &initParam);
    NSLog(@"tup_conf_init");
    
}

-(void)dataConferenceUninit
{
    NSLog(@"tup_conf_uninit");
    tup_conf_uninit();
}

-(CONF_HANDLE)createDataConference:(void *)data
{
    
    int result = 0;
    
    CONFCTRL_S_DATACONF_PARAMS *dataConfParams = (CONFCTRL_S_DATACONF_PARAMS *)data;
    
    TC_CONF_INFO *confInfo = (TC_CONF_INFO *)malloc(sizeof(TC_CONF_INFO));
    memset(confInfo, 0, sizeof(TC_CONF_INFO));
    
    strncpy(confInfo->host_key,dataConfParams->host_key,CONFCTRL_D_MAX_HOSTKEY_LEN);
    
    strncpy(confInfo->conf_title, dataConfParams->conf_name,TC_MAX_CONF_TITLE_LEN);
    
    NSString *userid = [NSString stringWithFormat:@"%s",dataConfParams->user_id];
    confInfo->user_id = [userid intValue];
    
    strncpy(confInfo->site_id, dataConfParams->site_id,TC_MAX_CONF_SITE_ID_LEN);
    
    confInfo->user_type = CONF_ROLE_GENERAL;
    
    strncpy(confInfo->site_url, dataConfParams->site_url,CONFCTRL_D_MAX_URL_LEN);
    
    NSArray *ips = [[NSString stringWithFormat:@"%s",dataConfParams->server_ip] componentsSeparatedByString:@";"];
    strncpy(confInfo->ms_server_ip,[[ips objectAtIndex:0] UTF8String],[[ips objectAtIndex:0] length]);
    
    strncpy(confInfo->encryption_key, dataConfParams->crypt_key,TC_MAX_ENCRYPTION_KEY);
    
    confInfo->conf_id = [[NSString stringWithFormat:@"%s",dataConfParams->conf_id] intValue];
    
    confInfo->user_capability = 1024;
    
    CONF_HANDLE dataConfHandle = 0;
    
    strncpy(confInfo->user_name, dataConfParams->user_name,TC_MAX_USER_NAME_LEN);
    
    strncpy(confInfo->user_log_uri, [self.user.user_name UTF8String],self.user.user_name.length);
    
    TUP_UINT32 dwOptions = CONF_OPTION_USERLIST;
    
    NSLog(@"createDataConference: confInfo.user_id :%d;\nconfInfo.conf_id :%d,\nconfInfo.user_type :%d,\nconfInfo.user_capability :%d,\nconfInfo.sever_timer :%lld,\nconfInfo.host_key :%s,\nconfInfo.site_id :%s,\nconfInfo.ms_server_ip :%s,\nconfInfo.ms_server_interip :%s,\nconfInfo.encryption_key :%s,\nconfInfo.site_url :%s,\nconfInfo.user_log_uri :%s,\nconfInfo.user_name :%s,\nconfInfo.conf_title :%s \n",confInfo->user_id,confInfo->conf_id,confInfo->user_type,confInfo->user_capability,confInfo->sever_timer,confInfo->host_key,confInfo->site_id,confInfo->ms_server_ip,confInfo->ms_server_interip,confInfo->encryption_key,confInfo->site_url,confInfo->user_log_uri,confInfo->user_name,confInfo->conf_title);
    
    result = tup_conf_new((conference_multi_callback)onTUPDataConferenceNotify, confInfo, dwOptions,&dataConfHandle);
    NSLog(@"tup_conf_new = %d,dataConfHandle is:%d",result,dataConfHandle);
    
    [TUPService instance].dHandle = dataConfHandle;
    
    if (result == TC_OK) {
        TUP_RESULT iRet = TC_FAILURE;
        iRet = tup_conf_setiplist(dataConfHandle, confInfo->ms_server_ip);
        NSLog(@"tup_conf_setiplist : iRet:%d, ms_server_ip:%s ",iRet,confInfo->ms_server_ip);
    }
    
    free(confInfo);
    
    return dataConfHandle;
}

-(BOOL)getDataConfParam:(NSString *)confId
{
    
    CONFCTRL_S_GET_DATACONF_PARAMS *dataConfParams = (CONFCTRL_S_GET_DATACONF_PARAMS *)malloc(sizeof(CONFCTRL_S_GET_DATACONF_PARAMS));
    memset_s(dataConfParams, sizeof(CONFCTRL_S_GET_DATACONF_PARAMS), 0, sizeof(CONFCTRL_S_GET_DATACONF_PARAMS));
    NSString *confurl = [NSString stringWithFormat:@"https://%@:443",[TUPService instance].user.server_url];
    strcpy(dataConfParams->conf_url, [confurl UTF8String]);
    strcpy(dataConfParams->passcode, [confId UTF8String]);
    strcpy(dataConfParams->sip_num, [[TUPService instance].user.user_name UTF8String]);
    strcpy(dataConfParams->conf_id, [confId UTF8String]);
    
    dataConfParams->type = 1;
    
    NSLog(@"confurl is %s, dataConfParams->passcode: %s,dataConfParams->conf_id:%s",dataConfParams->conf_url,dataConfParams->passcode,dataConfParams->conf_id);
    
    TUP_RESULT result  = tup_confctrl_get_dataconf_params(dataConfParams);
    NSLog(@"tup_confctrl_get_dataconf_params result: %d",result);
    free(dataConfParams);
    return result == TC_OK ? YES : NO;
}



-(BOOL)getDataConfParam:(NSString *)confId url:(NSString *)confurl
{
    
    CONFCTRL_S_GET_DATACONF_PARAMS *dataConfParams = (CONFCTRL_S_GET_DATACONF_PARAMS *)malloc(sizeof(CONFCTRL_S_GET_DATACONF_PARAMS));
    memset_s(dataConfParams, sizeof(CONFCTRL_S_GET_DATACONF_PARAMS), 0, sizeof(CONFCTRL_S_GET_DATACONF_PARAMS));
    
    strcpy(dataConfParams->conf_url, [confurl UTF8String]);
    strcpy(dataConfParams->passcode, [confId UTF8String]);
    strcpy(dataConfParams->sip_num, [[TUPService instance].user.user_name UTF8String]);
    strcpy(dataConfParams->conf_id, [confId UTF8String]);
    
    dataConfParams->type = 1;
    
    NSLog(@"confurl is %s, dataConfParams->passcode: %s,dataConfParams->conf_id:%s",dataConfParams->conf_url,dataConfParams->passcode,dataConfParams->conf_id);
    
    TUP_RESULT result  = tup_confctrl_get_dataconf_params(dataConfParams);
    NSLog(@"tup_confctrl_get_dataconf_params result: %d",result);
    free(dataConfParams);
    return result == TC_OK ? YES : NO;
}

- (BOOL)joinDataConference:(CONF_HANDLE)dataConfHandle
{
    TUP_RESULT result = TC_FAILURE;
    
    result =  tup_conf_join(dataConfHandle);
    NSLog(@"joinDataConference: tup_conf_join = %i",result);
    return result==TC_OK ? YES : NO;
}

- (void)startHeartBeat
{
    [self stopHeartBeatTimer];
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    [TUPService instance].heartBeatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    NSLog(@"startHeartBeat : %@",[TUPService instance].heartBeatTimer);
    dispatch_source_set_timer([TUPService instance].heartBeatTimer,dispatch_walltime(NULL, 0),0.02*NSEC_PER_SEC, 0); //every sec. do
    dispatch_source_set_event_handler([TUPService instance].heartBeatTimer, ^{
        tup_conf_heart([TUPService instance].dHandle);
    });
    
    dispatch_source_set_cancel_handler([TUPService instance].heartBeatTimer, ^{
        [TUPService instance].heartBeatTimer =nil;
    });
    dispatch_resume([TUPService instance].heartBeatTimer);
}

- (void)stopHeartBeatTimer
{
    NSLog(@"stopHeartBeatTimer : %@",[TUPService instance].heartBeatTimer);
    if ([TUPService instance].heartBeatTimer)
    {
        dispatch_source_cancel([TUPService instance].heartBeatTimer);
    }
}

- (BOOL)releaseDataConference:(CONF_HANDLE)dataConfHandle
{
    
    TUP_RESULT result = TC_FAILURE ;
    result =  tup_conf_release(dataConfHandle);
    NSLog(@"releaseDataConference: tup_conf_release = %i",result);
    [TUPService instance].dHandle = 0;
    return result==TC_OK ? YES : NO;
}

- (BOOL)leaveDataConference:(CONF_HANDLE)dataConfHandle
{
    TUP_RESULT result = TC_FAILURE ;
    result =  tup_conf_leave(dataConfHandle);
    NSLog(@"leaveDataConference: tup_conf_leave = %i",result);
    
    result &= [self releaseDataConference:dataConfHandle];
    
    return result==TC_OK ? YES : NO;
}

- (BOOL)endDataConference:(CONF_HANDLE)dataConfHandle
{
    TUP_RESULT result = TC_FAILURE ;
    result =  tup_conf_terminate(dataConfHandle);
    NSLog(@"endDataConference: tup_conf_terminate = %i",result);
    result &= [self releaseDataConference:dataConfHandle];
    return result==TC_OK ? YES : NO;
}



-(void)loadComponent:(CONF_HANDLE)dataConfHandle
{
    TUP_UINT32 nNeedComponents = IID_COMPONENT_BASE | IID_COMPONENT_DS | IID_COMPONENT_AS |IID_COMPONENT_WB;
    int bRet = tup_conf_load_component(dataConfHandle, nNeedComponents);
    if (TC_OK == bRet)
    {
        [self regComponentsCallBack:nNeedComponents confHandle:dataConfHandle];
    }
    NSLog(@"loadComponent: conf_load_component result = %d", bRet);
}

-(BOOL)componentDSConfig:(CONF_HANDLE)dataConfHandle compId:(COMPONENT_IID)compId
{
    tup_conf_ds_set_bgcolor(dataConfHandle,compId,0xFFFFFFAA);
    tup_conf_ds_set_dispmode(dataConfHandle,compId,DS_DISP_MODE_FREE);
    
    TC_SIZE disp = {static_cast<TUP_INT>([UIScreen mainScreen].bounds.size.width *20),static_cast<TUP_INT>([UIScreen mainScreen].bounds.size.height *20)};
    TUP_RESULT result = tup_conf_ds_set_canvas_size(dataConfHandle, compId, disp, true);
    NSLog(@"tup_conf_ds_set_canvas_size result: %d",result);
    return result==TC_OK ? YES : NO;
}

-(BOOL)setDConfPage:(CONF_HANDLE)dataConfHandle compId:(COMPONENT_IID)component docId:(int)docId pageId:(long)pageId sync:(TUP_BOOL)sync
{
    TUP_RESULT result = tup_conf_ds_set_current_page(dataConfHandle, component, docId, pageId,sync);
    NSLog(@"tup_conf_ds_set_current_page :%d, component is :%d",result,component);
    return result == TC_OK ? YES : NO;
}

-(void)handleDConfPageChanged:(CONF_HANDLE)dataConfHandle docId:(int)docId pageId:(long)pageId
{
    // get current page size
    TUP_UINT32 currentPage = pageId;
    if (0 == pageId)
    {
        NSLog(@"<INFO>:COMPT_MSG_DS_ON_CURRENT_PAGE_IND:DS_CHANGE");
        DsDocInfo sizeZoom;
        TUP_RESULT result = tup_conf_ds_get_docinfo(dataConfHandle, IID_COMPONENT_DS, docId, &sizeZoom);
        if (TC_OK != result)
        {
            NSLog(@"<ERROR>conf_ds_get_docinfo error:%d",result);
            return;
        }
        NSLog(@"<INFO>conf_ds_get_docinfo pageId:%d",sizeZoom.currentPage);
        currentPage = sizeZoom.currentPage;
    }
    DsPageInfo pageinfo;
    
    TUP_RESULT result = tup_conf_ds_get_pageinfo(dataConfHandle, IID_COMPONENT_DS, docId, currentPage, &pageinfo);
    NSLog(@"<inf0>: COMPT_MSG_DS_ON_CURRENT_PAGE: get page info docId=%d, pageId=%ld, pageWidth=%d, pageHieght=%d, pageScale=%d!",
          docId, currentPage, pageinfo.width, pageinfo.height, pageinfo.zoomPercent);
    
    if (TC_OK != result)
    {
        NSLog(@"<ERROR>: COMPT_MSG_DS_ON_CURRENT_PAGE: get page info fialed!");
        return;
    }
    
    TC_SIZE disp = {pageinfo.width, pageinfo.height};
    result = tup_conf_ds_set_canvas_size(dataConfHandle, IID_COMPONENT_DS, disp,0);
    NSLog(@"<INFO>: tup_conf_ds_set_canvas_size:%d", result);
    result = tup_conf_ds_set_current_page(dataConfHandle, IID_COMPONENT_DS, docId, currentPage, 0);
    NSLog(@"<INFO>: tup_conf_ds_set_current_page:%d", result);
    
}

-(UIImage*)getDConfSuraceBmp:(CONF_HANDLE)dataConfHandle compId:(COMPONENT_IID)component
{
    int width = 0;
    int height = 0;
    void* picData = NULL;
    picData = tup_conf_ds_get_surfacebmp(dataConfHandle, component, (TUP_UINT32*)&width, (TUP_UINT32*)&height);
    if (picData != NULL)
    {
        int realLen = *((int*)((char*)picData + 2));
        NSData* data = [NSData dataWithBytesNoCopy:picData length:realLen freeWhenDone:NO];
        UIImage* image = [[UIImage alloc] initWithData:data];
        if (!image)
        {
            NSLog(@"obtain image error");
            return nil;
        }
        
        return image;
    }
    NSLog(@"picData is empty");
    return nil;
}

-(VCDocInfo *)getDConfDSSyncInfo:(CONF_HANDLE)dataConfHandle
{
    DsSyncInfo info;
    memset(&info, 0, sizeof(DsSyncInfo));
    TUP_RESULT result = tup_conf_ds_get_syncinfo(dataConfHandle, IID_COMPONENT_DS, &info);
    NSLog(@"<INFO>: tup_conf_ds_get_syncinfo:%d", result);
    
    if (info.docId>0)
    {
        VCDocInfo *docInfo = [[VCDocInfo alloc] init];
        [docInfo copyFromData:&info];
        
        return docInfo;
    }
    
    return nil;
}

-(BOOL)annotationReg:(CONF_HANDLE)dataConfHandle compId:(COMPONENT_IID)component annot:(DsDefineAnnot *)pdefintypes count:(int)count
{
    
    TUP_RESULT result =  tup_conf_annotation_reg_customer_type(dataConfHandle, component, pdefintypes, count);
    NSLog(@"tup_conf_annotation_reg_customer_type result : %d,count is:%d",result,count);
    return result == TC_OK ? YES : NO;
}

-(BOOL)annotationInit:(CONF_HANDLE)dataConfHandle compId:(COMPONENT_IID)component annot:(Anno_Resource_Item *)pitems count:(int)count
{
    
    TUP_RESULT result =  tup_conf_annotation_init_resource(dataConfHandle, component, pitems, count);
    NSLog(@"tup_conf_annotation_init_resource result : %d,count is:%d",result,count);
    return result == TC_OK ? YES : NO;
}



-(BOOL)setUser:(NSString *)userid role:(int)role confHandle:(CONF_HANDLE)dataConfHandle
{
    
    TUP_RESULT result = tup_conf_user_set_role(dataConfHandle, [userid intValue], role);//CONF_ROLE_PRESENTER CONF_ROLE_HOST
    NSLog(@"tup_conf_user_set_role result : %d,userid : %d,role is:%#x",result,[userid intValue],role);
    return result == TC_OK ? YES : NO;
}

-(BOOL)kickOutUser:(NSString *)userid confHandle:(CONF_HANDLE)dataConfHandle
{
    TUP_RESULT result = tup_conf_user_kickout(dataConfHandle, [userid intValue]);
    NSLog(@"tup_conf_user_kickout result : %d,userid : %d",result,[userid intValue]);
    return result == TC_OK ? YES : NO;
}

-(BOOL)setDConfVideo:(TUP_UINT32)deviceId confHandle:(CONF_HANDLE)dataConfHandle
{
    TC_VIDEO_PARAM videoParam;
    memset(&videoParam, 0, sizeof(TC_VIDEO_PARAM));
    
    videoParam.xResolution = 640;
    videoParam.yResolution = 480;
    videoParam.nFrameRate = 15;
    
    TUP_RESULT result = tup_conf_video_setparam(dataConfHandle, deviceId, &videoParam);
    NSLog(@"tup_conf_video_setparam %d with deviceid %u",result,deviceId);
    
    return result==TC_OK ? YES : NO;
}


-(BOOL)openDConfVideo:(TUP_UINT32)deviceId confHandle:(CONF_HANDLE)dataConfHandle
{
    TUP_RESULT result = tup_conf_video_open(dataConfHandle, deviceId, true);
    NSLog(@"tup_conf_video_open %d with deviceid %u",result,deviceId);
    
    return result==TC_OK ? YES : NO;
}

-(BOOL)closeDConfVideo:(TUP_UINT32)deviceId confHandle:(CONF_HANDLE)dataConfHandle
{
    TUP_RESULT result = tup_conf_video_close(dataConfHandle, deviceId);
    NSLog(@"tup_conf_video_close %d with deviceid %u",result,deviceId);
    
    return result==TC_OK ? YES : NO;
}

-(BOOL)resumeDConfVideo:(TUP_UINT32)deviceId confHandle:(CONF_HANDLE)dataConfHandle
{
    TUP_RESULT result = tup_conf_video_resume(dataConfHandle,0, 0);
    NSLog(@"<INFO>: video resume before attach: iRet = %d", result);
    
    return result==TC_OK ? YES : NO;
}

-(BOOL)pauseDConfVideo:(TUP_UINT32)deviceId confHandle:(CONF_HANDLE)dataConfHandle
{
    TUP_RESULT result = tup_conf_video_pause(dataConfHandle,0, 0, true);
    NSLog(@"<INFO>: video pause before detach: result = %d", result);
    
    return result==TC_OK ? YES : NO;
}

- (BOOL)attachDConfVideo:(NSObject *)cameraInfo confHandle:(CONF_HANDLE)dataConfHandle
{
    TUP_RESULT result = tup_conf_video_resume(dataConfHandle,0, 0);
    NSLog(@"<INFO>: video resume before attach: iRet = %d", result);
    
    int showMode = VIDEO_S_CLIP_MODE;
    result = tup_conf_video_attach(dataConfHandle, 0, 0,nil, true, showMode);
    NSLog(@"<INFO>:attachVideo with showMode %d, and result = %d",showMode,result);
    return (result == TC_OK);
}

- (BOOL)detachDConfVideo:(NSObject *)cameraInfo confHandle:(CONF_HANDLE)dataConfHandle
{
    TUP_RESULT result = tup_conf_video_pause(dataConfHandle,0, 0, true);
    NSLog(@"<INFO>: video pause before detach: result = %d", result);
    
    result = tup_conf_video_detach(dataConfHandle, 0, 0, nil, true);
    NSLog(@"<INFO>: detachVideoView: tup_conf_video_detach=%d", result);
    return (result == TC_OK);
}

- (BOOL)switchDConfChannel:(NSObject *)cameraInfo confHandle:(CONF_HANDLE)dataConfHandle
{
    TUP_RESULT result = tup_conf_video_switch_channel(dataConfHandle,0, 0, true);
    NSLog(@"<INFO>: video pause before detach: result = %d", result);
    
    return (result == TC_OK);
}

-(BOOL)setCaptureRotaion:(int)rotation confHandle:(CONF_HANDLE)dataConfHandle
{
    int result = tup_conf_video_set_capture_rotate(dataConfHandle, 0, rotation);
    NSLog(@"tup_conf_video_set_capture_rotate result : %d",result);
    return result == TC_OK ? YES : NO;
}


- (void)regComponentsCallBack:(int)iComponentID confHandle:(CONF_HANDLE)dataConfHandle
{
    
    int iRet = -1;
    iRet = tup_conf_reg_component_callback(dataConfHandle, IID_COMPONENT_BASE, onTUPComponentNotify);
    NSLog(@"<INFO>: tup_conf_reg_component_callback : IID_COMPONENT_BASE, result=%d",  iRet);
    
    if(IID_COMPONENT_DS == (iComponentID & IID_COMPONENT_DS))
    {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(dataConfHandle, IID_COMPONENT_DS, onTUPComponentNotify);
        NSLog(@"<INFO>: tup_conf_reg_component_callback: IID_COMPONENT_DS, result=%d",  iRet);
    }
    if(IID_COMPONENT_AS == (iComponentID & IID_COMPONENT_AS))
    {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(dataConfHandle, IID_COMPONENT_AS, onTUPComponentNotify);
        NSLog(@"<INFO>: tup_conf_reg_component_callback: IID_COMPONENT_AS, result=%d",  iRet);
    }
    if(IID_COMPONENT_AUDIO == (iComponentID & IID_COMPONENT_AUDIO))
    {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(dataConfHandle, IID_COMPONENT_AUDIO, onTUPComponentNotify);
        NSLog(@"<INFO>: tup_conf_reg_component_callback: IID_COMPONENT_AUDIO, result=%d",  iRet);
    }
    if(IID_COMPONENT_VIDEO == (iComponentID & IID_COMPONENT_VIDEO))
    {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(dataConfHandle, IID_COMPONENT_VIDEO, onTUPComponentNotify);
        NSLog(@"<INFO>: tup_conf_reg_component_callback: IID_COMPONENT_VIDEO, result=%d",  iRet);
    }
    if(IID_COMPONENT_CHAT == (iComponentID & IID_COMPONENT_CHAT))
    {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(dataConfHandle, IID_COMPONENT_CHAT, onTUPComponentNotify);
        NSLog(@"<INFO>: tup_conf_reg_component_callback: IID_COMPONENT_CHAT, result=%d", iRet);
    }
    if (IID_COMPONENT_WB == (iComponentID & IID_COMPONENT_WB)) {
        int iRet = -1;
        iRet = tup_conf_reg_component_callback(dataConfHandle, IID_COMPONENT_WB, onTUPComponentNotify);
        NSLog(@"<INFO>: tup_conf_reg_component_callback: IID_COMPONENT_WB, result=%d", iRet);
    }
}

@end
