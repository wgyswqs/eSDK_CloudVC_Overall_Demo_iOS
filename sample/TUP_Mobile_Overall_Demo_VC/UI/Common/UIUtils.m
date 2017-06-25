//
//  UIUtils.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/20.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "UIUtils.h"
#import "LoginViewController.h"
#import "TUPServiceFramework.h"

static UIUtils *uiUtils = nil;

@implementation UIUtils

+ (instancetype)instance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uiUtils = [[UIUtils alloc] init];
    });
    
    return uiUtils;
}
//get current show viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

+(void)showAlertWithOK:(NSString *)msg
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:doneAction];
    [vc presentViewController:alertController animated:YES completion:nil];
}

+(void)showAlert:(NSString *)msg vcontrl:(UIViewController *)vc
{
    [[UIUtils instance] showMessage:msg vcontrl:vc];
}

+(void)showAlert:(NSString *)msg
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [[UIUtils instance] showMessage:msg vcontrl:vc];
}

+(void)showLoginView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    LoginViewController *loginViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = loginViewController;
}


-(void)showMessage:(NSString *)msg vcontrl:(UIViewController *)vc
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    [vc presentViewController:alert animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
}

- (void)creatAlert:(NSTimer *)timer
{
    UIAlertController *alert = [timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    if ([alert.message isEqualToString:@"change pwd success"]) {
        if ([[TUPService instance] logout]) {
            [UIUtils showLoginView];
        }
    }
    alert = nil;
}


#pragma mark - func for image rotation 
+(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //CTM exchange
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    
    //draw pic
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newPic;
}
@end
