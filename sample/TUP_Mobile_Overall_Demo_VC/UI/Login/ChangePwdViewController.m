//
//  ChangePwdViewController.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/4/7.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "ChangePwdViewController.h"

#import "TUPServiceFramework.h"

@interface ChangePwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPwdTxt;
@property (weak, nonatomic) IBOutlet UITextField *nPwdTxt;
@property (weak, nonatomic) IBOutlet UITextField *cPwdTxt;


@end

@implementation ChangePwdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)closeBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (IBAction)changePwdBtnClick:(id)sender
{
    if (_oldPwdTxt.text.length==0 || _nPwdTxt.text.length==0 || _cPwdTxt.text.length==0)
    {
        [UIUtils showAlert:@"param is nil" vcontrl:self];
        return;
    }
    if (![_cPwdTxt.text isEqualToString:_nPwdTxt.text])
    {
        [UIUtils showAlert:@"param is error" vcontrl:self];
        return;
    }
    [[TUPService instance] changePassword:_nPwdTxt.text oldPwd:_oldPwdTxt.text type:LOGIN_E_SERVER_TYEP_SMC resultBlock:^(int errCode)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (errCode == 0)
             {
                 
                 [UIUtils showAlert:@"change pwd success" vcontrl:self];
                 
             }
             else
             {
                 [UIUtils showAlert:[NSString stringWithFormat:@"change pwd fail :%d",errCode] vcontrl:self];
             }
         });
     }];
    
}



@end
