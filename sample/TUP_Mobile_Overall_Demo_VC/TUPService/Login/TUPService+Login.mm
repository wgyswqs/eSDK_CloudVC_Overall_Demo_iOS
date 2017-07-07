//
//  TUPService+Login.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/2/28.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService+Login.h"
#import "TUPService+Notify.h"
#import "TUPService+Call.h"

@implementation TUPService (Login)


-(BOOL)loginInitWithCerPath:(NSString *)cerPath verifyMode:(LOGIN_E_VERIFY_MODE)verifyMode
{
    cerPath = cerPath.length == 0 ? @"" : cerPath;
    
    TUP_CHAR *cerPathURF8 = (TUP_CHAR *)[cerPath UTF8String];
    
    TUP_RESULT result = tup_login_init(cerPathURF8, verifyMode);
    NSLog(@"loginInitWithCerPath: tup_login_init result = %#x",result);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)setLoginLog:(LOGIN_E_LOG_LEVEL)loglevel
{
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingString:@"/TUPC60log/login"];
    TUP_RESULT result = tup_login_log_start(loglevel, 1*1024, 1, [path UTF8String]);
    NSLog(@"setLoginLog: tup_login_log_start result = %#x",result);
    return result==TUP_SUCCESS?YES:NO;
}



-(BOOL)registerLoginBack
{
    TUP_RESULT result = tup_login_register_process_notifiy((LOGIN_FN_CALLBACK_PTR)onTUPLoginNotify);
    NSLog(@"registerLoginBack: tup_login_register_process_notifiy result = %#x",result);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)loginInit
{
    BOOL result = [self setLoginLog:LOGIN_E_LOG_DEBUG];
    
    result = [self loginInitWithCerPath:nil verifyMode:LOGIN_E_VERIFY_MODE_NONE] &&result;
    result = [self registerLoginBack] && result;
    NSLog(@"loginInit:  result = %#x",result);
    return result;
}

-(BOOL)loginUninit
{
    TUP_RESULT result = tup_login_uninit();
    NSLog(@"loginUninit: tup_login_uninit result = %#x",result);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)setProxy:(NSString *)server port:(NSString *)port name:(NSString *)name pwd:(NSString *)pwd
{
    LOGIN_S_PROXY_PARAM proxy_param;
    memset(&proxy_param, 0, sizeof(LOGIN_S_PROXY_PARAM));
    
    strcpy(proxy_param.proxy_server.server_uri,[server UTF8String]);
    proxy_param.proxy_server.server_port = [port intValue];
    
    strcpy(proxy_param.proxy_auth.user_name, [name UTF8String]);
    strcpy(proxy_param.proxy_auth.password, [pwd UTF8String]);
    
    
    TUP_RESULT result = tup_login_set_proxy(&proxy_param);
    NSLog(@"setProxy: tup_login_set_proxy result = %#x",result);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)authorize:(VCUser *)user type:(LOGIN_E_SERVER_TYPE)type
{
    LOGIN_S_AUTHORIZE_PARAM authorizeParams;
    memset(&authorizeParams, 0, sizeof(LOGIN_S_AUTHORIZE_PARAM));
    authorizeParams.auth_type = LOGIN_E_AUTH_NORMAL;
    strcpy(authorizeParams.user_agent, "WEB");
    //account+pwd
    LOGIN_S_AUTH_INFO authInfo;
    memset(&authInfo, 0, sizeof(LOGIN_S_AUTH_INFO));
    strcpy(authInfo.user_name, [user.user_name UTF8String]);
    strcpy(authInfo.password, [user.password UTF8String]);
    authorizeParams.auth_info = authInfo;
    // server
    LOGIN_S_AUTH_SERVER_INFO loginAuthServer;
    memset(&loginAuthServer, 0, sizeof(LOGIN_S_AUTH_SERVER_INFO));
    loginAuthServer.server_type = type;
    loginAuthServer.server_port = [user.server_port intValue];
    strcpy(loginAuthServer.server_url, [user.server_url UTF8String]);
    strcpy(loginAuthServer.server_version, "V6R6C00");
    
    authorizeParams.auth_server = loginAuthServer;
  
    TUP_RESULT result = tup_login_authorize(&authorizeParams);
    NSLog(@"authorize: tup_login_authorize result = %#x",result);
    self.user = [user copy];
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)login:(VCUser *)user result:(AuthoriseResultBlock)block
{
   
    self.loginResultBlock = [block copy];
//    return [self authorize:user type:LOGIN_E_SERVER_TYEP_SMC];
     return [self authorize:user type:LOGIN_E_SERVER_TYPE_MEDIAX];
   
}

-(BOOL)logout
{
    return [self callDeregister:self.user.user_name];
}

-(BOOL)changePassword:(NSString *)newPwd oldPwd:(NSString *)oldPwd type:(LOGIN_E_SERVER_TYPE)type resultBlock:(ChangePwdResultBlock)block
{
    
    LOGIN_S_CHANGE_PWD_PARAM param;
    memset(&param, 0, sizeof(LOGIN_S_CHANGE_PWD_PARAM));
    memcpy(param.acAccount, [self.user.user_name UTF8String], [self.user.user_name length]);
    memcpy(param.acNumber, [self.user.user_name UTF8String], [self.user.user_name length]);
    memcpy(param.acOldPassword, [oldPwd UTF8String], [oldPwd length]);
    memcpy(param.acNewPassword, [newPwd UTF8String], [newPwd length]);
    memcpy(param.acServer, [self.user.server_url UTF8String], [self.user.server_url length]);
    param.uiPort = 443;
    param.server_type = type;
    param.eProtocol = LOGIN_D_PROTOCOL_TYPE_SIP;
    
    self.changepwdResultBlock = [block copy];
    
    TUP_RESULT result = tup_login_change_register_password(&param);
     NSLog(@"changePassword: tup_login_change_register_password result = %#x",result);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)firewareDetect:(LOGIN_S_DETECT_SERVER*) detect_server
{
    TUP_RESULT result = tup_login_firewall_detect(detect_server);
    NSLog(@"firewareDetect: tup_login_firewall_detect result = %#x",result);
    return result == TUP_SUCCESS ? YES : NO;
}

-(BOOL)buildStgTunnel:(LOGIN_S_STG_PARAM *) server
{
    TUP_RESULT result = tup_login_build_stg_tunnel(server);
    NSLog(@"buildStgTunnel: tup_login_build_stg_tunnel result = %#x",result);
    return result == TUP_SUCCESS ? YES : NO;
}




@end
