//
//  TUPService+Contact.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/4/5.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService+Contact.h"


@implementation TUPService (Contact)

+(void)contactInit
{

    TupContactsSDK *mgr = [TupContactsSDK sharedInstance];
    if (mgr == nil)
    {
        return;
    }
    
    [mgr setLogParam:TupContactsLogInfo maxSizeKB:2*1024 fileCount:1 logPath:@""];
    [mgr setUserAccount:[TUPService instance].user.user_name];
}


@end
