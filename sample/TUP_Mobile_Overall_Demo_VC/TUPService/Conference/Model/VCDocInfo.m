//
//  VCDocInfo.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/5/6.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "VCDocInfo.h"
#import "tup_conf_basedef.h"

@implementation VCDocInfo
-(id)init
{
    self = [super init];
    if (self) {

        self.docId =@"";

        self.pageId = @"";

        self.width = @"";
        self.height = @"";
        self.orgX = @"";
        self.orgY = @"";
        self.rfType = @"";
        self.zoomPercent = @"";
        self.bCopied = @"";
        self.bEPenDrawn = @"";
       
    }
    
    return self;
}

-(id)copyWithZone:(NSZone *)zone
{
    VCDocInfo *newDoc = [[[self class] allocWithZone:zone] init];
    newDoc.docId = self.docId;
    newDoc.pageId = self.pageId;
    newDoc.width = self.width;
    newDoc.height = self.height;
    newDoc.orgY = self.orgY;
    newDoc.orgX = self.orgX;
    newDoc.rfType = self.rfType;
    newDoc.zoomPercent = self.zoomPercent;
    newDoc.bCopied = self.bCopied;
    newDoc.bEPenDrawn = self.bEPenDrawn;
    
    return newDoc;
}

-(id)copyFromData:(void *)data
{
    DsSyncInfo *info = (DsSyncInfo *)data;
    
    self.docId = [NSString stringWithFormat:@"%d",info->docId];
    self.pageId= [NSString stringWithFormat:@"%d",info->pageId];
    
    self.width = [NSString stringWithFormat:@"%d",info->width];
    self.height = [NSString stringWithFormat:@"%d",info->height];
    self.orgX = [NSString stringWithFormat:@"%d",info->orgX];
    self.orgY =[NSString stringWithFormat:@"%d",info->orgY];
    self.rfType = [NSString stringWithFormat:@"%d",info->rfType];
    self.zoomPercent = [NSString stringWithFormat:@"%f",info->zoomPercent];
    self.bCopied = [NSString stringWithFormat:@"%d",info->bCopied];
    self.bEPenDrawn = [NSString stringWithFormat:@"%d",info->bEPenDrawn];
    
    return self;
}

@end
