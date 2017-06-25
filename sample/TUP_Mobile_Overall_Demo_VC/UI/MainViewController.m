//
//  MainViewController.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/7.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "TUPServiceFramework.h"
#import "ChangePwdViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutBtnAction)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"ChangePWD" style:UIBarButtonItemStylePlain target:self action:@selector(changePWDBtnAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)changePWDBtnAction
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ChangePwdViewController *changePwdViewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ChangePwdViewController"];
    [self presentViewController:changePwdViewController animated:YES completion:nil];
}

-(void)logoutBtnAction
{
    [[TUPService instance] logout];
}


@end
