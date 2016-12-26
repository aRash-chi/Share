//
//  WLSocialShareUIConfig.m
//  GeneralHospital
//
//  Created by 杭州卓健_黄 on 2016/12/16.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import "WLSocialShareUIConfig.h"

@interface WLSocialShareUIConfig ()

@end

@implementation WLSocialShareUIConfig

+ (WLSocialShareUIConfig *)shareInstance;
{
    static WLSocialShareUIConfig *_config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _config = [[self alloc] init];
        _config.sharePageGroupViewConfig = [[WLSocialSharePageGroupViewConfig alloc] init];
        _config.shareContainerConfig = [[WLSocialShareContainerConfig alloc] init];
        _config.shareTitleViewConfig = [[WLSocialShareTitleViewConfig alloc] init];
        _config.sharePageScrollViewConfig = [[WLSocialSharePageScrollViewConfig alloc] init];
        _config.sharePlatformItemViewConfig = [[WLSocialPlatformItemViewConfig alloc] init];
        _config.sharePageControlConfig = [[WLSocialSharePageControlConfig alloc] init];
        _config.shareCancelControlConfig = [[WLSocialShareCancelControlConfig alloc] init];
        
    });
    
    return _config;
}

- (WLSocialSharePageGroupViewConfig *)sharePageGroupViewConfig
{
    if (!_sharePageGroupViewConfig) {
        _sharePageGroupViewConfig = [[WLSocialSharePageGroupViewConfig alloc] init];
    }
    
    return _sharePageGroupViewConfig;
}

- (WLSocialSharePageScrollViewConfig *)sharePageScrollViewConfig
{
    if (!_sharePageScrollViewConfig) {
        _sharePageScrollViewConfig = [[WLSocialSharePageScrollViewConfig alloc] init];
    }
    
    return _sharePageScrollViewConfig;
}

- (WLSocialPlatformItemViewConfig *)sharePlatformItemViewConfig
{
    if (!_sharePlatformItemViewConfig) {
        _sharePlatformItemViewConfig = [[WLSocialPlatformItemViewConfig alloc] init];
    }
    
    return _sharePlatformItemViewConfig;
}

@end

@interface WLSocialSharePageGroupViewConfig ()

@end

@implementation WLSocialSharePageGroupViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sharePageGroupViewMaskViewAlpha = 0.3;
        self.sharePageGroupViewPostionType = WLSocialSharePageGroupViewPositionType_Bottom;
    }
    
    return self;
}

- (UIColor *)sharePageGroupViewBackgroundColor
{
    if (!_sharePageGroupViewBackgroundColor) {
        _sharePageGroupViewBackgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }
    
    return _sharePageGroupViewBackgroundColor;
}

- (UIColor *)sharePageGroupViewMaskColor
{
    if (!_sharePageGroupViewMaskColor) {
        _sharePageGroupViewMaskColor = [UIColor colorWithWhite:0 alpha:1];
    }
    
    return _sharePageGroupViewMaskColor;
}

@end

@interface WLSocialShareContainerConfig ()

@end

@implementation WLSocialShareContainerConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shareContainerMarginTop = 0;
        self.shareContainerMarginBottom = 0;
        self.shareContainerMarginLeft = 0;
        self.shareContainerMarginRight = 0;
        self.shareContainerMarginLeftForMid = 37.5;
        self.shareContainerMarginRightForMid = 37.5;
        self.shareContainerCornerRadius = 0;
        self.isShareContainerHaveGradient = YES;
        self.shareContainerGradientLeftWidth = 20;
        self.shareContainerGradientRightWidth = 20;
    }
    
    return self;
}

- (UIColor *)shareContainerBackgroundColor
{
    if (!_shareContainerBackgroundColor) {
        _shareContainerBackgroundColor = [UIColor colorWithRed:0.913725 green:0.937255 blue:0.94902 alpha:1];
    }
    
    return _shareContainerBackgroundColor;
}

