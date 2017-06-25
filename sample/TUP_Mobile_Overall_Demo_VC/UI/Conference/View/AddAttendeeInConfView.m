//
//  AddAttendeeInConfView.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/29.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "AddAttendeeInConfView.h"
#import "TUPServiceFramework.h"

@implementation AddAttendeeInConfView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)addAttendeeBtnClick:(id)sender {
    if (self.addAttendeeText.text.length == 0 || self.confHandle == 0)
    {
        return;
    }
    
    [[TUPService instance] addAttendee:self.addAttendeeText.text confHandle:self.confHandle];
    
    [self removeFromSuperview];
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

@end
