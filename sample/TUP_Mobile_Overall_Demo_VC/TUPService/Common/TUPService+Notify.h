//
//  TUPService+Notify.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/2.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "TUPService.h"
#import "login_interface.h"
#import "call_interface.h"
#import "tup_conf_baseapi.h"
#import "tup_conf_basedef.h"


@interface TUPService (Notify)
TUP_VOID onTUPLoginNotify(TUP_UINT32 msgid, TUP_UINT32 param1, TUP_UINT32 param2, TUP_VOID *data);
TUP_VOID onTUPCallNotify(TUP_UINT32 msgid, TUP_UINT32 param1, TUP_UINT32 param2, TUP_VOID *data);
TUP_VOID onTUPConferenceNotify(TUP_UINT32 msgid, TUP_UINT32 param1, TUP_UINT32 param2, TUP_VOID *data);
TUP_VOID onTUPDataConferenceNotify(CONF_HANDLE confHandle, TUP_INT nType, TUP_UINT nValue1, TUP_ULONG nValue2, TUP_VOID* pVoid, TUP_INT nSize);
TUP_VOID onTUPComponentNotify(CONF_HANDLE confHandle, TUP_INT nType, TUP_UINT nValue1, TUP_ULONG nValue2, TUP_VOID* pVoid, TUP_INT nSize);

TUP_INT32 onTUPDataCaptureFunc(void *data, TUP_ULONG width, TUP_ULONG height);

@end
