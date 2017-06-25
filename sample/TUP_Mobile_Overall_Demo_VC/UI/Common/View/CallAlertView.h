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
#import "VCCallInfo.h"
#import "AppDelegate.h"

@class CallAlertView;

typedef enum
{
    CALL_ALERT_ACTION_INCOMMING_CALL,
    CALL_ALERT_ACTION_OUTGOING_CALL,
    CALL_ALERT_ACTION_VIDEO_CALL
}CALL_ALERT_ACTION_TYPE;

@interface CallAlertView : UIWindow

@property(strong,nonatomic)VCCallInfo *callInfo;

- (id)initWithType:(CALL_ALERT_ACTION_TYPE)type callInfo:(VCCallInfo *)callinfo;
- (void)show;
- (void)dismiss;
@end


