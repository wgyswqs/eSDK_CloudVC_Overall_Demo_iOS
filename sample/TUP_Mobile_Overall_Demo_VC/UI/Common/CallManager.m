//
//  CallManager.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/17.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "CallManager.h"
#import "AppDelegate.h"
#import "UIUtils.h"

#import "CallAlertView.h"


static CallManager *callBusinessManager = nil;

@interface CallManager ()
{
    int _playHandle;
    CallAlertView *_incommingCallAlert;
    CallAlertView *_outgoingCallAlert;
    CallConnectView *_callConnectView;
    NSMutableArray *_confSites;
}

@end

@implementation CallManager

+ (instancetype)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        callBusinessManager = [[CallManager alloc] init];
        
    });
    
    return callBusinessManager;
}


- (id)init
{
    self = [super init];
    if (self)
    {
        //init
        _confSites = [[NSMutableArray alloc] init];
        _playHandle = -1;
        //register delegate
        [TUPService instance].callDelegate =  self;
        [TUPService instance].confDelegate = self;
    }
    return self;
}

#pragma calldelegate

-(void)vcCallDeregister
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIUtils showLoginView];
    });
}

-(void)vcOutgoingCall:(VCCallInfo *)callInfo
{
    NSLog(@"vcOutgoingCall:callid = %@",callInfo.callID);
    
    [self stopRinging];
    NSString *wavPath = [[NSBundle mainBundle] pathForResource:@"RingTone.wav"
                                                        ofType:nil];
    _playHandle = [[TUPService instance] startPlayRingFile:wavPath];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _outgoingCallAlert =[[CallAlertView alloc] initWithType:CALL_ALERT_ACTION_OUTGOING_CALL callInfo:callInfo];
        [_outgoingCallAlert show];
    });
    
}

-(void)vcIncommingCall:(VCCallInfo *)callInfo
{
    NSLog(@"vcIncommingCall:callid = %@,confMediaType = %@",callInfo.callID,callInfo.confInfo.confMediaType);
    [self stopRinging];
    NSString *wavPath = [[NSBundle mainBundle] pathForResource:@"RingTone.wav"
                                                        ofType:nil];
    _playHandle = [[TUPService instance] startPlayRingFile:wavPath];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _incommingCallAlert = [[CallAlertView alloc] initWithType:CALL_ALERT_ACTION_INCOMMING_CALL callInfo:callInfo];
        [_incommingCallAlert show];
    });
    
}

-(void)vcCallRingBack:(VCCallInfo *)callInfo
{
    NSLog(@"vcCallRingBack:callid = %@,confMediaType = %@",callInfo.callID,callInfo.confInfo.confMediaType);
    if ([callInfo.bHaveSDP intValue]>0) {
        [self stopRinging];
    }
}

-(void)vcCallConnect:(VCCallInfo *)callInfo
{
    NSLog(@"vcCallConnect:callid = %@,confMediaType = %@",callInfo.callID,callInfo.confInfo.confMediaType);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        _callConnectView = [[CallConnectView alloc] initWithCallInfo:callInfo];
        
        [_callConnectView show];
        
        [self closeAlertView];
        
    });
    
}

-(void)vcCallEnd:(VCCallInfo *)callInfo{
    NSLog(@"vcCallEnd");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_callConnectView dismiss];
        _callConnectView = nil;
        [_confSites removeAllObjects];
        [self closeAlertView];
    });
}

-(void)vcUpgradeVideoCall:(unsigned int)callId
{
    NSLog(@"vcUpgradeVideoCall");
    dispatch_async(dispatch_get_main_queue(), ^{
        _incommingCallAlert = [[CallAlertView alloc] initWithType:CALL_ALERT_ACTION_VIDEO_CALL callInfo:_callConnectView.callInfo];
        [_incommingCallAlert show];
    });
}

-(void)vcUpdateCallType:(BOOL)isVideo
{
    if (isVideo)
    {
        _callConnectView.callInfo.callType = [NSString stringWithFormat:@"%d",VOIP_CALL_TYPE_VIDEO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_callConnectView configVideoView];
        });
    }
    else
    {
        _callConnectView.callInfo.callType = [NSString stringWithFormat:@"%d",VOIP_CALL_TYPE_AUDIO];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_callConnectView closeVideoView];
        });
    }
}

-(void)vcCallBFCPReceive
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_callConnectView.ReqDChairBtn.tag == 1)
        {
            [[_callConnectView remoteBFCPView] setHidden: NO];
        }
    });
    
}
-(void)vcCallBFCPStop
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[_callConnectView remoteBFCPView] setHidden: YES];
    });
}

#pragma calldelegate end

#pragma confdelegate

-(void)vcConfBookResult:(int)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (result != 0)
        {
            [UIUtils showAlertWithOK:[NSString stringWithFormat:@"book conference fail:%d",result]];
        }
        else
        {
            [UIUtils showAlert:@"book conference success!"];
        }
    });
}

