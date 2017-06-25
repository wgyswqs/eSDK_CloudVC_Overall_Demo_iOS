//
//  DialSecondPlate.h
//  TUP_Mobile_Conference_Demo
//
//  Created by lwx308413 on 16/8/23.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface VCDialPad : UIView


+(instancetype)shareInstance;

-(BOOL)isShow;

-(void)showView:(UIView *)superView callId:(NSString *)callId;

-(void)hideView;
@end
