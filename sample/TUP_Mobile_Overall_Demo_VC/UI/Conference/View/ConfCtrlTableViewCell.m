//
//  ConfCtrlTableViewCell.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/4/13.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "ConfCtrlTableViewCell.h"
#import "TUPServiceFramework.h"
#import "UIUtils.h"

@implementation ConfCtrlTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)kickoutBtnClick:(id)sender
{
    
    if ([self.isChairman intValue]!=1)
    {
        [UIUtils showAlert:@"you are not chair man!"];
        return;
    }
    
    [[TUPService instance] kickOutUser:self.siteInfo.dataConfRecord.user_alt_id confHandle:[TUPService instance].dHandle];
}

- (IBAction)presenterBtnClick:(id)sender
{
    
    if ([self.isChairman intValue]!=1)
    {
        [UIUtils showAlert:@"you are not chair man!"];
        return;
    }
    
    [[TUPService instance] setUser:self.siteInfo.dataConfRecord.user_alt_id role:VC_CONF_ROLE_PRESENTER  confHandle:[TUPService instance].dHandle];
}

- (void)reloadCell
{
    
    NSLog(@"reloadCell %@",self.siteInfo.dataConfRecord.user_alt_id);
    self.numLabel.text = self.siteInfo.attendeeName;
    BOOL ischair = [self.siteInfo.isChair isEqualToString:@"1"];
    if (ischair)
    {
        [self.isChair setHidden:NO];
        // [self.dataConfBtn setHidden:NO];
       
    }else
    {
        [self.isChair setHidden:YES];
       // [self.dataConfBtn setHidden:YES];
    }
    
    if ([self.siteInfo.TPMain intValue] == 0) {
        [self.watchBtn setImage:[UIImage imageNamed:@"btn_eye_white_normal"] forState:UIControlStateNormal];
    }
    else
    {
         [self.watchBtn setImage:[UIImage imageNamed:@"btn_eye_green_normal"] forState:UIControlStateNormal];
    }
    
    if ([self.siteInfo.mute intValue]== 0)
    {
        [self.micMute setImage:[UIImage imageNamed:@"btn_mic_conf_normal"] forState:UIControlStateNormal];
    }else
    {
        [self.micMute setImage:[UIImage imageNamed:@"btn_mic_off_normal"] forState:UIControlStateNormal];
    }
    
    if ([self.siteInfo.joinConf intValue] == 0)
    {
        [self.numLabel setTextColor:[UIColor grayColor]];
         [self.hangupBtn setImage:[UIImage imageNamed:@"btn_list_voicecall_normal"] forState:UIControlStateNormal];
    }
    else
    {
        [self.numLabel setTextColor:[UIColor blackColor]];
         [self.hangupBtn setImage:[UIImage imageNamed:@"icon_hangoff"] forState:UIControlStateNormal];
    }
    
    if ([TUPService instance].dHandle>0) {
       
        [self.kickoutBtn setHidden:NO];
        [self.presenterBtn setHidden:NO];
    }
    else
    {
        [self.kickoutBtn setHidden:YES];
        [self.presenterBtn setHidden:YES];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)hangupBtnClick:(id)sender
{
    
    if ([self.isChairman intValue]!=1)
    {
        [UIUtils showAlert:@"you are not chair man!"];
        return;
    }
    
    if ([self.siteInfo.joinConf intValue] == 0)
    {
        [[TUPService instance] recallAttendee:self.siteInfo.attendee confHandle:self.confHandle];
    }
    else
    {
        [[TUPService instance]handupAttendee:self.siteInfo.attendee confHandle:self.confHandle];
    }
    
}

- (IBAction)micMuteBtnClick:(id)sender
{
    if ([self.isChairman intValue]!=1)
    {
        [UIUtils showAlert:@"you are not chair man!"];
        return;
    }
    
    if ([self.siteInfo.mute intValue] == 0)
    {
        [[TUPService instance] muteAttendee:self.siteInfo.attendee isMute:YES confHandle:self.confHandle];
    }
    else
    {
        [[TUPService instance] muteAttendee:self.siteInfo.attendee isMute:NO confHandle:self.confHandle];
    }
    
}

- (IBAction)watchBtnClick:(id)sender
{
    
    if ([self.isChairman intValue]!=1)
    {
        [UIUtils showAlert:@"you are not chair man!"];
        return;
    }
    
    if ([self.siteInfo.TPMain intValue] == 0)
    {
         [[TUPService instance] watchAttendee :self.siteInfo.attendee confHandle:self.confHandle];
    }
    
}

- (IBAction)dataConfBtnClick:(id)sender
{
    
    if ([self.isChairman intValue]!=1)
    {
        [UIUtils showAlert:@"you are not chair man!"];
        return;
    }
    
    [[TUPService instance] broadcast:YES attendee:self.siteInfo.attendee confHandle:self.confHandle];
}


@end
