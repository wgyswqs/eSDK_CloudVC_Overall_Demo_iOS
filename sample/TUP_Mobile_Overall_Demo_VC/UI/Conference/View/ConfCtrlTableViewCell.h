//
//  ConfCtrlTableViewCell.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/4/13.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCSiteInfo.h"

@interface ConfCtrlTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIButton *isChair;
@property (weak, nonatomic) IBOutlet UIButton *micMute;
@property (weak, nonatomic) IBOutlet UIButton *hangupBtn;
@property (weak, nonatomic) IBOutlet UIButton *watchBtn;
@property (weak, nonatomic) IBOutlet UIButton *dataConfBtn;
@property (weak, nonatomic) IBOutlet UIButton *kickoutBtn;
@property (weak, nonatomic) IBOutlet UIButton *presenterBtn;


@property (strong, nonatomic) VCSiteInfo *siteInfo;
@property (assign, nonatomic) int confHandle;
@property(nonatomic,copy)NSString *isChairman;

- (IBAction)hangupBtnClick:(id)sender;
- (IBAction)micMuteBtnClick:(id)sender;
- (IBAction)watchBtnClick:(id)sender;
- (IBAction)dataConfBtnClick:(id)sender;
- (IBAction)kickoutBtnClick:(id)sender;
- (IBAction)presenterBtnClick:(id)sender;


- (void)reloadCell;

@end
