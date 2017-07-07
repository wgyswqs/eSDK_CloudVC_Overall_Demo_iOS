//
//  TUPService+Conference.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/16.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService+Conference.h"
#import "tup_confctrl_def.h"
#import "tup_confctrl_interface.h"
#import "TUPService+Notify.h"
#import "ToolUtil.h"
#import "TUPService+Call.h"

@implementation TUPService (Conference)


-(void)conferenceInit
{
    CONFCTRL_S_INIT_PARAM param;
    param.bWaiMsgpThread = TUP_TRUE;
    param.bBatchUpdate = TUP_FALSE;
    param.bConnectCall = TUP_TRUE;//TUP_FALSE
    param.bSaveParticipantList = TUP_TRUE;
    param.ulConfListMaxNum = 0;
    param.ulParaticipantMaxNum = 0;
    
    TUP_RESULT result = tup_confctrl_set_init_param(&param);
    
    NSLog(@"tup_confctrl_set_init_param result :%d",result);
    
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/TUPC60log/confCtrl"];
    tup_confctrl_log_config(CALL_E_LOG_DEBUG, 5*1024, 2, (TUP_CHAR*)[path UTF8String]);
    
    result = tup_confctrl_init();
    NSLog(@"tup_confctrl_init result %d", result);
    
    result = tup_confctrl_register_process_notifiy((CONFCTRL_FN_CALLBACK_PTR)onTUPConferenceNotify);
    NSLog(@"tup_confctrl_register_process_notifiy result %d", result);
}

-(void)conferenceUninit
{
    TUP_RESULT result = tup_confctrl_uninit();
    NSLog(@"tup_confctrl_uninit result %d", result);
}

#pragma mark  public
-(void)conferenceConfig:(NSString *)serverAddr port:(int)port
{
    if (0 == serverAddr.length)
    {
        return;
    }
    
//    TUP_RESULT ret = tup_confctrl_set_conf_env_type(CONFCTRL_E_CONF_ENV_ON_PREMISE_VC);
    TUP_RESULT ret = tup_confctrl_set_conf_env_type(CONFCTRL_E_CONF_ENV_HOSTED_VC);
    NSLog(@"tup_confctrl_set_conf_env_type result: %d",ret);
    
    CONFCTRL_S_SERVER_PARA *serverParam = (CONFCTRL_S_SERVER_PARA *)malloc(sizeof(CONFCTRL_S_SERVER_PARA));
    memset_s(serverParam, sizeof(CONFCTRL_S_SERVER_PARA), 0, sizeof(CONFCTRL_S_SERVER_PARA));
    strcpy(serverParam->server_addr, [serverAddr UTF8String]);
    serverParam->port = (TUP_INT32)port;
    ret = tup_confctrl_set_server_params(serverParam);
    NSLog(@"tup_confctrl_set_server_params result : %d",ret);
    
    free(serverParam);
}

-(BOOL)setAuthCode:(NSString *)account pwd:(NSString *)password
{
    if (0 == account.length || 0 == password.length)
    {
        return NO;
    }

    TUP_RESULT ret = tup_confctrl_set_auth_code((TUP_CHAR *)[account UTF8String] , (TUP_CHAR *)[password UTF8String]);
    NSLog(@"tup_confctrl_set_auth_code result : %d, account : %@ , password :%@",ret,account,password);
    
    //    MediaX:SP&IMS Hosted VC
    //    TUP_RESULT ret = tup_confctrl_set_token([token UTF8String]);
    //    NSLog(@"tup_confctrl_set_token result : %d, token : %@",ret,token);

    return ret == TUP_SUCCESS ? YES : NO;
}

-(BOOL)setAuthToken:(NSString *)token
{
    if (0 == token.length)
    {
        return NO;
    }
    
    TUP_RESULT ret = tup_confctrl_set_token((TUP_CHAR *)[token UTF8String]);
    NSLog(@"tup_confctrl_set_token result : %d",ret);
    
    return ret == TUP_SUCCESS ? YES : NO;
}


#define MEDIAX_MEETING_LEAST_AUDIOATTENDER   3
#define MEDIAX_MEETING_LEAST_VIDEOATTENDER   2

