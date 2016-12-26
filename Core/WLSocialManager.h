//
//  WLSocialManager.h
//  GeneralHospital
//
//  Created by 杭州卓健_黄 on 2016/12/16.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLSocialPlatformConfig.h"

@class WLSocialMessageObject;

@interface WLSocialManager : NSObject

+ (instancetype)socialManager;

- (void)shareToPlatform:(WLSocialPlatformType)platformType
          messageObject:(WLSocialMessageObject *)messageObject
  currentViewController:(id)currentViewController
             completion:(WLSocialRequestCompletionHandler)completion;


/**
 *  获得从sso或者web端回调到本app的回调
 *
 *  @param url 第三方sdk的打开本app的回调的url
 *
 *  @return 是否处理  YES代表处理成功，NO代表不处理
 */
- (BOOL)handleOpenURL:(NSURL *)url;

@end
