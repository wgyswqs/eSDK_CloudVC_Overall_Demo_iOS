//
//  MeetingViewController.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/17.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "MeetingViewController.h"
#import "TUPServiceFramework.h"
#import "AddAttendeeViewController.h"

@interface MeetingViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MeetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UIViewController *controller = segue.destinationViewController;
    if ([controller isKindOfClass:[AddAttendeeViewController class]])
    {
        ((AddAttendeeViewController *)controller).type = ((UIButton *)sender).tag;
    }
}


-(void)initUI
{
    _callingActivityIndicator.hidden = YES;
    self.title = [TUPService instance].user.user_name;
    self.conferenceListTableView.dataSource = self;
    self.conferenceListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.conferenceListTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshConfList)];
    self.navigationItem.rightBarButtonItem = rightItem;
   
}

-(void)refreshConfList
{
    NSLog(@"refreshConfList");
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
   
    return cell;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Conference List :";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

@end
