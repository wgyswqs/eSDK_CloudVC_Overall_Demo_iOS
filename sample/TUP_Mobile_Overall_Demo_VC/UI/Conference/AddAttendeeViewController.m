//
//  AddAttendeeViewController.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/24.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "AddAttendeeViewController.h"
#import "UIUtils.h"
#import "TUPServiceFramework.h"

@interface AddAttendeeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *attendeeListArray;
@property (weak, nonatomic) IBOutlet UITextField *numText;
@property (weak, nonatomic) IBOutlet UITableView *attendeeTabView;
@end

@implementation AddAttendeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (_attendeeListArray == nil) {
        _attendeeListArray = [[NSMutableArray alloc] init];
    }
    
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
- (IBAction)closeBtnClick:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (_numText.text.length == 0)
    {
      
         [UIUtils showAlert:@"Attendee number can't be empty"];
        return;
    }
    
    if ([_numText.text isEqualToString:[TUPService instance].user.user_name])
    {
        [UIUtils showAlert:@"don't need add yourself"];
        return;
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:_attendeeListArray];
    for (NSString *temp in tempArray)
    {
        if ([temp isEqualToString:_numText.text] || [_numText.text isEqualToString:[TUPService instance].user.user_name])
        {
             [UIUtils showAlert:@"The attendee have been in the attendee list" ];
            return;
        }
    }
    [self.attendeeListArray addObject:_numText.text];
    _numText.text = @"";
    [self.attendeeTabView reloadData];
}
- (IBAction)OKBtnClick:(id)sender {
    if (_attendeeListArray.count >0) {
        if ([[TUPService instance] conferenceBook:_attendeeListArray type:self.type]) {
            [self dismissViewControllerAnimated:YES completion:nil];
            return;
        }
         [UIUtils showAlert:@"Book conference fail" ];
        return;
    }
     [UIUtils showAlert:@"The attendee list can't be empty" ];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _attendeeListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _attendeeListArray[indexPath.row];
    return cell;
}


- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Attendee List :";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
         [_attendeeListArray removeObject:_attendeeListArray[indexPath.row]];
    }
    [tableView reloadData];
}


@end