-(BOOL)conferenceBook:(NSArray *)siteInfo hostType:(VC_CONF_TYPE)type
{
    CONFCTRL_S_BOOK_CONF_INFO_MEDIAX *bookConfInfo = (CONFCTRL_S_BOOK_CONF_INFO_MEDIAX *)malloc(sizeof(CONFCTRL_S_BOOK_CONF_INFO_MEDIAX));
    memset(bookConfInfo, 0, sizeof(CONFCTRL_S_BOOK_CONF_INFO_MEDIAX));
    
    NSMutableArray *sites = [NSMutableArray arrayWithArray:siteInfo];
    [sites insertObject:self.user.user_id atIndex:0];
//    [sites addObject:self.user.user_name ];
    
    bookConfInfo->size = [sites count];
    
    if(bookConfInfo->size < MEDIAX_MEETING_LEAST_VIDEOATTENDER)
    {
        bookConfInfo->size = MEDIAX_MEETING_LEAST_VIDEOATTENDER;
    }
    bookConfInfo->conf_type = CONFCTRL_E_CONF_TYPE_NORMAL;
    if (type == 0)
    {
        bookConfInfo->media_type = CONFCTRL_E_CONF_MEDIATYPE_FLAG_HDVIDEO;
    }
    else
    {
         bookConfInfo->media_type = CONFCTRL_E_CONF_MEDIATYPE_FLAG_HDVIDEO | CONFCTRL_E_CONF_MEDIATYPE_FLAG_DATA ;//| CONFCTRL_E_CONF_MEDIATYPE_FLAG_DATA;
    }
   
    //会议名
    bookConfInfo->allow_invite = TUP_TRUE;  //允许外邀
    bookConfInfo->auto_invite = TUP_TRUE;   //自动邀请
    bookConfInfo->allow_video_control = TUP_TRUE;//允许视频控制
    
    bookConfInfo->timezone = CONFCTRL_E_TIMEZONE_BEIJING; //时区
    
    unsigned long confLen = 2 * 60 * 60;    //默认时间120min
    //会议时长(必选)
    bookConfInfo->conf_len = confLen;
    strncpy(bookConfInfo->subject, [self.user.user_name UTF8String], [self.user.user_name length]);
    //入会欢迎声开关
    bookConfInfo->welcome_voice_enable = CONFCTRL_E_CONF_WARNING_TONE_DEFAULT;
    
    //成员入会提示音开关
    bookConfInfo->enter_prompt = CONFCTRL_E_CONF_WARNING_TONE_DEFAULT;
    
    //成员离会提示音开关
    bookConfInfo->leave_prompt = CONFCTRL_E_CONF_WARNING_TONE_DEFAULT;
    
    //会议过滤
    bookConfInfo->conf_filter = TUP_TRUE;
    
    //会议是否自动启动录制
    bookConfInfo->record_flag = TUP_FALSE;
    
    //会议是否自动延长会议
    bookConfInfo->auto_prolong = TUP_FALSE;
    
    //会议是否为多流视频会议
    bookConfInfo->multi_stream_flag = TUP_FALSE;
    
    //会议提醒方式
    bookConfInfo->reminder = CONFCTRL_E_REMINDER_TYPE_NONE;
    
    //会议默认语言
    bookConfInfo->language = CONFCTRL_E_LANGUAGE_EN_US;
    
    
    //会议媒体加密模式
    bookConfInfo->conf_encrypt_mode = CONFCTRL_E_ENCRYPT_MODE_NONE;
    
    //预订者的用户类型
    bookConfInfo->user_type = CONFCTRL_E_USER_TYPE_MOBILE;
    
    //与会人员
    bookConfInfo->num_of_attendee = [sites count];
    
    //与会人员
    CONFCTRL_S_ATTENDEE_MEDIAX *addterminalinfo = (CONFCTRL_S_ATTENDEE_MEDIAX *)malloc(sizeof(CONFCTRL_S_ATTENDEE_MEDIAX)*bookConfInfo->num_of_attendee);
    memset(addterminalinfo, 0, sizeof(CC_AddTerminalInfo)*bookConfInfo->num_of_attendee);
    
    for (int i = 0; i< [sites count]; i++)
    {
        NSString *addtendeeNumber = [NSString stringWithFormat:@"sip:%@@huawei.com", [sites objectAtIndex:i] ];
        
        strncpy(addterminalinfo[i].number, [addtendeeNumber UTF8String], [addtendeeNumber length]);
        
        strncpy(addterminalinfo[i].name, [[sites objectAtIndex:i] UTF8String], [[sites objectAtIndex:i] length]);
        
        addterminalinfo[i].type = CONFCTRL_E_ATTENDEE_TYPE_NORMAL;
        
        if (i == 0)
        {
            addterminalinfo[i].role = CONFCTRL_E_CONF_ROLE_CHAIRMAN; //主席
        } else {
            addterminalinfo[i].role = CONFCTRL_E_CONF_ROLE_ATTENDEE; //普通与会者
        }
    }
    
    bookConfInfo->attendee = addterminalinfo;
    
    TUP_RESULT ret = tup_confctrl_book_conf(bookConfInfo);
    NSLog(@"tup_confctrl_book_conf result : %d",ret);
    
    free(bookConfInfo);
    return ret == TUP_SUCCESS ? YES : NO;
    
}

