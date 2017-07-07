//
//  TUPService+Notify.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/2.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService+Notify.h"
#import "TUPService+Call.h"
#import "VCCallInfo.h"
#import "tup_confctrl_def.h"
#import "tup_confctrl_interface.h"
#import "TUPService+DataConference.h"
#import "TUPService+Conference.h"
#import "VCConfInfo.h"
#import "VCSiteInfo.h"
#import "call_advanced_def.h"
#import "TupContactsSDK.h"
#import "TUPService+Contact.h"
#import "VCDConfRecord.h"
#import "TUPService+Login.h"


static int isConf = 1;
static int isDataConf = 1;

@implementation TUPService (Notify)

TUP_VOID onTUPLoginNotify(TUP_UINT32 msgid, TUP_UINT32 param1, TUP_UINT32 param2, TUP_VOID *data)
{
    switch ((LOGIN_E_EVENT)msgid) {
        case LOGIN_E_EVT_SMC_AUTHORIZE_RESULT://SMC:On-premise VC
        {
            LOGIN_S_SMC_AUTHORIZE_RESULT* authorizeInfo = (LOGIN_S_SMC_AUTHORIZE_RESULT*)data;
            NSLog(@"LOGIN_E_EVT_SMC_AUTHORIZE_RESULT %d %s",param1,authorizeInfo->auth_serinfo.server_uri);
            
            /*
             *firewall detection if need
             *
             if(authorizeInfo->sbc_out_num > 0)
             {
             LOGIN_S_DETECT_SERVER detect_server;
             memset(&detect_server, 0, sizeof(LOGIN_S_DETECT_SERVER));
             detect_server.server_num = authorizeInfo->sbc_out_num;
             detect_server.servers = authorizeInfo->sbc_out_servers;
             
             [[TUPService instance] firewareDetect:&detect_server];
             return;
             }
             */
            
            
            if (param1==TUP_SUCCESS)
            {
                [TUPService contactInit];
                [[TUPService instance] callConfig:[TUPService instance].user];
                BOOL ret = [[TUPService instance] callRegister:[TUPService instance].user];
                if(ret)
                {
                    return;
                }
                if ([TUPService instance].loginResultBlock)
                {
                    [TUPService instance].loginResultBlock(param1,LOGIN_EVENT_AUTHORIZE);
                }
                else
                {
                    NSLog(@"loginResultBlock is nil");
                }
            }
            else
            {
                if ([TUPService instance].loginResultBlock)
                {
                    [TUPService instance].loginResultBlock(param1,LOGIN_EVENT_AUTHORIZE);
                }
                else
                {
                    NSLog(@"loginResultBlock is nil");
                }
            }
            
        }
            break;
        case LOGIN_E_EVT_AUTHORIZE_RESULT://MediaX:SP&IMS Hosted VC
        {
            NSLog(@"LOGIN_E_EVT_AUTHORIZE_RESULT");
            if (param1 == TUP_SUCCESS)
            {
                LOGIN_S_AUTHORIZE_RESULT *authorizeInfo = (LOGIN_S_AUTHORIZE_RESULT *)data;
                if (!authorizeInfo)
                {
                    return;
                }
                
                [TUPService instance].user.auth_token = [NSString stringWithUTF8String:authorizeInfo->auth_token];
                
                [TUPService instance].user.auth_server_addr = [NSString stringWithUTF8String:authorizeInfo->auth_serinfo.server_uri];
                
                [TUPService instance].user.auth_server_port = [NSString stringWithFormat:@"%d", authorizeInfo->auth_serinfo.server_port];
                [TUPService instance].user.user_id = [NSString stringWithUTF8String:authorizeInfo->sip_info.auth_info.user_name];
                [TUPService instance].user.user_name = [NSString stringWithFormat:@"%@@%@", [NSString stringWithUTF8String:authorizeInfo->sip_info.auth_info.user_name],[NSString stringWithUTF8String:authorizeInfo->sip_info.sip_url] ];
                [TUPService instance].user.password = [NSString stringWithUTF8String:authorizeInfo->sip_info.auth_info.password];
                
                NSString *proxyAddress = [NSString stringWithUTF8String:authorizeInfo->sip_info.proxy_address];
                NSArray * proxy = [proxyAddress componentsSeparatedByCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@":"]];
                
                if([proxy count] == 2)
                {
                    [TUPService instance].user.server_url = (NSString*)[proxy objectAtIndex:0];
                    [TUPService instance].user.server_port = (NSString*)[proxy objectAtIndex:1];
                    [TUPService instance].user.proxy_url = (NSString*)[proxy objectAtIndex:0];
                    [TUPService instance].user.proxy_port = (NSString*)[proxy objectAtIndex:1];
                }
                
                [[TUPService instance] callConfig:[TUPService instance].user];
                BOOL ret = [[TUPService instance] callRegister:[TUPService instance].user];
                if(ret)
                {
                    return;
                }
                if ([TUPService instance].loginResultBlock)
                {
                    [TUPService instance].loginResultBlock(param1,LOGIN_EVENT_AUTHORIZE);
                }
            }
            else
            {
                if ([TUPService instance].loginResultBlock)
                {
                    [TUPService instance].loginResultBlock(param1,LOGIN_EVENT_AUTHORIZE);
                }
            }
            
        }
            break;
        case LOGIN_E_EVT_SEARCH_SERVER_RESULT:
        {
            NSLog(@"LOGIN_E_EVT_SEARCH_SERVER_RESULT");
        }
            break;
        case LOGIN_E_EVT_PASSWORD_CHANGEED_RESULT:
        {
            NSLog(@"LOGIN_E_EVT_PASSWORD_CHANGEED_RESULT");
            if ( [TUPService instance].changepwdResultBlock) {
                [TUPService instance].changepwdResultBlock(param1);
            }
            
        }
            break;
        case LOGIN_E_EVT_FIREWALL_DETECT_RESULT:
        {
            NSLog(@"LOGIN_E_EVT_FIREWALL_DETECT_RESULT");
            if (param1==TUP_SUCCESS)
            {
                LOGIN_E_FIREWALL_MODE mode = (LOGIN_E_FIREWALL_MODE) param2;
                switch (mode) {
                    case LOGIN_E_FIREWALL_MODE_ONLY_HTTP:
                    {
                        
                    }
                        break;
                    case LOGIN_E_FIREWALL_MODE_HTTP_AND_SVN:
                    {
                        
                    }
                        break;
                    case LOGIN_E_FIREWALL_MODE_NULL:
                    {
                        
                    }
                        break;
                    default:
                        break;
                }
                
            }
            else
            {
                if ([TUPService instance].loginResultBlock)
                {
                    [TUPService instance].loginResultBlock(param1,LOGIN_EVENT_AUTHORIZE);
                }
                else
                {
                    NSLog(@"loginResultBlock is nil");
                }
                
            }
        }
            break;
        case LOGIN_E_EVT_STG_TUNNEL_BUILD_RESULT:
        {
            NSLog(@"LOGIN_E_EVT_STG_TUNNEL_BUILD_RESULT");
        }
            break;
        default:
            break;
    }
}

