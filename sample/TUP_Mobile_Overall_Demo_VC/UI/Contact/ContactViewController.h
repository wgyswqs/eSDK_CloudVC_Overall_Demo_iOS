//
//  ContactViewController.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/4/6.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TupContactsSDK.h"
@interface ContactViewController : UIViewController

@property(nonatomic,assign)int flag;
@property(nonatomic,strong)TupContact *contact;

@end
