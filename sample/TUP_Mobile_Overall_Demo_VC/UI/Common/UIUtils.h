//
//  UIUtils.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/20.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtils : NSObject
//get current show viewcontroller
+ (UIViewController *)getCurrentVC;
+(void)showAlert:(NSString *)msg;
+(void)showAlert:(NSString *)msg vcontrl:(UIViewController *)vc;
+(void)showAlertWithOK:(NSString *)msg;
+(void)showLoginView;

+(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation;
@end
