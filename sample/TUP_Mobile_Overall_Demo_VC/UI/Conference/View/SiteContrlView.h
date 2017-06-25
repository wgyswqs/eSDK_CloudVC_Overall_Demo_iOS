//
//  SiteView.h
//  TUP_Mobile_Conference_Demo
//
//  Created by lwx308413 on 16/8/12.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VCConfInfo.h"
#import "TUPServiceFramework.h"


typedef enum : NSUInteger
{
    REQUEST_CHAIRMAN_ACTION,
    LOCK_CONFERENCE_ACTION,
    MUTE_ALLCONFERENCE_ACTION,
    POSTPONE_CONF_ACTION,
    ADD_ATTENDEE_ACTION,
    CLOSE_ACTION,
} SITEVIEW_TOP_ACTION_TYPE;

typedef enum : NSUInteger
{
    MUTE_ATTENDEE_ACTION,
    HANG_UP_ATTENDEE_ACTION,
    CALL_ATTENDEE_ACTION,
    REMOVE_ATTENDEE_ACTION,
    END_CONF_ACTION,
    BROADCAST_ATTENDEE_ACTION
} SITEVIEW_DETAIL_ACTION_TYPE;


@interface SiteContrlView : UIView

@property(nonatomic,strong) VCConfInfo *confInfo;

-(void)showSiteContrlView:(UIView *)superView;

-(void)reloadView;

-(void)hideSiteContrlView;

-(void)setAttendeeArray:(NSArray *)attendeeArray;
@end
