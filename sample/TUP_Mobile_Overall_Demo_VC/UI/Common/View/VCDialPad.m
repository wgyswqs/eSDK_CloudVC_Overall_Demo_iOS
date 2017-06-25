//
//  DialSecondPlate.m
//  TUP_Mobile_Conference_Demo
//
//  Created by lwx308413 on 16/8/23.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "VCDialPad.h"
#import "TUPServiceFramework.h"

@interface VCDialPad()
{
    BOOL _isShow;
    NSString *_callId;
}
@end

@implementation VCDialPad

-(instancetype)init
{
    if (self = [super init])
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VCDialPad" owner:self options:nil];
        self = [nib objectAtIndex:0];
        _isShow = NO;
    }
    return self;
}

-(void)showView:(UIView *)superView callId:(NSString *)callId
{
    _callId = callId;
    _isShow = YES;
    self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
    self.bounds = CGRectMake(0, 0,216,264);
    [superView addSubview:self];
}

-(void)hideView
{
    [self removeFromSuperview];
    _isShow = NO;
}

-(BOOL)isShow
{
    return _isShow;
}

- (IBAction)oneButtonAction:(id)sender
{
    UIButton *button = sender;
    [[TUPService instance] sendDTMF:button.titleLabel.text callId:[_callId intValue]];
}


- (IBAction)poundKeyButtonAction:(id)sender
{
    [self oneButtonAction:sender];
    [self hideView];
}


@end
