//
//  VCAttendee.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/28.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCAttendee : NSObject
@property(nonatomic,copy)NSString *McuNum;      /**< [en]Indicates M, 0 is invalid, 1-192 is valid. */
@property(nonatomic,copy)NSString *TerminalNum;

@property(nonatomic,copy)NSString *volumn;

-(id)copyFromData:(void *)data;
@end
