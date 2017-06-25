//
//  ViewController.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/2/20.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "LoginViewController.h"
#import "TUPServiceFramework.h"
#import "MainViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


- (IBAction)loginBtnClick:(id)sender
{
    VCUser *user = [[VCUser alloc] init];
    /*user.user_name = @"lsy01";
    user.password = @"Huawei@123";
    user.server_url = @"172.22.10.32";
    user.server_port = @"8443";
    user.proxy_url = @"172.22.10.32";
    user.proxy_port = @"8443";
    user.sipAccount=@"186005@example30.com";
    user.sipPassword = @"026e318167ce6593c566cb823b936bee";
    user.sipServer_Port=@"5062";
    user.sipServer_url =@"172.22.8.57";*/
    user.user_name = self.userName.text;
    user.password = self.password.text;
    user.server_url = self.regServerUrl.text;
    user.server_port = self.port.text;
    user.proxy_url = self.proxyServerUrl.text;
    user.proxy_port = self.port.text;
    [[TUPService instance] login:user result:^( int errCode, LOGIN_EVENT eType) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (errCode == TUP_SUCCESS)
            {
                [self showMainView];
            }
            else
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"Login Fail:%d type:%d",errCode,eType] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertController addAction:doneAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        });
        
    }];
    
}

-(void)showMainView
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MainViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.window.rootViewController = navigationController;
}
@end