-(BOOL)conferenceBook:(NSArray *)siteInfo type:(VC_CONF_TYPE)type
{
    if (siteInfo.count == 0) {
        NSLog(@"site count is nil");
        return NO;
    }
    
    NSMutableArray *sites = [NSMutableArray arrayWithArray:siteInfo];
    [sites addObject:self.user.user_name];
    
    CONFCTRL_BOOKCONF_INFO_S *bookConfInfo = (CONFCTRL_BOOKCONF_INFO_S *)malloc(sizeof(CONFCTRL_BOOKCONF_INFO_S));
    memset_s(bookConfInfo, sizeof(CONFCTRL_BOOKCONF_INFO_S), 0, sizeof(CONFCTRL_BOOKCONF_INFO_S));
    
    bookConfInfo->ucSiteCallType = 0;
    bookConfInfo->TerminalDataRate = 19200;
    bookConfInfo->ucSiteCallMode = VC_CONF_SITE_CALL_MODE_NORMAL;
    bookConfInfo->ucHasDataConf = type;
    bookConfInfo->eVideoProto = CC_VIDEO_PROTO_BUTT;
    
    //Conference Name
    bookConfInfo->usConfNameLen = [self.user.user_name length];;
    bookConfInfo->pucConfName =  (TUP_UINT8 *)[self.user.user_name UTF8String];
    
   //Conference password
    bookConfInfo->usPwdLen = 6;
    bookConfInfo->pucPwd = (TUP_UINT8 *)[@"000000" UTF8String];
    
    //local Address
    CC_IP_ADDR_S localAddr ;
    localAddr.enIpVer = CC_IP_V4;
    localAddr.u.ulIpv4 = htonl(inet_addr([[ToolUtil selectedIpAddress] UTF8String]));
    bookConfInfo->stLocalAddr = localAddr;
    
    //server Address
    CC_IP_ADDR_S serverAddr ;
    serverAddr.enIpVer = CC_IP_V4;
    serverAddr.u.ulIpv4 = htonl(inet_addr([[TUPService instance].user.server_url UTF8String]));
    bookConfInfo->stServerAddr = serverAddr;
    
    //Add Terminal count
    bookConfInfo->ulSiteNumber = [sites count];
    
   //Add Terminal info
    CC_AddTerminalInfo *addterminalinfo = (CC_AddTerminalInfo *)malloc(sizeof(CC_AddTerminalInfo)*bookConfInfo->ulSiteNumber);
     memset_s(addterminalinfo, sizeof(CC_AddTerminalInfo)*bookConfInfo->ulSiteNumber, 0, sizeof(CC_AddTerminalInfo)*bookConfInfo->ulSiteNumber);
    
    for (int i = 0; i< [sites count]; i++) {
        //terminal byname
        addterminalinfo[i].nTerminalIDLength = [[sites objectAtIndex:i] length];
        addterminalinfo[i].pTerminalID = (TUP_UINT8 *)[[sites objectAtIndex:i] UTF8String];
        //terminal number
        addterminalinfo[i].ucNumberLen = [[sites objectAtIndex:i] length];
        addterminalinfo[i].pucNumber = (TUP_UINT8 *)[[sites objectAtIndex:i] UTF8String];
        
        //url
        addterminalinfo[i].ucURILen = 50;
        addterminalinfo[i].pucURI = (TUP_UINT8 *)[[NSString stringWithFormat:@"%@@%@",[sites objectAtIndex:i],self.user.server_url] UTF8String];
        
        addterminalinfo[i].TerminalType = CC_sip;
        addterminalinfo[i].udwSiteBandwidth = 1920;
        
        addterminalinfo[i].ucTelcount = 1;
        
        //E164 number
        CC_E164NUM pucTel;
        pucTel.ucNumberLen = [[sites objectAtIndex:i] length];
        pucTel.pucNumber = (TUP_UINT8 *)[[sites objectAtIndex:i] UTF8String];
        
        addterminalinfo[i].pucTel = &pucTel;
        
        NSLog(@"addterminalinfo[%d]: nTerminalIDLength= %d ,\n pTerminalID:%s,\n ucNumberLen: %d,\n pucNumber : %s, \n ucURILen:%d,\n pucURI:%s,\n TerminalType:%d,\n udwSiteBandwidth:%d,\n ucTelcount :%d,\n stTerminalIPAddr :%d,\npucTel :%s,\n ",i,addterminalinfo[i].nTerminalIDLength,addterminalinfo[i].pTerminalID,addterminalinfo[i].ucNumberLen,addterminalinfo[i].pucNumber,addterminalinfo[i].ucURILen,addterminalinfo[i].pucURI,addterminalinfo[i].TerminalType,addterminalinfo[i].udwSiteBandwidth,addterminalinfo[i].ucTelcount,addterminalinfo[i].stTerminalIPAddr.u.ulIpv4,pucTel.pucNumber);
    }
    
    bookConfInfo->pcParam1 = addterminalinfo;
    
    CC_SITECALL_PAYMODE payMode;
    payMode.CardNumberLen = 0;
    payMode.pucCardNumber = (TUP_UINT8 *)[@"" UTF8String];
    
    payMode.CardPwdLen = 0;
    payMode.pucCardPwd = (TUP_UINT8 *)[@"" UTF8String];
    
    
    bookConfInfo->pPayMode = &payMode;
    
    TUP_RESULT ret = tup_confctrl_book_conf(bookConfInfo);
    NSLog(@"tup_confctrl_book_conf result : %d",ret);
    
    free(bookConfInfo);
    return ret == TUP_SUCCESS ? YES : NO;

}