TUP_VOID onTUPCallNotify(TUP_UINT32 msgid, TUP_UINT32 param1, TUP_UINT32 param2, TUP_VOID *data)
{
    switch ((CALL_E_CALL_EVENT)msgid) {
        case CALL_E_EVT_CALL_AUTHORIZE_FAILED:
        {
            NSLog(@"CALL_E_EVT_CALL_AUTHORIZE_FAILED:%o",param1);
            [[TUPService instance] callDeregister:[TUPService instance].user.user_name];
            if ([TUPService instance].loginResultBlock)
            {
                [TUPService instance].loginResultBlock(param1,LOGIN_EVENT_CALL_AUTHORIZE);
            }
            else
            {
                NSLog(@"loginResultBlock is nil");
            }
            
        }
            break;
        case CALL_E_EVT_CALL_AUTHORIZE_SUCCESS:
        {
            NSLog(@"CALL_E_EVT_CALL_AUTHORIZE_SUCCESS");
            
//            [[TUPService instance] conferenceConfig:[TUPService instance].user.server_url port:[[TUPService instance].user.server_port intValue]];
//            [[TUPService instance] setAuthCode:[TUPService instance].user.user_name pwd:[TUPService instance].user.password];
            
             [[TUPService instance] conferenceConfig:[TUPService instance].user.auth_server_addr port:[[TUPService instance].user.auth_server_port intValue]];
            [[TUPService instance] setAuthToken:[TUPService instance].user.auth_token];
            
            if ([TUPService instance].loginResultBlock)
            {
                [TUPService instance].loginResultBlock(param1,LOGIN_EVENT_CALL_AUTHORIZE);
            }
            else
            {
                NSLog(@"loginResultBlock is nil");
            }
            
        }
            break;
        case CALL_E_EVT_NETADDR_NOTIFY_INFO:
        {
            CALL_S_IDO_NETADDRESS *netaddress = (CALL_S_IDO_NETADDRESS *)data;
            NSLog(@"CALL_E_EVT_NETADDR_NOTIFY_INFO :%d",netaddress->eEUAType);
            
            ContactsErrorId result = ContactsSuccess;
            
            NSString *userName = [NSString stringWithUTF8String:netaddress->acUserName];
            NSString *password = [NSString stringWithUTF8String:netaddress->acPassword];
            NSString *server = [NSString stringWithUTF8String:netaddress->acAddress];
            NSString *dnValue = [NSString stringWithUTF8String:netaddress->acDNValue];
            
            NSLog(@"username %@,password %@,server %@,dnvalue %@",userName,password,server,dnValue);
            
            if (CALL_E_EUA_TYPE_LDAP == netaddress->eEUAType)
            {
                NSLog(@"CALL_E_EUA_TYPE_LDAP");
                result = [[TupContactsSDK sharedInstance] startNetContactsService:TupContactLDAPAddress];
                NSLog(@"startNetContactsService :%d",result);
                if (result == ContactsSuccess)
                {
                    
                    result = [[TupContactsSDK sharedInstance] setFireWallMode:FireWallModeNULL];
                    NSLog(@"setFireWallMode :%d",result);
                    
                    result = [[TupContactsSDK sharedInstance] setLdapConfig:userName
                                                                   password:password
                                                                 ldapServer:server
                                                                         dn:dnValue];
                    NSLog(@"setLdapConfig :%d",result);
                    
                }
                
            }
            else if (CALL_E_EUA_TYPE_FTP == netaddress->eEUAType)
            {
                NSLog(@"CALL_E_EUA_TYPE_FTP");
                result = [[TupContactsSDK sharedInstance] startNetContactsService:TupContactFTPAddress];
                if (result == ContactsSuccess)
                {
                    NSString *ftpPath =  [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/contact"];
                    NSString *version = [NSString stringWithUTF8String:netaddress->acVersion];
                    //ftp contact
                    [[TupContactsSDK sharedInstance] downloadFtpContacts:userName
                                                                password:password
                                                               ftpServer:server
                                                                filePath:ftpPath
                                                                 version:version
                                                     downloadResultBlock:^(BOOL result) {
                                                         NSLog(@"downloadFtpContacts result : %d",result);
                                                     }];
                }
            }
            
        }
            break;
        case CALL_E_EVT_REG_UNSUPORTED_CONEVNE:
        {
            NSLog(@"CALL_E_EVT_REG_UNSUPORTED_CONEVNE sip count:%d",param1);
        }
            break;
        case CALL_E_EVT_SIPACCOUNT_INFO:
        {
            CALL_S_SIP_ACCOUNT_INFO *regResult = (CALL_S_SIP_ACCOUNT_INFO *)data;
            NSNumber *regReasonCode = [NSNumber numberWithUnsignedInt:regResult->ulReasonCode];
            CALL_E_REASON_CODE code = (CALL_E_REASON_CODE)[regReasonCode intValue];
            CALL_E_REG_STATE newRegState = regResult->enRegState;
            BOOL success = (regResult->ulReasonCode == 0) ? YES : NO;
            NSLog(@"CALL_E_EVT_SIPACCOUNT_INFO:%d",param1);
            NSLog(@"Login: regReasonCode is %@  sucess is %d  registerstate: %d code :%o",regReasonCode,success,newRegState,code);
            if (CALL_E_REG_STATE_DEREGISTERING == newRegState && [TUPService instance].callDelegate)
            {
                [[TUPService instance].callDelegate vcCallDeregister];
            }
        }
            break;
        case CALL_E_EVT_FORCEUNREG_INFO:
        {
            NSLog(@"CALL_E_EVT_FORCEUNREG_INFO:%d",param1);
            [[TUPService instance] logout];
        }
            break;
        case CALL_E_EVT_SERVERCONF_VIDEOCONF_END_CONF:
        {
            NSLog(@"CALL_E_EVT_SERVERCONF_VIDEOCONF_END_CONF:%d",param1);
        }
            break;
        case CALL_E_EVT_CALL_STARTCALL_RESULT:
        {
            NSLog(@"CALL_E_EVT_CALL_STARTCALL_RESULT:%o   CALL_E_ERR_BUTT %o",param1,CALL_E_ERR_BUTT);
        }
            break;
        case CALL_E_EVT_CALL_INCOMING:
        {
            NSLog(@"CALL_E_EVT_CALL_INCOMING");
            isConf = 1;
            isDataConf = 1;
            CALL_S_CALL_INFO *callInfo = (CALL_S_CALL_INFO *)data;
            TUP_RESULT ret = tup_call_alerting_call(callInfo->stCallStateInfo.ulCallID);
            NSLog(@"tup_call_alerting_call,ret is %d",ret);
            VCCallInfo *vcCallInfo = [[VCCallInfo alloc] init] ;
            [vcCallInfo copyFromData:callInfo];
            
            TupHistory *record = [[TupContactsSDK sharedInstance] addCallRecord:vcCallInfo.callNum type:(callInfo->stCallStateInfo.enCallType==CALL_E_CALL_TYPE_IPVIDEO?VideoCallIncomming:AudioCallIncomming)];
            [TUPService instance].currentHRecord = record;
            //call back to ui
            if ([TUPService instance].callDelegate)
            {
                [[TUPService instance].callDelegate vcIncommingCall:vcCallInfo];
            }
            else
            {
                NSLog(@"callDelegate is nil");
            }
            
        }
            break;
        case CALL_E_EVT_CALL_OUTGOING:
        {
            NSLog(@"CALL_E_EVT_CALL_OUTGOING");
            CALL_S_CALL_INFO *callInfo = (CALL_S_CALL_INFO *)data;
            VCCallInfo *vcCallInfo = [[VCCallInfo alloc] init];
            [vcCallInfo copyFromData:callInfo];
            
            TupHistory *record = [[TupContactsSDK sharedInstance] addCallRecord:vcCallInfo.callNum type:(callInfo->stCallStateInfo.enCallType==CALL_E_CALL_TYPE_IPVIDEO?VideoCallOutgoing:AudioCallOutgoing)];
            [TUPService instance].currentHRecord = record;
            
            //call back to ui
            if ([TUPService instance].callDelegate)
            {
                [[TUPService instance].callDelegate vcOutgoingCall:vcCallInfo];
            }
            else
            {
                NSLog(@"callDelegate is nil");
            }
            
        }
            break;
        case CALL_E_EVT_CALL_RINGBACK:
        {
            NSLog(@"CALL_E_EVT_CALL_RINGBACK");
            CALL_S_CALL_INFO *callInfo = (CALL_S_CALL_INFO *)data;
            VCCallInfo *vcCallInfo = [[VCCallInfo alloc] init];
            [vcCallInfo copyFromData:callInfo];
            //call back to ui
            if ([TUPService instance].callDelegate)
            {
                [[TUPService instance].callDelegate vcCallRingBack:vcCallInfo];
            }
            else
            {
                NSLog(@"callDelegate is nil");
            }
        }
            break;
        case CALL_E_EVT_CALL_CONNECTED:
        {
            NSLog(@"CALL_E_EVT_CALL_CONNECTED");
            CALL_S_CALL_INFO *callInfo = (CALL_S_CALL_INFO *)data;
            VCCallInfo *vcCallInfo = [[VCCallInfo alloc] init];
            [vcCallInfo copyFromData:callInfo];
            
            if ([TUPService instance].currentHRecord != nil)
            {
                [TUPService instance].currentHRecord.isMissed = NO;
                
                [[TupContactsSDK sharedInstance] modifyCallRecord:[TUPService instance].currentHRecord];
            }
            
            //call back to ui
            if ([TUPService instance].callDelegate)
            {
                [[TUPService instance].callDelegate vcCallConnect:vcCallInfo];
            }
            else
            {
                NSLog(@"callDelegate is nil");
            }
            
        }
            break;
        case CALL_E_EVT_SESSION_MODIFIED:
        {
            NSLog(@"CALL_E_EVT_SESSION_MODIFIED");
        }
            break;
        case CALL_E_EVT_CALL_ENDED:
        {
            NSLog(@"CALL_E_EVT_CALL_ENDED");
            CALL_S_CALL_INFO *callInfo = (CALL_S_CALL_INFO *)data;
            VCCallInfo *vcCallInfo = [[VCCallInfo alloc] init];
            [vcCallInfo copyFromData:callInfo];
            
            if ([TUPService instance].currentHRecord != nil) {
                
                NSDate *end = [NSDate date];
                
                [TUPService instance].currentHRecord.durationTime = [[NSNumber alloc] initWithDouble:[[TUPService instance].currentHRecord.startDate timeIntervalSinceReferenceDate] -[end timeIntervalSinceReferenceDate]];
                
                [TUPService instance].currentHRecord.endTime = end;
                
                [[TupContactsSDK sharedInstance] modifyCallRecord:[TUPService instance].currentHRecord];
            }
            
            if ([TUPService instance].dHandle>0)
            {
                [[TUPService instance] leaveDataConference:[TUPService instance].dHandle];
            }
            //call back to ui
            if ([TUPService instance].callDelegate)
            {
                [[TUPService instance].callDelegate vcCallEnd:vcCallInfo];
            }
            else
            {
                NSLog(@"callDelegate is nil");
            }
            
        }
            break;
        case CALL_E_EVT_CALL_ADD_VIDEO:
        {
            NSLog(@"CALL_E_EVT_CALL_ADD_VIDEO %o",CALL_E_EVT_CALL_ADD_VIDEO);
            //call back to ui
            if ([TUPService instance].callDelegate)
            {
                [[TUPService instance].callDelegate vcUpgradeVideoCall:param1];
            }
            else
            {
                NSLog(@"callDelegate is nil");
            }
            
        }
            break;
        case CALL_E_EVT_CALL_DEL_VIDEO:
        {
            NSLog(@"CALL_E_EVT_CALL_DEL_VIDEO");
            if ([TUPService instance].callDelegate)
            {
                [[TUPService instance].callDelegate vcUpdateCallType:NO];
            }
            else
            {
                NSLog(@"callDelegate is nil");
            }
        }
            break;
        case CALL_E_EVT_CALL_MODIFY_VIDEO_RESULT:
        {
            NSLog(@"CALL_E_EVT_CALL_MODIFY_VIDEO_RESULT:%d",param2);
            
            CALL_S_MODIFY_VIDEO_RESULT *callInfo = (CALL_S_MODIFY_VIDEO_RESULT *)data;
            NSLog(@"callInfo->ulCallID :%d,callInfo->bIsVideo :%d,callInfo->ulOrientType :%d,callInfo->ulResult: %d",callInfo->ulCallID,callInfo->bIsVideo,callInfo->ulOrientType,callInfo->ulResult);
            if (callInfo->ulResult != TUP_SUCCESS)
            {
                return;
            }
            
            if ([TUPService instance].callDelegate)
            {
                [[TUPService instance].callDelegate vcUpdateCallType:callInfo->bIsVideo==0?NO:YES];
            }
            else
            {
                NSLog(@"callDelegate is nil");
            }
            
        }
            break;
        case CALL_E_EVT_CALL_HOLD_SUCCESS:
        {
            NSLog(@"CALL_E_EVT_CALL_HOLD_SUCCESS");
        }
            break;
        case CALL_E_EVT_CALL_HOLD_FAILED:
        {
            NSLog(@"CALL_E_EVT_CALL_HOLD_FAILED");
        }
            break;
        case CALL_E_EVT_CALL_UNHOLD_SUCCESS:
        {
            NSLog(@"CALL_E_EVT_CALL_UNHOLD_SUCCESS");
        }
            break;
        case CALL_E_EVT_CALL_UNHOLD_FAILED:
        {
            NSLog(@"CALL_E_EVT_CALL_UNHOLD_FAILED");
        }
            break;
        case CALL_E_EVT_AUDIO_END_FILE:
        {
            NSLog(@"CALL_E_EVT_AUDIO_END_FILE %o",CALL_E_EVT_AUDIO_END_FILE);
        }
            break;
        case CALL_E_EVT_BETRANSFERTOPRERECECONF:
        {
            NSLog(@"CALL_E_EVT_BETRANSFERTOPRERECECONF");
            CALL_S_CALL_INFO* call_info = (CALL_S_CALL_INFO*)data;
            //back to UI thread to show
        }
            break;
        case CALL_E_EVT_IDO_OVER_BFCP:
        {
            NSLog(@"CALL_E_EVT_IDO_OVER_BFCP %o, callid:%d,ido:%d",CALL_E_EVT_IDO_OVER_BFCP,param1,param2);
            
            if ( isConf == 1 )
            {
                VCMCUConfInfo *mcuInfo = [[VCMCUConfInfo alloc] init];
                mcuInfo.callID = [NSString stringWithFormat:@"%d",param1];
                mcuInfo.passcode = CONF_PASSCODE;
                mcuInfo.localName = [TUPService instance].user.user_name;
                mcuInfo.callProtType = [NSString stringWithFormat:@"%d",CALL_E_PROTOCOL_SIP];
                int ret = [[TUPService instance] createConfHandle:mcuInfo];
                
                if (ret != -1)
                {
                    isConf = 0;
                }
            }
            
        }
            break;
        case CALL_E_EVT_DECODE_SUCCESS:
        {
            NSLog(@"CALL_E_EVT_DECODE_SUCCESS %o",CALL_E_EVT_DECODE_SUCCESS);
            CALL_S_DECODE_SUCCESS *decodeSuccess = (CALL_S_DECODE_SUCCESS *)data;
            
            if (decodeSuccess->enMeidaType == CALL_E_DECODE_SUCCESS_VIDEO)
            {
                NSLog(@"Call_Log:video decode success.");
                
                return;
            }
            if (decodeSuccess->enMeidaType == CALL_E_DECODE_SUCCESS_DATA)
            {
                NSLog(@"BFCP_Log: data decode success.");
                return;
            }
            NSLog(@"mediaDecodeSuccess,not video or data decode success.");
        }
            break;
        case CALL_E_EVT_DATA_RECVING:
        {
            NSLog(@"CALL_E_EVT_DATA_RECVING %o",CALL_E_EVT_DATA_RECVING);
            if ([TUPService instance].callDelegate)
            {
                [[TUPService instance].callDelegate vcCallBFCPReceive];
            }
            else
            {
                NSLog(@"callDelegate is nil");
            }
        }
            break;
        case CALL_E_EVT_DATA_STOPPED:
        {
            NSLog(@"CALL_E_EVT_DATA_STOPPED %o",CALL_E_EVT_DATA_STOPPED);
            if ([TUPService instance].callDelegate)
            {
                [[TUPService instance].callDelegate vcCallBFCPStop];
            }
            else
            {
                NSLog(@"callDelegate is nil");
            }
        }
            break;
        case CALL_E_EVT_DATA_SENDING:
        {
            NSLog(@"CALL_E_EVT_DATA_SENDING %o",CALL_E_EVT_DATA_SENDING);
        }
            break;
        case CALL_E_EVT_SERVERCONF_DATACONF_PARAM:
        {
            NSLog(@"CALL_E_EVT_SERVERCONF_DATACONF_PARAM %d",param1);
            CALL_S_DATACONF_PARAM *dConfParam = (CALL_S_DATACONF_PARAM *)data;
            NSLog(@"confurl is %s, dConfParam->passcode: %s,dConfParam->conf_id:%s",dConfParam->acDataConfUrl,dConfParam->acPassCode,dConfParam->acDataConfID);
            if ([TUPService instance].callDelegate)
            {
                [[TUPService instance].callDelegate vcCallDataConfParam:dConfParam];
            }
            else
            {
                NSLog(@"callDelegate is nil");
            }
        }
            break;
        default:
            break;
    }
}

TUP_VOID onTUPConferenceNotify(TUP_UINT32 msgid, TUP_UINT32 param1, TUP_UINT32 param2, TUP_VOID *data)
{
    
    switch ((CONFCTRL_E_EVENT)msgid) {//
        case CONFCTRL_E_EVT_BOOK_CONF_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_BOOK_CONF_RESULT %d",param1);
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcConfBookResult:param1];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
        case CONFCTRL_E_EVT_END_CONF_IND:
        {
            NSLog(@"CONFCTRL_E_EVT_END_CONF_IND %d",param1);
        }
            break;
        case CONFCTRL_E_EVT_END_CONF_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_END_CONF_RESULT %d",param1);
        }
        case CONFCTRL_E_EVT_CONFCTRL_CONNECTED:
        {
            NSLog(@"CONFCTRL_E_EVT_CONFCTRL_CONNECTED");
            VCAttendee *attendee=[[VCAttendee alloc] init];
            [attendee copyFromData:data];
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcConfConnect:attendee confHandle:param1];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
        case CONFCTRL_E_EVT_ATTENDEE_UPDATE_IND:
        {
            NSLog(@"CONFCTRL_E_EVT_ATTENDEE_UPDATE_IND");
            VCSiteInfo *attendeeData=[[VCSiteInfo alloc] init];
            [attendeeData copyFromData:data];
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcConfUpdateSites:attendeeData type:param2 confHandle:param1];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
            
        }
            break;
        case CONFCTRL_E_EVT_ADD_ATTENDEE_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_ADD_ATTENDEE_RESULT param1: %d ;param2: %d",param1,param2);
        }
            break;
        case CONFCTRL_E_EVT_DEL_ATTENDEE_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_DEL_ATTENDEE_RESULT param1: %d ;param2: %d",param1,param2);
        }
            break;
        case CONFCTRL_E_EVT_HANGUP_ATTENDEE_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_HANGUP_ATTENDEE_RESULT");
        }
            break;
        case CONFCTRL_E_EVT_CALL_ATTENDEE_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_CALL_ATTENDEE_RESULT");
        }
            break;
        case CONFCTRL_E_EVT_REALSE_CHAIRMAN_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_REALSE_CHAIRMAN_RESULT confHandle %d, result:%d",param1,param2);
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcConfUpdateChair:param1 result:param2 isReq:NO];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
            
        }
            break;
        case CONFCTRL_E_EVT_CHAIRMAN_IND:
        {
            if (data == nil)
            {
                return;
            }
            NSLog(@"CONFCTRL_E_EVT_CHAIRMAN_IND");
            VCAttendee *attendee=[[VCAttendee alloc] init];
            [attendee copyFromData:data];
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcConfUpdateAttendee:attendee role:param2 confHandle:param1];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
            
        }
            break;
        case CONFCTRL_E_EVT_REQ_CHAIRMAN_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_REQ_CHAIRMAN_RESULT confHandle %d, result:%d",param1,param2);
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcConfUpdateChair:param1 result:param2 isReq:YES];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
        case CONFCTRL_E_EVT_CONF_TIME_REMNANT:
        {
            NSLog(@"CONFCTRL_E_EVT_CONF_TIME_REMNANT %d",param2);
        }
            break;
        case CONFCTRL_E_EVT_CONF_POSTPONE_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_CONF_POSTPONE_RESULT");
        }
            break;
        case CONFCTRL_E_EVT_FLOOR_ATTENDEE_IND:
        {
            //TE_FLOOR_ATTENDEE
            if (data == nil)
            {
                return;
            }
            NSLog(@"CONFCTRL_E_EVT_FLOOR_ATTENDEE_IND");
            VCAttendee *attendee=[[VCAttendee alloc] init];
            [attendee copyFromData:data];
            
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcConfUpdateAttendee:attendee role:2 confHandle:param1];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
        case CONFCTRL_E_EVT_DATACONF_PARAMS_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_DATACONF_PARAMS_RESULT result is : %d",param1);
            CONFCTRL_S_DATACONF_PARAMS *dataConfParams = (CONFCTRL_S_DATACONF_PARAMS *)data;
            if (!dataConfParams || param1 != TUP_SUCCESS)
            {
                NSLog(@"upgrade to data conference failed");
                return;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([TUPService instance].dHandle!=0)
                {
                    
                }
                else{
                    int dataConfhandle =[[TUPService instance] createDataConference:data];
                    
                    if (dataConfhandle != 0)
                    {
                        if(![[TUPService instance] joinDataConference:dataConfhandle])
                        {
                            [[TUPService instance] releaseDataConference:dataConfhandle];
                        }
                    }
                }
            });
        }
            break;
        case CONFCTRL_E_EVT_UPGRADE_CONF_RESULT:
        {
            //MediaX:can upgrade,on-promise:can not upgrade
            NSLog(@"CONFCTRL_E_EVT_UPGRADE_CONF_RESULT confhandle : %d ,result is : %d",param1,param2);
        }
            break;
        case CONFCTRL_E_EVT_ADD_DATA_CONF_IND:
        {
             NSLog(@"CONFCTRL_E_EVT_ADD_DATA_CONF_IND confhandle : %d ,call id : %d",param1,param2);
            
            /*
             *MediaX
             *
             CONFCTRL_S_CONF_INFO *confInfo = (CONFCTRL_S_CONF_INFO *)data;
             
             NSString *confurl = [NSString stringWithFormat:@"https://%s:443",confInfo->dateconf_uri];
             
             [[TUPService instance] getDataConfParam:confid url:confurl];
             */
           
        }
            break;
        case CONFCTRL_E_EVT_TRANS_TO_CONF_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_TRANS_TO_CONF_RESULT confhandle : %d ,result : %d",param1,param2);
            int callId = *((int *)data);
            [[TUPService instance] endCall:callId];
        }
            break;
        case CONFCTRL_E_EVT_BE_TRANS_TO_CONF_IND:
        {
            CONFCTRL_S_CONF_INFO *confInfo = (CONFCTRL_S_CONF_INFO *)data;
            //back to UI thread to show
        }
            break;
        case CONFCTRL_E_EVT_GET_VMR_LIST_RESULT:
        {
            CONFCTRL_S_VMR_LIST* vrm_list = (CONFCTRL_S_VMR_LIST*)data;
            //back to UI thread to show
        }
            break;
        case CONFCTRL_E_EVT_LOCAL_BROADCAST_STATUS_IND:
        {
            NSLog(@"CONFCTRL_E_EVT_LOCAL_BROADCAST_STATUS_IND confhandle : %d ,result : %d",param1,param2);
            //back to UI thread to show
        }
            break;
        case CONFCTRL_E_EVT_ATTENDEE_BROADCASTED_IND:
        {
            NSLog(@"CONFCTRL_E_EVT_ATTENDEE_BROADCASTED_IND confhandle : %d ,result : %d",param1,param2);
            VCAttendee *attendee=[[VCAttendee alloc] init];
            [attendee copyFromData:data];
            //back to UI thread to show
        }
            break;
        case CONFCTRL_E_EVT_BROADCAST_ATTENDEE_IND:
        {
            NSLog(@"CONFCTRL_E_EVT_BROADCAST_ATTENDEE_IND confhandle : %d ,result : %d",param1,param2);
            VCAttendee *attendee=[[VCAttendee alloc] init];
            [attendee copyFromData:data];
            //back to UI thread to show
        }
            break;
        case CONFCTRL_E_EVT_CANCEL_BROADCAST_ATTENDEE_IND:
        {
            NSLog(@"CONFCTRL_E_EVT_CANCEL_BROADCAST_ATTENDEE_IND confhandle : %d ,result : %d",param1,param2);
            VCAttendee *attendee=[[VCAttendee alloc] init];
            [attendee copyFromData:data];
            //back to UI thread to show
        }
            break;
        case CONFCTRL_E_EVT_CANCEL_BROADCAST_ATTENDEE_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_CANCEL_BROADCAST_ATTENDEE_RESULT confhandle : %d ,result : %d",param1,param2);
            //back to UI thread to show
        }
            break;
        case CONFCTRL_E_EVT_WATCH_ATTENDEE_RESULT:
        {
            NSLog(@"CONFCTRL_E_EVT_WATCH_ATTENDEE_RESULT confhandle : %d ,result : %d",param1,param2);
            //back to UI thread to show
        }
            break;
        default:
            break;
    }
    
}

