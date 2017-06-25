/*
 * Copyright 2015 Huawei Technologies Co., Ltd. All rights reserved.
 * eSDK is licensed under the Apache License, Version 2.0 ^(the "License"^);
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *      http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "CallConnectView.h"

#import "TUPServiceFramework.h"
#import "AppDelegate.h"
#import "VCDialPad.h"
#import "CallManager.h"

#define UISCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define LocalCameraFront (1)
#define LocalCameraBack (0)

@interface CallConnectView()
{
    
    UIView *_showView;
    EAGLView *_remoteView;
    EAGLView *_locationView;
    EAGLView *_remoteBFCPView;
    
}

@property (weak, nonatomic) IBOutlet UIView *moreMenuView;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeCallButton;
@property (weak, nonatomic) IBOutlet UIButton *changeCallTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *switchCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *closeCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *muteMicButton;
@property (weak, nonatomic) IBOutlet UIButton *muteSpeakButton;

@property (weak, nonatomic) IBOutlet UIButton *routeButton;
@property (weak, nonatomic) IBOutlet UIButton *holdButton;


@property (weak, nonatomic)VCDialPad *dialView;
//Conf view

@property (weak, nonatomic) IBOutlet UIView *confMoreView;
@property (weak, nonatomic) IBOutlet UIButton *reqChairmanBtn;
@property (weak, nonatomic) IBOutlet UIButton *confBtn;

@property (weak, nonatomic) IBOutlet UIButton *preBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation CallConnectView




- (id)initWithCallInfo:(VCCallInfo *)callinfo
{
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        self.callInfo = callinfo;
        
        if (_showView == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CallConnectView" owner:self options:nil];
            
            _showView = [nib objectAtIndex:0];
            _showView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
            _showView.bounds = self.bounds;
        }
        
        self.tipLabel.hidden = NO;
        self.moreMenuView.hidden = YES;
        self.closeCameraButton.tag = 1001;
        self.confMoreView.hidden = YES;
        self.spokeInfoLab.hidden = YES;
        self.chairInfoLab.hidden = YES;
        
        self.shareBgView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.shareView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        
        [self.shareBgView setHidden:YES];
        self.ReqDChairBtn.tag = 1;
        [self.ReqDChairBtn setTitle:@"showSWin" forState:UIControlStateNormal];
        
        self.shareView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        if ([self.callInfo.callType intValue] == VOIP_CALL_TYPE_VIDEO)
        {
            [self configVideoView];
        }
        
        if (self.callInfo.confInfo.confID.length!=0)
        {
            [self reloadConferenceView];
        }
        
        [self addSubview:_showView];
        
    }
    return self;
}

-(VCCallInfo *)getCallInfo
{
    return self.callInfo;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.windowLevel = UIWindowLevelAlert;
    }
    return self;
}

-(void)reloadConferenceView
{
    self.spokeInfoLab.hidden = NO;
    self.chairInfoLab.hidden = NO;
    if (self.isSyncSwitch.isOn)
    {
        [self.preBtn setHidden:YES];
        [self.nextBtn setHidden:YES];
    }
    
    if (_attendeeListView == nil)
    {
        _attendeeListView = [[SiteContrlView alloc] init];
        _attendeeListView.confInfo = self.callInfo.confInfo;
        [_attendeeListView reloadView];
    }
    
    if ([self.callInfo.confInfo.isChairman intValue] == 0)
    {
        [self.reqChairmanBtn setTitle:@"RQChair" forState:UIControlStateNormal];
    }
    else
    {
        [self.reqChairmanBtn setTitle:@"RLChair" forState:UIControlStateNormal];
    }
}


-(void)configVideoView
{
    
    [self.changeCallTypeButton setTitle:@"Audio" forState:UIControlStateNormal];
    self.tipLabel.hidden = YES;
    if (self.callInfo.callID.length == 0)
    {
        NSLog(@"callid is nil");
        return;
    }
    
    _remoteView = [EAGLView getRemoteView];
    [_remoteView resetVideoView];
    
    _locationView = [EAGLView getLocalView];
    
    _remoteBFCPView = [EAGLView getRemoteBFCPView];
    
    
    [[TUPService instance] configLocalVideo:_locationView remoteVideo:_remoteView callId:[self.callInfo.callID intValue]];
    
    [[TUPService instance] configRemoteBFCP:_remoteBFCPView callId:[self.callInfo.callID intValue]];
    
    [_showView addSubview:_remoteView];
    [_showView sendSubviewToBack:_remoteView];
    [_showView insertSubview:_locationView aboveSubview:_remoteView];
    [_showView insertSubview:_remoteBFCPView aboveSubview:_remoteView];
    
    [_remoteBFCPView setHidden:YES];
    
    self.closeCameraButton.tag = CAMERA_TYPE_FRONT;
    
}

-(EAGLView *)remoteBFCPView
{
    return _remoteBFCPView;
}

-(void)closeVideoView
{
    self.tipLabel.hidden = NO;
    self.closeCameraButton.tag = 1001;
    [self.changeCallTypeButton setTitle:@"Video" forState:UIControlStateNormal];
    
    if (_remoteView)
    {
        [_remoteView removeFromSuperview];
        _remoteView = nil;
    }
    if (_locationView)
    {
        [_locationView removeFromSuperview];
        _locationView = nil;
    }
}

- (void)show
{
    
    [self makeKeyAndVisible];
}

- (void)dismiss
{
    if ([self.callInfo.confInfo.confHandle intValue]>0)
    {
        [[TUPService instance] distroyConfHandle:[self.callInfo.confInfo.confHandle intValue]];
    }
    
    self.callInfo = nil;
    
    [self setHidden:YES];
    [self removeFromSuperview];
    
}

#pragma call control
- (IBAction)closeCallButtonAction:(id)sender
{
    
    VCSiteInfo * mySite = [[CallManager instance] getConfSite:self.callInfo.confInfo.attendee];
    
    if ([TUPService instance].dHandle > 0)
    {
        if ([mySite.isChair isEqualToString:@"1"])
        {
            [[TUPService instance] endDataConference:[TUPService instance].dHandle];
            
        }
        else
        {
            [[TUPService instance] leaveDataConference:[TUPService instance].dHandle];
        }
        
    }
    
    if (self.callInfo.confInfo.confHandle>0 )
    {
        if ([mySite.isChair isEqualToString:@"1"])
        {
            [[TUPService instance] endConference:[self.callInfo.confInfo.confHandle intValue]];
            return;
        }
        
        if ([[TUPService instance] leaveConference:[self.callInfo.callID intValue] confHandle:[self.callInfo.confInfo.confHandle intValue]]) {
            return;
        }
        
        
    }
    [[TUPService instance] endCall:[self.callInfo.callID intValue]];
}


- (IBAction)dialNumberButtonAction:(id)sender
{
    NSLog(@"dialNumberButtonAction");
    
    if (!self.dialView)
    {
        self.dialView = [[VCDialPad alloc] init];
    }
    
    if ([self.dialView isShow])
    {
        [self.dialView hideView];
    }
    else
    {
        [self.dialView showView:self callId:self.callInfo.callID];
    }
    
}

- (IBAction)changeCallTypeButtonAction:(id)sender
{
    NSLog(@"changeCallTypeButtonAction");
    
    
    if ([self.callInfo.callType intValue]== VOIP_CALL_TYPE_AUDIO)
    {
        if ([self.callInfo.confInfo.confHandle intValue]>0)
        {
            NSLog(@"audio conference update video");
            
            [[TUPService instance] upgradeConference:[self.callInfo.confInfo.confHandle intValue]];
            return;
        }
        [[TUPService instance] upgradeAudio2Video:[self.callInfo.callID intValue]];
    }
    else
    {
        if ([self.callInfo.confInfo.confHandle intValue]>0)
        {
            NSLog(@"conference is video");
            
            return;
        }
        if ([[TUPService instance] downgradeVideo2Audio:[self.callInfo.callID intValue]])
        {
            [self closeVideoView];
        }
    }
    
    
}

- (IBAction)moreButtonAction:(id)sender
{
    if (_moreMenuView.hidden )
    {
        _moreMenuView.hidden = NO;
    }
    else
    {
        _moreMenuView.hidden = YES;
    }
}
- (IBAction)holdButtonAction:(id)sender
{
    NSLog(@"holdButtonAction");
    if ([self.holdButton.currentTitle isEqualToString:@"Hold"] )
    {
        [self.holdButton setTitle:@"Unhold" forState:UIControlStateNormal];
        [[TUPService instance] holdCall:[self.callInfo.callID intValue]];
    }
    else
    {
        [self.holdButton setTitle:@"Hold" forState:UIControlStateNormal];
        [[TUPService instance] unholdCall:[self.callInfo.callID intValue]];
    }
}

- (IBAction)muteMicButtonAction:(id)sender
{
    NSLog(@"muteMicButtonAction");
    if ([self.muteMicButton.currentTitle isEqualToString:@"Mute mic"] )
    {
        [self.muteMicButton setTitle:@"Unmute mic" forState:UIControlStateNormal];
        [[TUPService instance] muteMic:YES callId:[self.callInfo.callID intValue]];
    }
    else
    {
        [self.muteMicButton setTitle:@"Mute mic" forState:UIControlStateNormal];
        [[TUPService instance] muteMic:NO callId:[self.callInfo.callID intValue]];
    }
}
- (IBAction)muteSpeakButtonAction:(id)sender
{
    NSLog(@"muteSpeakButtonAction");
    if ([self.muteSpeakButton.currentTitle isEqualToString:@"Mute speak"] )
    {
        [self.muteSpeakButton setTitle:@"Unmute speak" forState:UIControlStateNormal];
        [[TUPService instance] muteSpeak:YES callId:[self.callInfo.callID intValue]];
    }
    else
    {
        [self.muteSpeakButton setTitle:@"Mute speak" forState:UIControlStateNormal];
        [[TUPService instance] muteSpeak:NO callId:[self.callInfo.callID intValue]];
    }
}


- (IBAction)switchCameraButtonAction:(id)sender
{
    if (self.closeCameraButton.tag == 1001)
    {
        NSLog(@"Camera have been close");
        
        return;
    }
    self.closeCameraButton.tag = self.closeCameraButton.tag==CAMERA_TYPE_FRONT?CAMERA_TYPE_BACK:CAMERA_TYPE_FRONT;
    [[TUPService instance] resetVideoOrient:[self.callInfo.callID intValue] cameraIndex:self.closeCameraButton.tag];
}


- (IBAction)closeCameraButtonAction:(id)sender
{
    if ([self.closeCameraButton.currentTitle isEqualToString:@"Close"])
    {
        [self.closeCameraButton setTitle:@"Open" forState:UIControlStateNormal];
        [[TUPService instance] videoControl:STOP module:CAPTURE callId:[self.callInfo.callID intValue]];
        self.closeCameraButton.tag = 1001;
        [self.switchCameraButton setHidden:YES];
        [_locationView hideView];
    }
    else
    {
        [self.closeCameraButton setTitle:@"Close" forState:UIControlStateNormal];
        [[TUPService instance] videoControl:START module:CAPTURE callId:[self.callInfo.callID intValue]];
        self.closeCameraButton.tag = CAMERA_TYPE_FRONT;
        [self.switchCameraButton setHidden:NO];
        [_locationView showView];
    }
    
}


- (IBAction)routeButtonAction:(id)sender
{
    if ([self.routeButton.currentTitle isEqualToString:@"LoudSpeaker"])
    {
        [self.routeButton setTitle:@"Earpiece" forState:UIControlStateNormal];
        [[TUPService instance] changeAudioRoute:ROUTE_EARPIECE_TYPE];
    }
    else
    {
        [self.routeButton setTitle:@"LoudSpeaker" forState:UIControlStateNormal];
        [[TUPService instance] changeAudioRoute:ROUTE_LOUDSPEAKER_TYPE];
    }
}

#pragma call control end

#pragma conference control

- (IBAction)confMoreBtnClick:(id)sender
{
    if ([self.callInfo.confInfo.confID intValue]==0 && [self.callInfo.confInfo.confHandle intValue]==0)
    {
        return;
    }
    if (_confMoreView.hidden )
    {
        _confMoreView.hidden = NO;
    }
    else
    {
        _confMoreView.hidden = YES;
    }
    
}
- (IBAction)reqChairmanBtnClick:(id)sender
{
    if ([self.callInfo.confInfo.isChairman intValue] == 0)
    {
        if ([[TUPService instance] requestChairman:@"000000" number:[TUPService instance].user.user_name confHandle:[self.callInfo.confInfo.confHandle intValue]])
        {
            self.chairInfoLab.text = @"requiring chair man";
        }
        
    }
    else
    {
        if ([[TUPService instance] releaseChairman:[TUPService instance].user.user_name confHandle:[self.callInfo.confInfo.confHandle intValue]])
        {
            self.chairInfoLab.text = @"releasing chair man";
        }
        
    }
}

- (IBAction)ReqDChairBtnClick:(id)sender
{
    if (self.ReqDChairBtn.tag == 1)
    {
        self.ReqDChairBtn.tag =0;
        self.shareBgView.hidden = NO;
        [self.ReqDChairBtn setTitle:@"closeSWin" forState:UIControlStateNormal];
        return;
    }
    
    self.ReqDChairBtn.tag =1;
    self.shareBgView.hidden = YES;
    [self.ReqDChairBtn setTitle:@"showSWin" forState:UIControlStateNormal];
}

- (IBAction)listAttendeeBtnClick:(id)sender
{
    if (_attendeeListView == nil)
    {
        _attendeeListView = [[SiteContrlView alloc] init];
    }
    [_attendeeListView showSiteContrlView:self];
    
}


- (IBAction)isSyncValueChange:(id)sender
{
    if (self.isSyncSwitch.isOn)
    {
        VCDocInfo *docInfo =  [[TUPService instance] getDConfDSSyncInfo:[TUPService instance].dHandle];
        [[TUPService instance]handleDConfPageChanged:[TUPService instance].dHandle docId:[docInfo.docId intValue] pageId:[docInfo.pageId intValue]];
        
        [self.preBtn setHidden:YES];
        [self.nextBtn setHidden:YES];
    }
    else
    {
        [self.preBtn setHidden:NO];
        [self.nextBtn setHidden:NO];
    }
}
- (IBAction)preBtnClick:(id)sender
{
    if (self.currentPage > 0)
    {
        self.currentPage --;
    }
    [[TUPService instance]handleDConfPageChanged:[TUPService instance].dHandle docId:self.currentDoc pageId:self.currentPage];
}
- (IBAction)nextBtnClick:(id)sender
{
    
    self.currentPage ++;
    [[TUPService instance]handleDConfPageChanged:[TUPService instance].dHandle docId:self.currentDoc pageId:self.currentPage];
    
}


#pragma conference control end




@end
