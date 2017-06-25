//
//  TUPService+Login.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/2/28.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService.h"
#import "login_def.h"

@interface TUPService (Login)

-(BOOL)loginInit;
-(BOOL)loginUninit;
-(BOOL)setProxy:(NSString *)server port:(NSString *)port name:(NSString *)name pwd:(NSString *)pwd;
-(BOOL)login:(VCUser *)user result:(AuthoriseResultBlock)block;
-(BOOL)changePassword:(NSString *)newPwd oldPwd:(NSString *)oldPwd type:(LOGIN_E_SERVER_TYPE)type resultBlock:(ChangePwdResultBlock)block;
-(BOOL)logout;
-(BOOL)firewareDetect:(LOGIN_S_DETECT_SERVER*) detect_server;
-(BOOL)buildStgTunnel:(LOGIN_S_STG_PARAM *) server;
@end
