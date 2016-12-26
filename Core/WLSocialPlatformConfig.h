//
//  WLSocialPlatformConfig.h
//  GeneralHospital
//
//  Created by 杭州卓健_黄 on 2016/12/16.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^WLSocialRequestCompletionHandler)(id result,NSError *error);

//平台的类型--start
typedef NS_ENUM(NSInteger,WLSocialPlatformType)
{
    WLSocialPlatformType_UnKnown            = -2,
    WLSocialPlatformType_Sina               = 0, //新浪
    WLSocialPlatformType_WechatSession      = 1, //微信聊天
    WLSocialPlatformType_WechatTimeLine     = 2,//微信朋友圈
    WLSocialPlatformType_WechatFavorite     = 3,//微信收藏
    WLSocialPlatformType_QQ                 = 4,//QQ聊天页面
    WLSocialPlatformType_Qzone              = 5,//qq空间
};

