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

#import <UIKit/UIKit.h>
#import "CommonDefine.h"
#import "VCCallInfo.h"
#import "SiteContrlView.h"
#import "EAGLView.h"

typedef enum
{
    CALL_CONNECT_CALL,
    CALL_CONNECT_CONFERENCE,
    CALL_CONNECT_DATA_CONFERENCE
}CALL_CONNECT_TYPE;

@interface CallConnectView : UIWindow

@property (weak, nonatomic) IBOutlet UILabel *spokeInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *chairInfoLab;
@property (weak, nonatomic) IBOutlet UIImageView *shareView;
@property (strong, nonatomic)SiteContrlView *attendeeListView;
@property(strong,nonatomic)VCCallInfo *callInfo;
@property (weak, nonatomic) IBOutlet UIView *shareBgView;
@property (weak, nonatomic) IBOutlet UISwitch *isSyncSwitch;
@property (strong, nonatomic) IBOutlet UIButton *ReqDChairBtn;

@property(nonatomic) int currentPage;
@property(nonatomic) int currentDoc;

- (id)initWithCallInfo:(VCCallInfo *)callinfo;
-(void)closeVideoView;
-(void)configVideoView;
- (void)show;
- (void)dismiss;
-(void)reloadConferenceView;
-(EAGLView *)remoteBFCPView;
@end
