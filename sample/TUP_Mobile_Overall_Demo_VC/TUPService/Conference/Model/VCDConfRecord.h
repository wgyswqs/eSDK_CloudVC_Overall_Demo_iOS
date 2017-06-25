//
//  VCDConfRecord.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/4/26.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCDConfRecord : NSObject
@property(nonatomic,copy)NSString *user_alt_id;
/**< [en]Indicates the user ID.  */

@property(nonatomic,copy)NSString *device_type;
/**< [en]Indicates the device type.  */

@property(nonatomic,copy)NSString *os_type;
/**< [en]Indicates the operation system type.  */

@property(nonatomic,copy)NSString * user_presence_flag;
/**< [en]Indicates the user status.*/

@property(nonatomic,copy)NSString *user_capability;
/**< [en]Indicates the user capability, controlled by the application layer. */

@property(nonatomic,copy)NSString *user_status;
/**< [en]Indicates the user rights information, temporarily. */

@property(nonatomic,copy)NSString * user_name;
/**< [en]Indicates the user name.  */

@property(nonatomic,copy)NSString *user_alt_uri;
/**< [en]Indicates the user uniform identity.  */

@property(nonatomic,copy)NSData *user_info;
/**< [en]Indicates user information data. */

@property(nonatomic,copy)NSString *server_ip;
/**< [en]Indicates a meeting server address, a single address, or a URL.  */

@property(nonatomic,copy)NSString *local_ip;
/**< [en]Indicates the local ip address.  */


-(id)copyFromData:(void *)data;
-(void)clear;
@end