-(void)vcConfConnect:(VCAttendee *)attendee confHandle:(int) confHandle
{
    
    if (_callConnectView == nil)
    {
        _callConnectView = [[CallConnectView alloc] initWithCallInfo:_incommingCallAlert.callInfo];
        _callConnectView.callInfo.confInfo.confHandle = [NSString stringWithFormat:@"%d",confHandle];
        _callConnectView.callInfo.confInfo.attendee = attendee;
        
        if (![_callConnectView.callInfo.confInfo.confMediaType isEqualToString:@"0"])
        {
            [[TUPService instance] getDataConfParam:_callConnectView.callInfo.confInfo.confID];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_callConnectView show];
            [self closeAlertView];
            
        });
    }
    else
    {
        _callConnectView.callInfo.confInfo.confHandle = [NSString stringWithFormat:@"%d",confHandle];
        _callConnectView.callInfo.confInfo.attendee = attendee;
        if (![_callConnectView.callInfo.confInfo.confMediaType isEqualToString:@"0"])
        {
            [[TUPService instance] getDataConfParam:_callConnectView.callInfo.confInfo.confID];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_callConnectView reloadConferenceView];
        });
    }
    NSLog(@"vcConfConnect: T:%@ , M:%@ , confMediaType : %@",attendee.TerminalNum,attendee.McuNum,_callConnectView.callInfo.confInfo.confMediaType);
}


-(void)vcConfUpdateSites:(VCSiteInfo *)siteInfo type:(int)type confHandle:(int) confHandle
{
    NSLog(@"vcConfUpdateSites: attendeeName:%@ , attendeeNumber:%@",siteInfo.attendeeName,siteInfo.attendeeNumber);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_callConnectView.attendeeListView setAttendeeArray: [self updateConfSite:siteInfo type:type]];
    });
    
}

-(void)vcConfUpdateAttendee:(VCAttendee *)attendee role:(int)role confHandle:(int) confHandle
{
    NSLog(@"vcConfUpdateAttendee: T:%@ , M:%@ role :%d",attendee.TerminalNum,attendee.McuNum,role);
    dispatch_async(dispatch_get_main_queue(), ^{
        VCSiteInfo * siteRole = [self getConfSite:attendee];
        switch (role) {
            case 0:
            {
                [_callConnectView.chairInfoLab setText:@"Current chairman: no one"];
            }
                break;
            case 1:
            {
                siteRole.isChair = @"1";
                [_callConnectView.chairInfoLab setText:[NSString stringWithFormat:@"Current chairman: %@",siteRole.attendeeName]];
                if ([siteRole.attendeeName isEqualToString: [TUPService instance].user.user_name])
                {
                    _callConnectView.callInfo.confInfo.isChairman = @"1";
                }

            }
                break;
            case 2:
            {
                 [_callConnectView.spokeInfoLab setText:[NSString stringWithFormat:@"Current spokesman: %@",siteRole.attendeeName]];
            }
                break;
            default:
                break;
        }
        [_callConnectView reloadConferenceView];
        
    });
}


-(void)vcConfUpdateChair:(int)confhandle result:(int)errCode isReq:(BOOL)isReq;
{
    NSLog(@"vcConfReqChair:result  confhandle:%d , errCode:%d",confhandle,errCode);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *str = isReq?@"require":@"release";
        if (errCode!=0)
        {
            
            [_callConnectView.chairInfoLab setText:[NSString stringWithFormat:@"%@ Chair man fail %d",str,errCode]];
        }
        else
        {
            [_callConnectView.chairInfoLab setText:[NSString stringWithFormat:@"%@ Chair man success",str]];
            _callConnectView.callInfo.confInfo.isChairman = isReq?@"1":@"0";
        }
        [_callConnectView reloadConferenceView];
    });
}

-(void)vcDataConfJoin:(int)result
{
    CONF_HANDLE dataConfHandle = [TUPService instance].dHandle;
    _callConnectView.callInfo.confInfo.dConfHandle =[NSString stringWithFormat:@"%d",dataConfHandle];
    NSLog(@"vcDataConfJoin :%@",_callConnectView.callInfo.confInfo.dConfHandle);
    dispatch_async(dispatch_get_main_queue(), ^{
        if (result == 0)
        {
            [[TUPService instance] loadComponent:dataConfHandle];
        }
        else
        {
            [[TUPService instance] releaseDataConference:dataConfHandle];
        }
    });
    
}

-(void)vcDataConfUpdateRecord:(VCDConfRecord *)record type:(int)type
{
    NSLog(@"vcDataConfUpdateRecord %@ : %@ ,type :%d",record.user_alt_id,record.user_name ,type);
    
    if ([record.user_name isEqualToString:[TUPService instance].user.user_name])
    {
        if (type == 1)
        {
            _callConnectView.callInfo.confInfo.userAltId = record.user_alt_id;
        }
        else
        {
            _callConnectView.callInfo.confInfo.userAltId = @"";
        }
        
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [_callConnectView.attendeeListView setAttendeeArray: [self updateDConfRecord:record type:type]];
    });
}

