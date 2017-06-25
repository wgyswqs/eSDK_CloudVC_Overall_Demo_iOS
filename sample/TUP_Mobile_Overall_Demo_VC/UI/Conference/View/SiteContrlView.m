//
//  SiteView.m
//  TUP_Mobile_Conference_Demo
//
//  Created by lwx308413 on 16/8/12.
//  Copyright © 2016年 huawei. All rights reserved.
//

#import "SiteContrlView.h"
#import "VCSiteInfo.h"
#include <sys/sysctl.h>
#import "AddAttendeeInConfView.h"
#import "ConfCtrlTableViewCell.h"


@interface SiteContrlView()<UITableViewDelegate,UITableViewDataSource>
{

    __weak IBOutlet AddAttendeeInConfView *addview;
}
@property (weak, nonatomic) IBOutlet UIButton *postponeConfButton;
@property (weak, nonatomic) IBOutlet UIButton *addAttendeeButton;

@property (weak, nonatomic) IBOutlet UITableView *siteTableView;
@property (nonatomic,copy) NSMutableArray *siteArray;

@end

@implementation SiteContrlView

-(instancetype)init
{
    if (self = [super init])
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SiteContrlView" owner:self options:nil];
        self = [nib objectAtIndex:0];
        self.siteTableView.delegate = self;
        self.siteTableView.dataSource = self;
        self.siteTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return self;
}

-(void)showSiteContrlView:(UIView *)superView
{
  
    self.frame = CGRectMake(10, 64,[UIScreen mainScreen].bounds.size.width-20,[UIScreen mainScreen].bounds.size.height-128);
   
    [superView addSubview:self];
    [self reloadView];
   
}

-(void)hideSiteContrlView
{
    [self removeFromSuperview];
}

-(void)reloadView
{
    if ([self.confInfo.isChairman intValue]>0)
    {
        [self.addAttendeeButton setHidden:NO];
        [self.postponeConfButton setHidden:NO];
    }
    else
    {
        [self.addAttendeeButton setHidden:YES];
        [self.postponeConfButton setHidden:YES];
    }
    
     [self.siteTableView reloadData];
    
}


- (IBAction)addAttendeeButtonAction:(id)sender
{
    if (!addview)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SiteContrlView" owner:self options:nil];
        addview =  [nib objectAtIndex:1];
        addview.frame = CGRectMake(0, 40,addview.frame.size.width,addview.frame.size.height);
    }
    addview.confHandle = [self.confInfo.confHandle intValue];
    
    [self addSubview:addview];

}


- (IBAction)closeSiteContrlViewButtonAction:(id)sender
{
    [self hideSiteContrlView];
}
- (IBAction)postponeBtnClick:(id)sender {
   
   BOOL ret = [[TUPService instance] postponeConference:[self.confInfo.confHandle intValue] time:30];
    [self.postponeConfButton setTitle:@"success" forState:UIControlStateNormal];
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(postponeBtnResult) object:nil];
    [self performSelector:@selector(postponeBtnResult) withObject:nil afterDelay:2.0];
}
- (void)postponeBtnResult
{
    [self.postponeConfButton setTitle:@"postpone" forState:UIControlStateNormal];
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VCSiteInfo *member = self.siteArray[indexPath.row];
    NSLog(@"member %@",member.attendeeName);

}

-(void)setAttendeeArray:(NSArray *)attendeeArray
{
    _siteArray = attendeeArray;
    [self reloadView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _siteArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfCtrlTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"siteCell"];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ConfCtrlTableViewCell" owner:self options:nil] lastObject];
    }
    
    cell.siteInfo = [_siteArray objectAtIndex:indexPath.row];
    cell.confHandle = [self.confInfo.confHandle intValue];
    cell.isChairman = self.confInfo.isChairman;
    
    [cell reloadCell];
    
    return cell;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Participants List:";
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    if ([self.confInfo.isChairman intValue]>0)
    {
        return YES;
    }
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        NSArray *arr = [NSArray arrayWithObjects:((VCSiteInfo *)[_siteArray objectAtIndex:indexPath.row]).attendee, nil];
        if ([[TUPService instance] removeAttendee:arr confHandle:[self.confInfo.confHandle intValue]])
        {
            [_siteArray removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}
@end