-(int)createConfHandle:(VCMCUConfInfo *)mcuInfo
{
    int confHandle = -1;
    
    CONFCTRL_MCUConfInfo mcuConInfo;
    mcuConInfo.udwCallID = [mcuInfo.callID intValue];
    mcuConInfo.udwCallProtType = [mcuInfo.callProtType intValue];
    
    NSLog(@"localName %@ , length %d",mcuInfo.localName,[mcuInfo.localName length]);
    
    mcuConInfo.pucPasscode = (TUP_CHAR *)[mcuInfo.passcode UTF8String];
    mcuConInfo.pucLocalName = (TUP_CHAR *)[mcuInfo.localName UTF8String];

    
    TUP_RESULT ret = tup_confctrl_create_conf_handle((TUP_VOID*)&mcuConInfo, (TUP_UINT32*)&confHandle);
    NSLog(@"tup_confctrl_create_conf_handle result :%d, conf handle :%d",ret,confHandle);

    return confHandle;
}


-(BOOL)addAttendee:(NSString *)siteInfo confHandle:(int)confHandle
{
    if (0 == siteInfo.length)
    {
        NSLog(@"siteInfo is nil");
        return NO;
    }
    
    //Add Terminal Info
    CC_AddTerminalInfo *addterminalinfo = (CC_AddTerminalInfo *)malloc(sizeof(CC_AddTerminalInfo));
    memset_s(addterminalinfo, sizeof(CC_AddTerminalInfo), 0, sizeof(CC_AddTerminalInfo));
    
    //terminal byname
    addterminalinfo->nTerminalIDLength = [siteInfo length];
    addterminalinfo->pTerminalID = (TUP_UINT8 *)[siteInfo UTF8String];
    //terminal number
    addterminalinfo->ucNumberLen = [siteInfo length];
    addterminalinfo->pucNumber = (TUP_UINT8 *)[siteInfo UTF8String];
    
    //url
    addterminalinfo->ucURILen = 50;
    addterminalinfo->pucURI = (TUP_UINT8 *)[[NSString stringWithFormat:@"%@@%@",siteInfo ,self.user.server_url] UTF8String];
    
    addterminalinfo->TerminalType = CC_sip;
    addterminalinfo->udwSiteBandwidth = 1920;
    
    addterminalinfo->ucTelcount = 1;
    
    // E164 number
    CC_E164NUM pucTel;
    pucTel.ucNumberLen = [siteInfo  length];
    pucTel.pucNumber = (TUP_UINT8 *)[siteInfo  UTF8String];
    
    addterminalinfo->pucTel = &pucTel;
    
    TUP_RESULT result = tup_confctrl_add_attendee(confHandle, addterminalinfo);
    NSLog(@"tup_confctrl_add_attendee = %d, _confHandle:%d",result,confHandle);
    
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)removeAttendee:(NSArray *)attendeeArray confHandle:(int)confHandle
{
    if (0 == attendeeArray.count)
    {
        NSLog(@"site count is nil");
        return NO;
    }
    
    CONFCTRL_S_ATTENDEE_VC *attendees = (CONFCTRL_S_ATTENDEE_VC *)malloc(sizeof(CONFCTRL_S_ATTENDEE_VC)*attendeeArray.count);
    memset_s(attendees, sizeof(CONFCTRL_S_ATTENDEE_VC)*attendeeArray.count, 0, sizeof(CONFCTRL_S_ATTENDEE_VC)*attendeeArray.count);
    
    for (int i = 0; i< [attendeeArray count]; i++) {
    
        attendees[i].ucMcuNum = [((VCAttendee *)[attendeeArray objectAtIndex:i]).McuNum intValue];
        attendees[i].ucTerminalNum = [((VCAttendee *)[attendeeArray objectAtIndex:i]).TerminalNum intValue];
    }

    TUP_RESULT result = tup_confctrl_remove_attendee(confHandle, attendees);
    NSLog(@"tup_confctrl_remove_attendee = %d, confHandle:%d",result,confHandle);
    
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)handupAttendee:(VCAttendee *)attendee confHandle:(int)confHandle
{
    
    if (!attendee)
    {
        NSLog(@"site is nil");
        return NO;
    }
    
    CONFCTRL_S_ATTENDEE_VC attendees;
    memset_s(&attendees, sizeof(CONFCTRL_S_ATTENDEE_VC), 0, sizeof(CONFCTRL_S_ATTENDEE_VC));
    
    attendees.ucMcuNum = [attendee.McuNum intValue];
    attendees.ucTerminalNum = [attendee.TerminalNum intValue];
    TUP_RESULT result = tup_confctrl_hang_up_attendee(confHandle, &attendees);
    NSLog(@"tup_confctrl_hang_up_attendee = %d, confHandle:%d",result,confHandle);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)recallAttendee:(VCAttendee *)attendee confHandle:(int)confHandle
{
    if (!attendee)
    {
        NSLog(@"site is nil");
        return NO;
    }
    
    CONFCTRL_S_ATTENDEE_VC attendees;
    memset_s(&attendees, sizeof(CONFCTRL_S_ATTENDEE_VC), 0, sizeof(CONFCTRL_S_ATTENDEE_VC));
    
    attendees.ucMcuNum = [attendee.McuNum intValue];
    attendees.ucTerminalNum = [attendee.TerminalNum intValue];
    
    TUP_RESULT result = tup_confctrl_call_attendee(confHandle, &attendees);
    NSLog(@"tup_confctrl_call_attendee = %d, _confHandle:%d",result,confHandle);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)leaveConference:(unsigned int)callId confHandle:(unsigned int)confHandle
{
    NSLog(@"leaveConference = %d confhandle :%d",callId,confHandle);
    return [[TUPService instance] endCall:callId];
}

