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

#import <QuartzCore/QuartzCore.h>
#import "EAGLView.h"

#define MAINWIDTH [UIScreen mainScreen].bounds.size.width
#define MAINHEIGHT [UIScreen mainScreen].bounds.size.height

#define BFCP_INITIATIVE_VIEW_SIZE CGRectMake(0, 0, 1024, 736)
#define BFCP_PASSIVE_VIEW_SIZE CGRectMake(MAINWIDTH-200, MAINHEIGHT-200, 200, 150)
#define REMOTE_OPENGL_VIEW_SIZE CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT)
#define LOCAL_OPENGL_VIEW_SIZE  CGRectMake(MAINWIDTH-200, 0, 200, 150)

#define BLACK_SUBLAYER_NAME  @"VIDEO_VIEW_BLACK_SUBLAYER"

static EAGLView *_remoteVideoView = nil;
static EAGLView *_locationVideoView = nil;
static EAGLView *_remoteBFCPView = nil;

@implementation EAGLView

+(EAGLView *)getRemoteView
{
    if (_remoteVideoView == nil)
    {
        _remoteVideoView = [[EAGLView alloc] initWithFrame:REMOTE_OPENGL_VIEW_SIZE];
        _remoteVideoView.backgroundColor = [UIColor blackColor];
    }
    
    return _remoteVideoView;
}


+(EAGLView *)getLocalView
{
    if (_locationVideoView == nil)
    {
        _locationVideoView = [[EAGLView alloc] initWithFrame:LOCAL_OPENGL_VIEW_SIZE];
        _locationVideoView.backgroundColor = [UIColor blackColor];
    }
    
    return _locationVideoView;
}

+(EAGLView *)getRemoteBFCPView
{
    if (_remoteBFCPView == nil)
    {
        _remoteBFCPView = [[EAGLView alloc] initWithFrame:BFCP_PASSIVE_VIEW_SIZE];
        _remoteBFCPView.backgroundColor = [UIColor blackColor];
    }
    
    return _remoteBFCPView;
}


// You must implement this method
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)layoutSubviews
{
    // The framebuffer will be re-created at the beginning of the next setFramebuffer method call.
}

- (void)turnoffVideoView
{
    self.layer.transform = CATransform3DMakeScale(-1, 1, 1);
}

- (void)turnUpDownVideoView
{
    self.layer.transform = CATransform3DMakeScale(1, -1, 1);
}

- (void)resetVideoView
{
	self.layer.transform = CATransform3DMakeScale(1, 1, 1);
}

- (void)addBlackSublayer
{
    [self deleteBlackSublayer];
    self.layer.masksToBounds = YES;
	CALayer *subLayer = [CALayer layer];
	subLayer.name = BLACK_SUBLAYER_NAME;
	subLayer.backgroundColor = [UIColor blackColor].CGColor;
    subLayer.frame = CGRectMake(0, 0, MAINWIDTH, MAINHEIGHT);
	[self.layer addSublayer:subLayer];
	
}

- (void)deleteBlackSublayer
{
	for (CALayer *sublayer in [self.layer sublayers])
    {
		if ([sublayer.name isEqualToString:BLACK_SUBLAYER_NAME])
        {
			[sublayer removeFromSuperlayer];
            self.layer.masksToBounds = NO;
			break;
		}
	}
	self.layer.doubleSided = TRUE;
}

- (void)hideView
{
    [self addBlackSublayer];
}

- (void)showView
{
    [self deleteBlackSublayer];
}

@end
@implementation BFCPInitiativeView

+ (BFCPInitiativeView *)getBFCPInitiativeView
{
    static BFCPInitiativeView *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BFCPInitiativeView alloc]initWithFrame:BFCP_INITIATIVE_VIEW_SIZE];
    });
    return instance;
}
@end

