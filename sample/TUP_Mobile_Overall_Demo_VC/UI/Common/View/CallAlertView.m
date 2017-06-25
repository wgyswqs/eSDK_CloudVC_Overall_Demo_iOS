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

#import "CallAlertView.h"
#import "CallManager.h"
#import "CallConnectView.h"

@interface CallAlertView()

@property (weak, nonatomic) IBOutlet UIButton *videoAnsBtn;
@end

@implementation CallAlertView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.windowLevel = UIWindowLevelAlert;
        
        //background cover
        UIView *backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.7;
        [self addSubview:backView];
        
    }
    return self;
}

- (id)initWithType:(CALL_ALERT_ACTION_TYPE)type callInfo:(VCCallInfo *)callinfo
{
    self = [self initWithFrame:[UIScreen mainScreen].bounds];
    if (self)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CallAlertView" owner:self options:nil];
        
        UIView *showView = [nib objectAtIndex:type];
        showView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        showView.bounds = CGRectMake(0, 0,350,242);
        
        self.callInfo = callinfo;
        
        if (type == CALL_ALERT_ACTION_INCOMMING_CALL && [self.callInfo.callType intValue]==VOIP_CALL_TYPE_AUDIO)
        {
            [_videoAnsBtn setHidden:YES];
        }
        
        [self addSubview:showView];
        
    }
    return self;
}

- (IBAction)answerBtnClick:(id)sender {
    if (self.callInfo == nil || self.callInfo.callID.length==0)
    {
        return;
    }

    [[TUPService instance] answerCall:VOIP_CALL_TYPE_AUDIO callId:[self.callInfo.callID intValue]];

}
- (IBAction)incommingRefuseBtnClick:(id)sender {
    
    if (self.callInfo == nil || self.callInfo.callID.length==0)
    {
        return;
    }
    
        [[TUPService instance] endCall:[self.callInfo.callID intValue]];
    
    
}
- (IBAction)cancelCallBtnClick:(id)sender {

    if (self.callInfo == nil || self.callInfo.callID.length==0)
    {
        return;
    }
   
    [[TUPService instance] endCall:[self.callInfo.callID intValue]];
    
}
- (IBAction)acceptvideoBtnClick:(id)sender {
    
    if (self.callInfo == nil || self.callInfo.callID.length==0)
    {
        return;
    }
    
    
    BOOL isSuccess = [[TUPService instance] replyVideoCall:YES callId:[self.callInfo.callID intValue]];
    NSLog(@"CALLTIP_ACTION_ACCEPT_VIDEO_CALL %d",isSuccess);
    if (isSuccess)
    {
        [[CallManager instance] configVideoView];
    }
    
    
}
- (IBAction)refuseVideoBtnClick:(id)sender {
   
    if (self.callInfo == nil || self.callInfo.callID.length==0)
    {
        return;
    }

    
    [[TUPService instance] replyVideoCall:NO callId:[self.callInfo.callID intValue]];
    
    [[CallManager instance] closeAlertView];
    
}
- (IBAction)videoAnsBtnClick:(id)sender {
    if (self.callInfo == nil || self.callInfo.callID.length==0)
    {
        return;
    }
    
    [[TUPService instance] answerCall:VOIP_CALL_TYPE_VIDEO callId:[self.callInfo.callID intValue]];
}

- (void)show
{
    
    [self makeKeyAndVisible];
}

- (void)dismiss
{
    [self setHidden:YES];
    [self removeFromSuperview];

}

@end
