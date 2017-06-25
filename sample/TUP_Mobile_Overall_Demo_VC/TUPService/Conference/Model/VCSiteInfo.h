//
//  VCAttendeeData.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/3/28.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCAttendee.h"
#import "VCDConfRecord.h"

@interface VCSiteInfo : NSObject

@property(nonatomic,strong)VCAttendee *attendee;
@property(nonatomic,copy)NSString *attendeeName;
@property(nonatomic,copy)NSString *attendeeNumber;

@property(nonatomic,copy)NSString *unJoinReason;/**< [en]Indicates not join conference reason id.  */
@property(nonatomic,copy)NSString *autoViewSeq; /**< [en]Indicates auto view sequence. */
@property(nonatomic,copy)NSString *autoBroadSeq; /**< [en]Indicates auto broad sequence.  */

@property(nonatomic,copy)NSString *autoView; /**< [en]Indicates whether choose to auto view, 1 means yes, 0 means no.  */
@property(nonatomic,copy)NSString *autoBroad;/**< [en]Indicates whether choose to auto broad, 1 means yes, 0 means no.  */
@property(nonatomic,copy)NSString *siteNum;/**< [en]Indicates site number.  */
@property(nonatomic,copy)NSString *isUsed; /**< [en]Indicates whether is used, 1 means yes, 0 means no.  */
@property(nonatomic,copy)NSString *joinConf;/**< [en]Indicates join conference.  */

@property(nonatomic,copy)NSString *isPSTN;/**< [en]Indicates whether is PSTN, 1 means yes, 0 means no.  */
@property(nonatomic,copy)NSString *getName;/**< [en]Indicates whether get site name, 1 means yes, 0 means no.  */
@property(nonatomic,copy)NSString *getNumber; /**< [en]Indicates whether get site number, 1 means yes, 0 means no.  */
@property(nonatomic,copy)NSString *mute;/**< [en]Indicates whether is mute, 1 means yes, 0 means no.  */
@property(nonatomic,copy)NSString *silent; /**< [en]Indicates whether is silent, 1 means yes, 0 means no. */
@property(nonatomic,copy)NSString *reqTalk; /**< [en]Indicates whether have requested to talk, 1 means yes, 0 means no.  */
@property(nonatomic,copy)NSString *TPMain; /**< [en]Indicates whether is telepresence main screen, 1 means yes, 0 means no.  */
@property(nonatomic,copy)NSString *screenNum;                                  /**< [en]Indicates CT&TP screen number.  */
@property(nonatomic,copy)NSString *hasRefresh;                                 /**< [en]Indicates whether list has been refreshed, 1 means yes, 0 means no.  */
@property(nonatomic,copy)NSString *isChair;                                      /**< [en]Indicates whether is chairman site, 1 means yes, 0 means no.  */
@property(nonatomic,copy)NSString *localMute;

@property(nonatomic,strong)VCDConfRecord *dataConfRecord;

-(id)copyFromData:(void *)data;
@end