-(BOOL)endConference:(int)confHandle
{
    TUP_RESULT result = tup_confctrl_end_conf(confHandle);
    NSLog(@"tup_confctrl_end_conf = %d, confHandle is :%d",result,confHandle);
    
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)distroyConfHandle:(int)confHandle
{
    TUP_RESULT result = tup_confctrl_destroy_conf_handle(confHandle);
    NSLog(@"tup_confctrl_destroy_conf_handle = %d confhandle :%d",result,confHandle);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)muteAttendee:(VCAttendee *)attendee isMute:(BOOL)isMute confHandle:(int)confHandle
{
    if (!attendee)
    {
        NSLog(@"site is nil");
        return NO;
    }
    
    CONFCTRL_S_ATTENDEE_VC attendees;
    
    attendees.ucMcuNum = [attendee.McuNum intValue];
    attendees.ucTerminalNum = [attendee.TerminalNum intValue];
    
    TUP_BOOL tupBool = isMute ? 1 : 0;
    TUP_RESULT result = tup_confctrl_mute_attendee(confHandle, &attendees, tupBool);
    NSLog(@"tup_confctrl_mute_attendee = %d, confHandle is :%d, isMute:%d",result,confHandle,isMute);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)watchAttendee:(VCAttendee *)attendee confHandle:(int)confHandle
{
    if (!attendee)
    {
        NSLog(@"site is nil");
        return NO;
    }
    
    CONFCTRL_S_ATTENDEE_VC attendees;
    
    attendees.ucMcuNum = [attendee.McuNum intValue];
    attendees.ucTerminalNum = [attendee.TerminalNum intValue];
    
    TUP_RESULT result = tup_confctrl_watch_attendee(confHandle, &attendees);
    NSLog(@"tup_confctrl_watch_attendee = %d, confHandle is :%d",result,confHandle);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)broadcast:(BOOL)toBroadcast attendee:(VCAttendee *)attendee confHandle:(int)confHandle
{
    if (!attendee)
    {
        NSLog(@"site is nil");
        return NO;
    }
    
    CONFCTRL_S_ATTENDEE_VC attendees;
    
    attendees.ucMcuNum = [attendee.McuNum intValue];
    attendees.ucTerminalNum = [attendee.TerminalNum intValue];
    
    TUP_BOOL tupBool = toBroadcast ? 1 : 0;
    
    TUP_RESULT result = tup_confctrl_broadcast_attendee(confHandle, &attendees,tupBool);
    NSLog(@"tup_confctrl_broadcast_attendee = %d, confHandle is :%d",result,confHandle);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)releaseChairman:(NSString *)attendeeNumber confHandle:(int)confHandle
{
    TUP_RESULT result = tup_confctrl_release_chairman(confHandle,(TUP_CHAR*)[attendeeNumber UTF8String]);
    NSLog(@"tup_confctrl_release_chairman = %d,  attendeeNumber:%@,confhandle %d",result,attendeeNumber,confHandle);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)requestChairman:(NSString *)password number:(NSString *)attendeeNumber confHandle:(int)confHandle
{
    TUP_RESULT result = tup_confctrl_request_chairman(confHandle,(TUP_CHAR*) [password UTF8String], (TUP_CHAR*)[attendeeNumber UTF8String]);
    NSLog(@"tup_confctrl_request_chairman = %d, password is :%@, attendeeNumber:%@ ,confhandle :%d",result,password,attendeeNumber,confHandle);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)postponeConference:(int)confHandle time:(int)time
{
    TUP_RESULT result = tup_confctrl_postpone_conf(confHandle,time);
    NSLog(@"tup_confctrl_postpone_conf = %d, confHandle is :%d, time:%d",result,confHandle,time);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)upgradeConference:(int)confHandle
{
    
    CONFCTRL_S_ADD_MEDIA upgrade_param;
    upgrade_param.media_type = CONFCTRL_E_CONF_MEDIATYPE_FLAG_VOICE|CONFCTRL_E_CONF_MEDIATYPE_FLAG_VIDEO; //CONFCTRL_E_CONF_MEDIATYPE_FLAG;
    TUP_RESULT result = tup_confctrl_upgrade_conf(confHandle,&upgrade_param);
    NSLog(@"tup_confctrl_upgrade_conf = %d, confHandle is :%d, upgrade_param:%d",result,confHandle,upgrade_param);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)getVMRList:(CONFCTRL_S_GET_VMR_LIST *)param
{
    TUP_RESULT result =  tup_confctrl_get_vmr_list(param);
    NSLog(@"tup_confctrl_get_vmr_list = %d, ",result);
    return result == TUP_SUCCESS ? YES : NO;
}



@end