-(void)vcDataConfShareStop
{
    NSLog(@"vcDataConfShareStop");
    if (!_callConnectView.shareBgView.hidden)
    {
        [_callConnectView.shareBgView setHidden:YES];
        _callConnectView.ReqDChairBtn.tag = 1;
        [_callConnectView.ReqDChairBtn setTitle:@"showSWin" forState:UIControlStateNormal];
    }
}
-(void)vcDataConfShareData:(UIImage *)image type:(int)type
{
    NSLog(@"vcDataConfShareData");
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (type == 1)
        {
            [_callConnectView.isSyncSwitch setHidden:NO];
        }else
        {
            [_callConnectView.isSyncSwitch setHidden:YES];
        }
        
        if(image.size.height>image.size.width)
        {
            [_callConnectView.shareView setImage:image];
            
        }
        else
        {
            
            [_callConnectView.shareView setImage:[UIUtils image:image rotation:UIImageOrientationLeft]];
        }
        
        if (_callConnectView.ReqDChairBtn.tag == 0)
        {
            [_callConnectView.shareBgView setHidden:NO];
        }
    });
    
}

-(void)vcDataConfOld:(int)oldRole newId:(int)newRole role:(int)role result:(int) result
{
    switch (result)
    {
        case -1:
        {
            [UIUtils showAlert:[NSString stringWithFormat:@"set %d as role %d",newRole,role]];
            if (newRole = [_callConnectView.callInfo.confInfo.userAltId intValue])
            {
                _callConnectView.callInfo.confInfo.dConfRole = @(role);
            }
        }
            break;
        case -2:
        {
            [UIUtils showAlert:[NSString stringWithFormat:@"set %d as role %d",result,role]];
            if (result = [TUPService instance].user.user_name)
            {
                _callConnectView.callInfo.confInfo.dConfRole = @(role);
            }
        }
            break;
            
        default:
        {
            [UIUtils showAlert:[NSString stringWithFormat:@"set role %d : %d",role,result]];
        }
            break;
    }
}

-(void)vcDataConfSync:(int)dataConfHandle docId:(int)docId pageId:(long)pageId
{
    _callConnectView.currentDoc = docId;
    if (_callConnectView.isSyncSwitch.isOn)
    {
        _callConnectView.currentPage = pageId;
        [[TUPService instance]handleDConfPageChanged:dataConfHandle docId:docId pageId:pageId];
    }
    
}

#pragma confdelegate end


-(NSArray *)updateConfSite:(VCSiteInfo*)site type:(int)type
{
    VCSiteInfo *oldSite = [self getConfSite:site.attendee];
    
    if (oldSite)
    {
        site.dataConfRecord = oldSite.dataConfRecord;
        [_confSites removeObject:oldSite];
    }
    
    if (type != 3) {
        
        [_confSites addObject:site];
    }
    
    NSLog(@"count : %d ; _confSites %@",_confSites.count,_confSites);
    
    return _confSites;
}

-(VCSiteInfo *)getConfSite:(VCAttendee*)attendee
{
    for (int i = 0; i< _confSites.count; i++)
    {
        VCSiteInfo *siteInfo = [_confSites objectAtIndex:i];
        if ([siteInfo.attendee isEqual:attendee])
        {
            return siteInfo;
        }
    }
    return nil;
}

-(NSArray *)updateDConfRecord:(VCDConfRecord*)record type:(int)type
{
    
    NSLog(@"updateDConfRecord :%d,record :%@",[record.user_alt_id intValue],record.user_alt_id);
    VCSiteInfo *oldSite = [self getConfSite2:record.user_name];
    if (oldSite)
    {
        
        if (type== 1)
        {
            oldSite.dataConfRecord = record;
            NSLog(@"oldSite :%d,record :%@",[oldSite.dataConfRecord.user_alt_id intValue],oldSite.dataConfRecord.user_alt_id);
        }
        else
        {
            [oldSite.dataConfRecord clear] ;
        }
    }
    
    
    NSLog(@"count : %d ; _confSites %@",_confSites.count,_confSites);
    
    return _confSites;
}

-(VCSiteInfo *)getConfSite2:(NSString*)userName
{
    for (int i = 0; i< _confSites.count; i++)
    {
        VCSiteInfo *siteInfo = [_confSites objectAtIndex:i];
        if ([siteInfo.attendeeName isEqual:userName])
        {
            return siteInfo;
        }
    }
    return nil;
}

-(void)stopRinging
{
    if (_playHandle != -1)
    {
        _playHandle = [[TUPService instance] stopPlayRingHandle:_playHandle]?-1: _playHandle;
    }
}

-(void)closeAlertView
{
    if(_outgoingCallAlert)
    {
        [_outgoingCallAlert dismiss];
        _outgoingCallAlert = nil;
    }
    
    if (_incommingCallAlert)
    {
        [_incommingCallAlert dismiss];
        _incommingCallAlert = nil;
    }
    [self stopRinging];
}

-(void)configVideoView
{
    [_callConnectView configVideoView];
    [self closeAlertView];
}

@end