- (UIColor *)shareContainerGradientStartColor
{
    if (!_shareContainerGradientStartColor) {
        _shareContainerGradientStartColor = [UIColor colorWithRed:0.913725 green:0.937255 blue:0.94902 alpha:0];
    }
    
    return _shareContainerGradientStartColor;
}

- (UIColor *)shareContainerGradientEndColor
{
    if (!_shareContainerGradientEndColor) {
        _shareContainerGradientEndColor = [UIColor colorWithRed:0.913725 green:0.937255 blue:0.94902 alpha:1];
    }
    
    return _shareContainerGradientEndColor;
}

@end

@interface WLSocialShareTitleViewConfig ()

@end

@implementation WLSocialShareTitleViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isShow = YES;
        self.shareTitleViewTitleString = @"请选择分享平台";
        self.shareTitleViewFont = [UIFont systemFontOfSize:17.0];
        self.shareTitleViewPaddingTop = 19;
        self.shareTitleViewPaddingBottom = 0;
    }
    
    return self;
}

- (UIColor *)shareTitleViewTitleColor
{
    if (!_shareTitleViewTitleColor) {
        _shareTitleViewTitleColor = [UIColor colorWithRed:0.341176 green:0.352941 blue:0.360784 alpha:1];
    }
    
    return _shareTitleViewTitleColor;
}

- (UIColor *)shareTitleViewBackgroundColor
{
    if (!_shareTitleViewBackgroundColor) {
        _shareTitleViewBackgroundColor = [UIColor colorWithRed:0.913725 green:0.937255 blue:0.94902 alpha:1];
    }
    
    return _shareTitleViewBackgroundColor;
}

@end

/**
 *  ShareScrollView的配置类
 */
@interface WLSocialSharePageScrollViewConfig ()

@end

@implementation WLSocialSharePageScrollViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.shareScrollViewPageRowSpace = 15;
        self.shareScrollViewPageColumnSpace = 10;
        self.shareScrollViewPageMarginLeft = 5;
        self.shareScrollViewPageMarginRight = 5;
        self.shareScrollViewPageMarginTop = 15;
        self.shareScrollViewPageMarginBottom = 10;
        self.shareScrollViewPadingLeft = 0;
        self.shareScrollViewPadingRight = 0;
        self.shareScrollViewPadingTop = 0;
        self.shareScrollViewPadingBottom = 0;
        self.shareScrollViewPageMaxItemWidth = 50;
        self.shareScrollViewPageMaxItemHeight = 70;
        self.shareScrollViewPageMaxItemBGWidth = 50;
        self.shareScrollViewPageMaxItemBGHeight = 50;
        self.shareScrollViewPageMaxItemIconWidth = 40;
        self.shareScrollViewPageMaxItemIconHeight = 40;
        self.shareScrollViewPageMaxItemSpaceBetweenIconAndName = 4;
        self.shareScrollViewPageMaxItemNameHeight = 16;
        self.shareScrollViewPageMaxItemNameWidth = 50;
        self.shareScrollViewPageItemStyleType = WLSocialPlatformItemViewBackgroudType_None;
        self.shareScrollViewPageMaxRowCountForPortraitAndBottom = 2;
        self.shareScrollViewPageMaxColumnCountForPortraitAndBottom = 4;
        self.shareScrollViewPageMaxRowCountForPortraitAndMid = 2;
        self.shareScrollViewPageMaxColumnCountForPortraitAndMid = 3;
    }
    
    return self;
}

- (UIColor *)shareScrollViewBackgroundColor
{
    if (!_shareScrollViewBackgroundColor) {
        _shareScrollViewBackgroundColor = [UIColor colorWithRed:0.913725 green:0.937255 blue:0.94902 alpha:1];
    }
    
    return _shareScrollViewBackgroundColor;
}

