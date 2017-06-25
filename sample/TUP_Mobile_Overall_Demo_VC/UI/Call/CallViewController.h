//
//  CallViewController.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/7.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *numberText;

- (IBAction)audioBtnClick:(id)sender;
- (IBAction)videoBtnClick:(id)sender;

@end