TUP_VOID onTUPDataConferenceNotify(CONF_HANDLE confHandle, TUP_INT nType, TUP_UINT nValue1, TUP_ULONG nValue2, TUP_VOID* pData, TUP_INT nSize)
{
    switch (nType) {
        case CONF_MSG_ON_CONFERENCE_JOIN:
        {
            NSLog(@"CONF_MSG_ON_CONFERENCE_JOIN");
            
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfJoin:nValue1];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
            
        }
            break;
        case CONF_MSG_USER_ON_ENTER_IND:
        {
            NSLog(@"CONF_MSG_USER_ON_ENTER_IND %d",nValue1);
            VCDConfRecord *dConfRecord = [[VCDConfRecord alloc] init];
            [dConfRecord copyFromData:pData];
            
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfUpdateRecord:dConfRecord type:1];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
        case CONF_MSG_ON_COMPONENT_LOAD:
        {
            NSLog(@"CONF_MSG_ON_COMPONENT_LOAD %d",nValue1);
            if (nValue2 == IID_COMPONENT_WB || nValue2 == IID_COMPONENT_DS )
            {
                [[TUPService instance] componentDSConfig:confHandle compId:(COMPONENT_IID)nValue2];
            }
        }
            break;
        case CONF_MSG_USER_ON_LEAVE_IND:
        {
            NSLog(@"CONF_MSG_USER_ON_LEAVE_IND");
            VCDConfRecord *dConfRecord = [[VCDConfRecord alloc] init];
            [dConfRecord copyFromData:pData];
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfUpdateRecord:dConfRecord type:0];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
        case CONF_MSG_USER_ON_HOST_GIVE_CFM:
        {
            NSLog(@"CONF_MSG_USER_ON_HOST_GIVE_CFM");
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfOld:0 newId:0 role:CONF_ROLE_HOST result:nValue1];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
            
        }
            break;
            
        case   CONF_MSG_USER_ON_HOST_GIVE_IND:
        {
            NSLog(@"CONF_MSG_USER_ON_HOST_GIVE_IND");
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfOld:0 newId:nValue1 role:CONF_ROLE_HOST result:-2];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
        case CONF_MSG_USER_ON_HOST_CHANGE_IND:
        {
            NSLog(@"CONF_MSG_USER_ON_HOST_CHANGE_IND");
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfOld:nValue1 newId:nValue2 role:CONF_ROLE_HOST result:-1];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
            
        case CONF_MSG_USER_ON_PRESENTER_GIVE_IND:
        {
            NSLog(@"CONF_MSG_USER_ON_PRESENTER_GIVE_IND");
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfOld:0 newId:nValue1 role:CONF_ROLE_PRESENTER result:-2];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
            
        case CONF_MSG_USER_ON_PRESENTER_GIVE_CFM:
        {
            NSLog(@"CONF_MSG_USER_ON_PRESENTER_GIVE_CFM");
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfOld:0 newId:0 role:CONF_ROLE_PRESENTER result:nValue1];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
            
        case CONF_MSG_USER_ON_PRESENTER_CHANGE_IND:
        {
            NSLog(@"CONF_MSG_USER_ON_PRESENTER_CHANGE_IND");
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfOld:nValue1 newId:nValue2 role:CONF_ROLE_PRESENTER result:-1];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
        case CONF_MSG_ON_CONFERENCE_LEAVE:
        {
            NSLog(@"CONF_MSG_ON_CONFERENCE_LEAVE");
            [[TUPService instance] releaseDataConference:[TUPService instance].dHandle];
        }
            break;
        case CONF_MSG_ON_CONFERENCE_TERMINATE:
        {
            NSLog(@"CONF_MSG_ON_CONFERENCE_TERMINATE");
            [[TUPService instance] releaseDataConference:[TUPService instance].dHandle];
        }
            break;
        default:
            break;
    }
}

