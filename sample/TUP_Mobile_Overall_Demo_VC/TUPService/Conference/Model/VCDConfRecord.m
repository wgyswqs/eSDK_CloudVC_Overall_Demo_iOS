//
//  VCDConfRecord.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/4/26.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "VCDConfRecord.h"
#import "tup_conf_basedef.h"

@implementation VCDConfRecord
-(id)init
{
    self = [super init];
    if (self) {
        
        [self clear];
       
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    VCDConfRecord *newRecord = [[[self class] allocWithZone:zone] init];
    newRecord.user_alt_id = self.user_alt_id;
    newRecord.user_presence_flag = self.user_presence_flag;
    newRecord.user_capability = self.user_capability;
    newRecord.user_info = self.user_info;
    newRecord.user_status = self.user_status;
    newRecord.user_alt_uri = self.user_alt_uri;
    newRecord.user_name = self.user_name;
    newRecord.server_ip = self.server_ip;
    newRecord.local_ip = self.local_ip;
    newRecord.device_type = self.device_type;
    newRecord.os_type = self.os_type;
    
    return newRecord;
}

-(id)copyFromData:(void *)data
{
    TC_Conf_User_Record *record = (TC_Conf_User_Record *)data;
    
    
    self.user_name = [NSString stringWithUTF8String: record->user_name];
    self.user_alt_uri =[NSString stringWithUTF8String:record->user_alt_uri];
    self.user_status = [NSString stringWithFormat:@"%d",record->user_status];
    self.user_info = [NSData dataWithBytes:record->user_info length:record->user_info_len];
    self.user_capability = [NSString stringWithFormat:@"%d",record->user_capability];
    self.user_presence_flag =[NSString stringWithFormat:@"%d",record->user_presence_flag];
    self.user_alt_id = [NSString stringWithFormat:@"%d",record->user_alt_id];
    self.server_ip = [NSString stringWithUTF8String:record->server_ip];
    self.local_ip = [NSString stringWithUTF8String:record->local_ip];
    self.device_type = [NSString stringWithFormat:@"%d",record->device_type];
    
    self.os_type = [NSString stringWithFormat:@"%d",record->os_type];
   
    return self;
}

-(void)clear{
    self.user_alt_id = @"";
    self.user_name = @"";
    self.user_info = [[NSData alloc] init];
    self.user_alt_uri = @"";
    self.user_status = @"";
    self.user_capability = @"";
    self.user_presence_flag = @"";
    self.device_type = @"";
    self.os_type = @"";
    self.server_ip = @"";
    
    self.local_ip = @"";
}
@end
