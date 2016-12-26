//
//  WLSocialUIManager.h
//  GeneralHospital
//
//  Created by 杭州卓健_黄 on 2016/12/16.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WLSocialShareUIConfig.h"

@interface WLSocialUIManager : NSObject

+ (instancetype)manager;

+ (void)setPlatforms:(NSArray *)platforms;

+ (void)showShareMenuViewInWindowWithPlatformSelectionBlock:(WLSocialSharePlatformSelectionBlock)sharePlatformSelectionBlock;

@end
