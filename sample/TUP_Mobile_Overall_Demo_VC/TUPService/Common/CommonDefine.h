//
//  CommonDefine.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/3.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "login_interface.h"
#import "call_def.h"

#define __CONFERENCE__

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

#define RETURN_NO_IF_NIL(result)     if(result == nil || !result || result == NULL){return NO;}
#define RETURN_IF_NSSTRING_NIL(result)     if(result == nil || !result || result == NULL || [result isEqualToString:@""]){return;}
#define RETURN_NO_IF_NSSTRING_NIL(result)     if(result == nil || !result || result == NULL || [result isEqualToString:@""]){return NO;}
#define RETURN_IF_NIL(result)     if(result == nil || !result || result == NULL){return;}
#define RETURN_NO_IF_FAIL(result)  do { if (result == TUP_FAIL) { return NO; } } while(0)
#define SDK_CONFIG_RESULT(result)  (((TUP_SUCCESS) == result)?@"YES":[NSString stringWithFormat:@"NO error =%o",result])

typedef enum
{
    LOGIN_EVENT_AUTHORIZE,
    LOGIN_EVENT_CALL_AUTHORIZE,
    LOGIN_EVENT_UNKNOW
}LOGIN_EVENT;

typedef NS_ENUM(NSInteger, CAMERA_TYPE)
{
    CAMERA_TYPE_BACK,
    CAMERA_TYPE_FRONT
};

typedef enum
{
    VOIP_CALL_TYPE_AUDIO,
    VOIP_CALL_TYPE_VIDEO,
    VOIP_CALL_TYPE_UNKNOWN
}VOIP_CALL_TYPE;

typedef enum
{
    VC_CONF_NORMAL,
    VC_CONF_DATA = 2
}VC_CONF_TYPE;

typedef NS_ENUM(NSUInteger, ROUTE_TYPE) {
    ROUTE_EARPIECE_TYPE = 0,
    ROUTE_LOUDSPEAKER_TYPE = 1
};

typedef enum
{
    VC_CONF_SITE_CALL_MODE_NORMAL = 0,         /**< [en]Indicates normal mode  */
    VC_CONF_SITE_CALL_MODE_REPORT = 1,         /**< [en]Indicates report mode  */
    VC_CONF_SITE_CALL_MODE_UNKNOW
} VC_CONF_SITE_CALL_MODE;

//point at remote video show mode
typedef NS_ENUM(NSUInteger, VIDEO_S_MODE)
{
    VIDEO_S_FULL_MODE = 0,//Video is full of windows
    VIDEO_S_STRETCH_MODE = 1,//According to the proportion of video display, the empty part of the black fill
    VIDEO_S_CLIP_MODE = 2//Clipping by window size
};

//VC_VIDEO_OPERATION
typedef enum
{
    OPEN = 0x01,             //open camera
    CLOSE = 0x02,            //close camera
    START = 0x04,           //start video
    OPEN_AND_START = 0x05,   //open camera and start video
    STOP = 0x08             //stop video
}VC_VIDEO_OPERATION;

//VC_VIDEO_OPERATION_MODULE
typedef enum
{
    REMOTE = 0x01,                  //operator remote view
    LOCAL = 0x02,                   //operator local view
    LOCAL_AND_REMOTE = 0x03,        //operator remote and local view
    CAPTURE = 0x04,                 //operator camera
    ENCODER = 0x08,                 //encode
    DECODER = 0x10,                 //decode
    RESTARTCAPTUREANDENCODER = 0x0C //restart camera and encode
}VC_VIDEO_OPERATION_MODULE;

enum
{
    VC_CONF_ROLE_HOST          = 0x0001,                  /**< [en]Indicates the host */
    VC_CONF_ROLE_PRESENTER     = 0x0002,                  /**< [en]Indicates the presenter*/
    VC_CONF_ROLE_GENERAL       = 0x0008,                  /**< [en]Indicates the general participant */
};
typedef void (^AuthoriseResultBlock) (int errCode ,LOGIN_EVENT eType); // uportal authorise block
typedef void (^ChangePwdResultBlock) (int errCode); // change password block


extern NSString *CONF_PASSCODE;//default conf passcode

@interface CommonDefine : NSObject

@end