TUP_VOID onTUPComponentNotify(CONF_HANDLE confHandle, TUP_INT nType, TUP_UINT nValue1, TUP_ULONG nValue2, TUP_VOID* pData, TUP_INT nSize)
{
    NSLog(@"------->onTUPComponentNotify nType:%d :%d :%ld",nType,nValue1,nValue2);
    switch (nType) {
        case COMPT_MSG_VIDEO_ON_SWITCH:
        {
            NSLog(@"COMPT_MSG_VIDEO_ON_SWITCH");
        }
            break;
        case COMPT_MSG_VIDEO_ON_NOTIFY:
        {
            NSLog(@"COMPT_MSG_VIDEO_ON_SWITCH");
        }
            break;
        case COMPT_MSG_AS_ON_SHARING_STATE:
        {
            NSLog(@"COMPT_MSG_AS_ON_SHARING_STATE");
            TC_AS_WndInfo* wind_info = (TC_AS_WndInfo *)pData;
            if (nValue2 == AS_STATE_NULL)
            {
                NSLog(@"screen share stop");
                //call back to ui
                if ([TUPService instance].confDelegate)
                {
                    [[TUPService instance].confDelegate vcDataConfShareStop];
                }
                else
                {
                    NSLog(@"confDelegate is nil");
                }
                
            }
            else if (nValue2 == AS_STATE_START)
            {
                NSLog(@"screen share start");
            }
            
        }
            break;
        case COMPT_MSG_AS_ON_SHARING_SESSION:
        {
            NSLog(@"COMPT_MSG_AS_ON_SHARING_SESSION");
        }
            break;
        case COMPT_MSG_AS_ON_SCREEN_DATA:
        {
            NSLog(@"COMPT_MSG_AS_ON_SCREEN_DATA");
            
            
            TC_AS_SCREENDATA *screenData = (TC_AS_SCREENDATA *)malloc(sizeof(TC_AS_SCREENDATA));
            memset(screenData, 0, sizeof(TC_AS_SCREENDATA));
            TUP_RESULT dataRet = tup_conf_as_get_screendata(confHandle, screenData);
            if (dataRet != TC_OK)
            {
                NSLog(@"tup_conf_as_get_screendata failed:%d",dataRet);
                return;
            }
            NSLog(@"tup_conf_as_get_screendata :%d ,datatype %d",dataRet,screenData->ucDataType);
            char *data = (char *)screenData->pData;
            TUP_UINT32 dataLength = *((TUP_UINT32 *)((char *)data + sizeof(TUP_UINT16)));
            NSLog(@"dataLength = %d",dataLength);
            if (dataLength<0)
            {
                return;
            }
            NSMutableData *__autoreleasing imageData = [NSMutableData dataWithBytes:data length:dataLength];
            UIImage *__autoreleasing image = [[UIImage alloc] initWithData:imageData];
            
            free(screenData);
            if (image == nil)
            {
                NSLog(@"share image from data fail!");
                return;
            }
            //call back to ui
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfShareData:image type:0];
                
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
            
            
        }
            break;
        case COMPT_MSG_DS_ON_DOC_NEW:
        {
            NSLog(@"COMPT_MSG_DS_ON_DOC_NEW");
        }
            break;
        case COMPT_MSG_DS_ON_PAGE_NEW:
        {
            NSLog(@"COMPT_MSG_DS_ON_PAGE_NEW");
        }
            break;
            
        case COMPT_MSG_DS_ON_CURRENT_PAGE_IND:
        {
            NSLog(@"COMPT_MSG_DS_ON_CURRENT_PAGE_IND");
            
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfSync:confHandle docId:nValue1 pageId:nValue2];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
        case COMPT_MSG_DS_ON_CURRENT_PAGE:
        {
            NSLog(@"COMPT_MSG_DS_ON_CURRENT_PAGE");
        }
            break;
        case COMPT_MSG_DS_ON_DRAW_DATA_NOTIFY:
        {
            NSLog(@"COMPT_MSG_DS_ON_DRAW_DATA_NOTIFY");
            UIImage *image = [[TUPService instance] getDConfSuraceBmp:confHandle compId:IID_COMPONENT_DS];
            //call back to ui
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfShareData:image type:1];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
            
        }
            break;
        case COMPT_MSG_WB_ON_DOC_NEW:
        {
            NSLog(@"COMPT_MSG_DS_ON_DOC_NEW");
        }
            break;
        case COMPT_MSG_WB_ON_PAGE_NEW:
        {
            NSLog(@"COMPT_MSG_DS_ON_PAGE_NEW");
        }
            break;
        case COMPT_MSG_WB_ON_CURRENT_PAGE_IND:
        {
            NSLog(@"COMPT_MSG_WB_ON_CURRENT_PAGE_IND");
            [[TUPService instance] setDConfPage:confHandle compId:IID_COMPONENT_WB docId:nValue1 pageId:nValue2 sync:NO];
        }
            break;
        case COMPT_MSG_WB_ON_CURRENT_PAGE:
        {
            NSLog(@"COMPT_MSG_WB_ON_CURRENT_PAGE");
        }
            break;
        case COMPT_MSG_WB_ON_DRAW_DATA_NOTIFY:
        {
            NSLog(@"COMPT_MSG_DS_ON_DRAW_DATA_NOTIFY");
            UIImage *image = [[TUPService instance] getDConfSuraceBmp:confHandle compId:IID_COMPONENT_WB];
            //call back to ui
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfShareData:image type:2];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
            
        }
            break;
        case COMPT_MSG_WB_ON_DOC_DEL:
        {
            NSLog(@"COMPT_MSG_WB_ON_DOC_DEL");
            //call back to ui
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfShareStop];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
            
        }
            break;
        case COMPT_MSG_WB_ON_PAGE_DEL:
        {
            NSLog(@"COMPT_MSG_WB_ON_PAGE_DEL");
        }
            break;
        case COMPT_MSG_DS_ON_DOC_DEL:
        {
            NSLog(@"COMPT_MSG_DS_ON_PAGE_DEL");
            //call back to ui
            if ([TUPService instance].confDelegate)
            {
                [[TUPService instance].confDelegate vcDataConfShareStop];
            }
            else
            {
                NSLog(@"confDelegate is nil");
            }
        }
            break;
        case COMPT_MSG_DS_ON_PAGE_DEL:
        {
            NSLog(@"COMPT_MSG_DS_ON_PAGE_DEL");
            
        }
            break;
        default:
            break;
    }
}

//bfcp callback
TUP_INT32 onTUPDataCaptureFunc(void *data, TUP_ULONG width, TUP_ULONG height)
{
    NSLog(@"------->onTUPDataCaptureFunc width:%ld height:%ld data:",width,height);
    
    if ([TUPService instance].callDelegate)
    {
        [[TUPService instance].callDelegate vcCallBFCPReceive];
    }
    else
    {
        NSLog(@"callDelegate is nil");
    }
    
    
    return TUP_SUCCESS;
}

@end
