//
//  VCCallInfo.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/16.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCConfInfo.h"

@interface VCCallInfo : NSObject

@property(nonatomic,copy)NSString *callID;
@property(nonatomic,copy)NSString *bHaveSDP;
@property(nonatomic,copy)NSString *callType;
@property(nonatomic,copy)NSString *callNum;
@property(nonatomic,strong) VCConfInfo *confInfo;

-(id)copyFromData:(void *)data;

@end
