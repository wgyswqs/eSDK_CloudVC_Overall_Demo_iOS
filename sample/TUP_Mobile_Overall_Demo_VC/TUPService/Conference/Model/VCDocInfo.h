//
//  VCDocInfo.h
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/5/6.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCDocInfo : NSObject

@property(nonatomic)       NSString *      docId;                 /**< [en]Indicates the current document ID on the server.  */
@property(nonatomic,copy)    NSString *         pageId;                /**< [en]Indicates the current page ID on the server.  */
@property(nonatomic,copy)    NSString *           width;                 /**< [en]Indicates the current page width.  */
@property(nonatomic,copy)     NSString *           height;                /**< [en]Indicates the current page height.  */
@property(nonatomic,copy)     NSString *           orgX;                  /**< [en]Indicates the start X of the page on the server.  */
@property(nonatomic,copy)        NSString *        orgY;                  /**< [en]Indicates the start Y of the page on the server.  */
@property(nonatomic,copy)NSString *       rfType;                /**< [en]Indicates the page rotation type on the server. */
@property(nonatomic,copy)      NSString *           zoomPercent;           /**< [en]Indicates the scale of the page. */
@property(nonatomic,copy)     NSString *         bCopied;               /**< [en]Indicates whether the page is cpoied.  */
@property(nonatomic,copy)   NSString *          bEPenDrawn;            /**< [en]Indicates whether the electronic stroke. */

-(id)copyFromData:(void *)data;
@end
