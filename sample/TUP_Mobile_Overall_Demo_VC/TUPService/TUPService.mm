//
//  TUPService.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/2/28.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService.h"
#import "login_interface.h"

#import "TUPService+Login.h"
#import "TUPService+Call.h"

#import "TUPService+Conference.h"
#import "TUPService+DataConference.h"
#import "TUPService+Contact.h"

#import "tup_service_interface.h"

@interface TUPService ()

@end



@implementation TUPService

static TUPService *g_tupService = nil;

+ (TUPService *)instance
{
    @synchronized(self) {
        if (!g_tupService) {
            g_tupService = [[TUPService alloc] init];
            [g_tupService startHeartBeat];
        }
    }
    
    return g_tupService;
}

+ (void)releaseInstance
{
    @synchronized(self) {
        if(g_tupService) {
            [g_tupService stopHeartBeatTimer];
            [TupContactsSDK sharedInstance];
            g_tupService = nil;
            
        }
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dHandle = 0;
        [self callInit];
        [self loginInit];
        [self conferenceInit];
        [self dataConferenceInit];
    }
    
    return self;
}


//-(BOOL)serviceStart
//{
//    TUP_S_INIT_PARAM param;
//    memset(&param, 0, sizeof(TUP_S_INIT_PARAM));
//    
//    param.reserved = TUP_FALSE;
//    param.with_ws_service = TUP_FALSE;
//    
//    TUP_RESULT ret = tup_service_startup(&param);
//    NSLog(@"tup_service_startup ret:%d",ret);
//    return ret==TUP_SUCCESS?YES:NO;
//}
//-(BOOL)serviceShutdown
//{
//    TUP_RESULT ret = tup_service_shutdown();
//    NSLog(@"tup_service_shutdown ret:%d",ret);
//    return ret==TUP_SUCCESS?YES:NO;
//}


@end