- (UIColor *)shareScrollViewPageBGColor
{
    if (!_shareScrollViewPageBGColor) {
        _shareScrollViewPageBGColor = [UIColor colorWithRed:0.913725 green:0.937255 blue:0.94902 alpha:1];
    }
    
    return _shareScrollViewPageBGColor;
}

@end

@interface WLSocialPlatformItemViewConfig ()

@end

@implementation WLSocialPlatformItemViewConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sharePlatformItemViewBGRadius = 5.0;
    }
    
    return self;
}

- (UIColor *)sharePlatformItemViewBGRadiusColor
{
    if (!_sharePlatformItemViewBGRadiusColor) {
        _sharePlatformItemViewBGRadiusColor = [UIColor colorWithWhite:1 alpha:1];
    }
    
    return _sharePlatformItemViewBGRadiusColor;
}

- (UIColor *)sharePlatformItemViewBGRadiusColorPressed
{
    if (!_sharePlatformItemViewBGRadiusColorPressed) {
        _sharePlatformItemViewBGRadiusColorPressed = [UIColor colorWithWhite:0.666667 alpha:1];
    }
    
    return _sharePlatformItemViewBGRadiusColorPressed;
}

- (UIColor *)sharePlatformItemViewPlatformNameColor
{
    if (!_sharePlatformItemViewPlatformNameColor) {
        _sharePlatformItemViewPlatformNameColor = [UIColor colorWithRed:0.341176 green:0.352941 blue:0.360784 alpha:1];
    }
    
    return _sharePlatformItemViewPlatformNameColor;
}

@end

@interface WLSocialSharePageControlConfig ()

@end

@implementation WLSocialSharePageControlConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isShow = YES;
        self.sharePageControlHidesForSinglePage = YES;
    }
    
    return self;
}

- (UIColor *)sharePageControlCurrentPageIndicatorTintColor
{
    if (!_sharePageControlCurrentPageIndicatorTintColor) {
        _sharePageControlCurrentPageIndicatorTintColor = [UIColor colorWithRed:0 green:0.52549 blue:0.862745 alpha:1];
    }
    
    return _sharePageControlCurrentPageIndicatorTintColor;
}

- (UIColor *)sharePageControlPageIndicatorTintColor
{
    if (!_sharePageControlPageIndicatorTintColor) {
        _sharePageControlPageIndicatorTintColor = [UIColor colorWithRed:0.760784 green:0.788235 blue:0.8 alpha:1];
    }
    
    return _sharePageControlPageIndicatorTintColor;
}

- (UIColor *)sharePageControlBackgroundColor
{
    if (!_sharePageControlBackgroundColor) {
        _sharePageControlBackgroundColor = [UIColor colorWithRed:0.913725 green:0.937255 blue:0.94902 alpha:1];
    }
    
    return _sharePageControlBackgroundColor;
}

@end

@interface WLSocialShareCancelControlConfig ()

@end

@implementation WLSocialShareCancelControlConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isShow = YES;
        self.shareCancelControlText = @"取消分享";
        self.shareCancelControlTextFont = [UIFont systemFontOfSize:15.0];
    }
    
    return self;
}

- (UIColor *)shareCancelControlTextColor
{
    if (!_shareCancelControlTextColor) {
        _shareCancelControlTextColor = [UIColor colorWithRed:0.341176 green:0.352941 blue:0.360784 alpha:1];
    }
    
    return _shareCancelControlTextColor;
}

- (UIColor *)shareCancelControlBackgroundColor
{
    if (!_shareCancelControlBackgroundColor) {
        _shareCancelControlBackgroundColor = [UIColor colorWithRed:0.964706 green:0.980392 blue:0.988235 alpha:1];
    }
    
    return _shareCancelControlBackgroundColor;
}

- (UIColor *)shareCancelControlBackgroundColorPressed
{
    if (!_shareCancelControlBackgroundColorPressed) {
        _shareCancelControlBackgroundColorPressed = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.3];
    }
    
    return _shareCancelControlBackgroundColorPressed;
}


@end
