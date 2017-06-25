//
//  CallManager.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/17.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TUPServiceFramework.h"
#import "CallConnectView.h"

@interface CallManager : NSObject<TUPVCCallDelegate>

+ (instancetype)instance;
-(void)configVideoView;
-(void)closeAlertView;
-(VCSiteInfo *)getConfSite:(VCAttendee*)attendee;

@end
