//
//  WLSocialShareUIConfig.h
//  GeneralHospital
//
//  Created by 杭州卓健_黄 on 2016/12/16.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WLSocialCore.h"

@class WLSocialSharePageGroupViewConfig;
@class WLSocialShareContainerConfig;
@class WLSocialShareTitleViewConfig;
@class WLSocialSharePageScrollViewConfig;
@class WLSocialPlatformItemViewConfig;
@class WLSocialSharePageControlConfig;
@class WLSocialShareCancelControlConfig;

typedef void(^WLSocialSharePlatformSelectionBlock)(WLSocialPlatformType platformType,NSDictionary *userInfo);

typedef NS_ENUM(NSUInteger, WLSocialSharePageGroupViewPositionType){
    WLSocialSharePageGroupViewPositionType_Bottom,//显示在底部
    WLSocialSharePageGroupViewPositionType_Middle,//显示在中间
};

typedef NS_ENUM(NSUInteger, WLSocialPlatformItemViewBackgroudType){
    WLSocialPlatformItemViewBackgroudType_None,//有图片，没有圆背景，
    WLSocialPlatformItemViewBackgroudType_IconAndBGRadius,//有图片，圆背景，
    WLSocialPlatformItemViewBackgroudType_IconAndBGRoundAndSuperRadius,//有图片，圆角背景，
};

@interface WLSocialShareUIConfig : NSObject

+ (WLSocialShareUIConfig *)shareInstance;

@property (nonatomic, readwrite, strong) WLSocialSharePageGroupViewConfig *sharePageGroupViewConfig;
@property (nonatomic, readwrite, strong) WLSocialShareContainerConfig *shareContainerConfig;
@property (nonatomic, readwrite, strong) WLSocialShareTitleViewConfig *shareTitleViewConfig;
@property (nonatomic ,readwrite, strong) WLSocialSharePageScrollViewConfig *sharePageScrollViewConfig;
@property (nonatomic, readwrite, strong) WLSocialPlatformItemViewConfig *sharePlatformItemViewConfig;
@property (nonatomic, readwrite, strong) WLSocialSharePageControlConfig *sharePageControlConfig;
@property (nonatomic, readwrite, strong) WLSocialShareCancelControlConfig *shareCancelControlConfig;

@end

// 遮罩
@interface WLSocialSharePageGroupViewConfig : NSObject

@property (nonatomic,readwrite,strong) UIColor *sharePageGroupViewBackgroundColor;//背景颜色

@property (nonatomic,readwrite,strong) UIColor *sharePageGroupViewMaskColor;//分享菜单整个背景
@property (nonatomic,readwrite,assign) CGFloat sharePageGroupViewMaskViewAlpha;//分享菜单整个背景的Alpha

@property (nonatomic, readwrite, assign) WLSocialSharePageGroupViewPositionType   sharePageGroupViewPostionType;//分享面板类的位置@see WLSocialSharePageGroupViewPositionType

@end

/**
 * ShareContainer的配置类
 */
@interface WLSocialShareContainerConfig : NSObject

@property (nonatomic, readwrite, assign) CGFloat shareContainerMarginTop;//相对父view的上边距
@property (nonatomic, readwrite,assign) CGFloat shareContainerMarginBottom;//相对父view的下边距
@property (nonatomic, readwrite, assign) CGFloat shareContainerMarginLeft;//相对父view的左边距
@property (nonatomic, readwrite, assign) CGFloat shareContainerMarginRight;//相对父view的右边距
@property (nonatomic, readwrite, assign) CGFloat shareContainerMarginLeftForMid;//相对父view的左边距如果sharePageGroupViewPostionType为WLSocialSharePageGroupViewPositionType_Middle的时候
@property (nonatomic, readwrite, assign) CGFloat shareContainerMarginRightForMid;//相对父view的右边距相对父view的左边距如果sharePageGroupViewPostionType为WLSocialSharePageGroupViewPositionType_Middle的时候

@property (nonatomic, readwrite, assign) CGFloat shareContainerCornerRadius;//圆角
@property (nonatomic, readwrite, strong) UIColor *shareContainerBackgroundColor;//背景色

//设置ShareContainer左右渐变显示的参数
@property (nonatomic, readwrite, assign) BOOL isShareContainerHaveGradient;//是否开启渐变当滑动到边缘的时候
@property (nonatomic, readwrite, strong) UIColor *shareContainerGradientStartColor;//渐变开始的颜色
@property (nonatomic, readwrite, strong) UIColor *shareContainerGradientEndColor;//渐变结束的颜色
@property (nonatomic, readwrite,assign) CGFloat shareContainerGradientLeftWidth;//左边的渐变宽度
@property (nonatomic, readwrite, assign) CGFloat shareContainerGradientRightWidth;//右边的渐变宽度

@end

/**
 *  ShareTitleView的配置类
 */
@interface WLSocialShareTitleViewConfig : NSObject

@property (nonatomic, readwrite, assign) BOOL isShow;//是否显示

@property (nonatomic, readwrite, strong) NSString *shareTitleViewTitleString;//标题的文字
@property (nonatomic, readwrite, strong) UIFont *shareTitleViewFont;//字体
@property (nonatomic, readwrite, strong) UIColor *shareTitleViewTitleColor;//文字颜色
@property (nonatomic, readwrite, strong) UIColor *shareTitleViewBackgroundColor;//背景颜色

