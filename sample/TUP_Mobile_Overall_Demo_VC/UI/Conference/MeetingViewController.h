//
//  MeetingViewController.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/17.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *conferenceListTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *callingActivityIndicator;

@end
