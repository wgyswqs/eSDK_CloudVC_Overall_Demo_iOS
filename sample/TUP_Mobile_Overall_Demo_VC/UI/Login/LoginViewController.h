//
//  ViewController.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/2/20.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *regServerUrl;
@property (weak, nonatomic) IBOutlet UITextField *proxyServerUrl;
@property (weak, nonatomic) IBOutlet UITextField *port;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *password;

- (IBAction)loginBtnClick:(id)sender;
@end