@property (nonatomic, readwrite, assign) CGFloat shareTitleViewPaddingTop;//title的内边距top
@property (nonatomic, readwrite, assign) CGFloat shareTitleViewPaddingBottom;//title的内边距Bottom



@end

/**
 *  ShareScrollView的配置类
 */
@interface WLSocialSharePageScrollViewConfig : NSObject

@property (nonatomic, readwrite, strong) UIColor *shareScrollViewBackgroundColor;//shareScrollView背景色

@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageRowSpace;//每页的行间距
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageColumnSpace;//每页的列间距(在设置了shareScrollViewPageMaxItemWidth后，列间距会变化一般设置只是估算每行的容纳的item的个数)
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageMarginLeft; //每页的左边距
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageMarginRight; //每页的右边距
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageMarginTop; //每页的上边距
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageMarginBottom; //每页的下边距

@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPadingLeft; //ScrollView的Left外边距(相对与父窗口)
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPadingRight; //ScrollView的Right外边距(相对与父窗口)
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPadingTop; //ScrollView的Top边距(相对与父窗口)
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPadingBottom; //ScrollView的Bottom边距(相对与父窗口)

@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageMaxItemWidth; //每页Items的最大宽度
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageMaxItemHeight; //每页Items的最大高度

@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageMaxItemBGWidth; //每页Item内部icon下背景的宽度与shareScrollViewPageMaxItemWidth相同
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageMaxItemBGHeight; //每页Item内部icon下背景的高度与shareScrollViewPageMaxItemBGWidth相同
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageMaxItemIconWidth; //每页Item内部icon下宽度
@property (nonatomic,readwrite, assign) CGFloat shareScrollViewPageMaxItemIconHeight; //每页Item内部icon下高度
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageMaxItemSpaceBetweenIconAndName; //每页Item背景和icon的上下间距
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageMaxItemNameHeight; //每页Item的name的高度
@property (nonatomic, readwrite, assign) CGFloat shareScrollViewPageMaxItemNameWidth; //每页Item的name的宽度，和shareScrollViewPageMaxItemBGWidth一样

@property (nonatomic, readwrite, strong) UIColor *shareScrollViewPageBGColor; //每页的背景颜色

@property (nonatomic, readwrite, assign) WLSocialPlatformItemViewBackgroudType shareScrollViewPageItemStyleType;//@see WLSocialPlatformItemViewBackgroudType

@property (nonatomic, readwrite, assign) NSInteger shareScrollViewPageMaxRowCountForPortraitAndBottom; //每页显示最大的行(在底部显示手机处于肖像模式)
@property (nonatomic, readwrite, assign) NSInteger shareScrollViewPageMaxColumnCountForPortraitAndBottom; //每页显示最大的列(在底部显示手机处于肖像模式)

@property (nonatomic, readwrite, assign) NSInteger shareScrollViewPageMaxRowCountForPortraitAndMid; //每页显示最大的行(在中间显示手机处于肖像模式)
@property (nonatomic, readwrite, assign) NSInteger shareScrollViewPageMaxColumnCountForPortraitAndMid; //每页显示最大的列(在中间显示手机)


@end


/**
 *  每个page内Item的配置类
 */
@interface WLSocialPlatformItemViewConfig : NSObject

@property (nonatomic, readwrite, strong) UIColor *sharePlatformItemViewBGRadiusColor; //有圆角背景时的颜色
@property (nonatomic, readwrite, strong) UIColor *sharePlatformItemViewBGRadiusColorPressed;//有圆角背景时的按下颜色

@property (nonatomic, readwrite, assign) CGFloat sharePlatformItemViewBGRadius;//圆角

@property (nonatomic, readwrite, strong) UIColor *sharePlatformItemViewPlatformNameColor;//平台名字的颜色

@end

/**
 *  SharePageControl的配置类
 */
@interface WLSocialSharePageControlConfig : NSObject

@property (nonatomic, readwrite, assign) BOOL isShow;//是否显示

@property (nonatomic, readwrite, strong) UIColor *sharePageControlPageIndicatorTintColor;//指示器颜色
@property (nonatomic, readwrite, strong) UIColor *sharePageControlCurrentPageIndicatorTintColor;//当前的页的颜色
@property (nonatomic, readwrite, assign) BOOL sharePageControlHidesForSinglePage;//为一页是会隐藏
@property (nonatomic, readwrite, strong) UIColor *sharePageControlBackgroundColor;//背景色

@end

/**
 *  ShareCancelControl的配置类
 */
@interface WLSocialShareCancelControlConfig : NSObject

@property (nonatomic, readwrite, assign) BOOL isShow;//是否显示

@property (nonatomic, readwrite, strong) NSString *shareCancelControlText;//相对父view的左边距
@property (nonatomic, readwrite, strong) UIColor *shareCancelControlTextColor;//文字颜色
@property (nonatomic, readwrite, strong) UIFont *shareCancelControlTextFont;//文字字体
@property (nonatomic, readwrite, strong) UIColor *shareCancelControlBackgroundColor;//背景颜色;
@property (nonatomic, readwrite, strong) UIColor *shareCancelControlBackgroundColorPressed;//点击时的按下颜色

@end
