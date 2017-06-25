//
//  CallViewController.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/7.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "CallViewController.h"
#import "TUPServiceFramework.h"
#import "EAGLView.h"
#import "CallManager.h"

@interface CallViewController ()
{
    EAGLView *_openGLPreviewView ;
}


@end

@implementation CallViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"Preview" style:UIBarButtonItemStylePlain target:self action:@selector(previewButtonAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.title = @"Call";
    
}

- (void)didReceiveMemoryWarning
{
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

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (IBAction)audioBtnClick:(id)sender
{
    if(self.numberText.text.length==0)
    {
        return;
    }
   
    
    int callid = [[TUPService instance] makeCall:self.numberText.text type:VOIP_CALL_TYPE_AUDIO];
    
}

- (IBAction)videoBtnClick:(id)sender
{
    if(self.numberText.text.length==0)
    {
        return;
    }
    int callid = [[TUPService instance] makeCall:self.numberText.text type:VOIP_CALL_TYPE_VIDEO];

}

-(void)previewButtonAction
{
    if (_openGLPreviewView == nil)
    {
        _openGLPreviewView = [[EAGLView alloc] initWithFrame:self.view.bounds];
        [[TUPService instance] startVideoPreview:_openGLPreviewView];
        [self.view addSubview:_openGLPreviewView];
    }
    else
    {
        [_openGLPreviewView removeFromSuperview];
        _openGLPreviewView = nil;
         [[TUPService instance] stopVideoPreview];
    }
}
@end
