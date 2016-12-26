//
//  WLSocialUIManager.m
//  GeneralHospital
//
//  Created by 杭州卓健_黄 on 2016/12/16.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import "WLSocialUIManager.h"
#import "WLSocialPlatformConfig.h"

#define UIColorFromRGBA(rgbValue,a) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)a)])
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CIWC(color) \
({\
CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);\
UIGraphicsBeginImageContext(rect.size);\
CGContextRef context = UIGraphicsGetCurrentContext();\
CGContextSetFillColorWithColor(context, [color CGColor]);\
CGContextFillRect(context, rect);\
UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();\
UIGraphicsEndImageContext();\
theImage;\
})\

@interface WLView : UIView

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) CGPoint endPoint;

@property (nonatomic, strong) NSArray *colors;

@property (nonatomic, strong) NSArray<NSNumber *> *locations;

@end

@implementation WLView

- (instancetype)initWithColors:(NSArray *)colors
                     locations:(NSArray<NSNumber *> *)locations
                    startPoint:(CGPoint)startPoint
                      endPoint:(CGPoint)endPoint
{
    self = [super init];
    if (self) {
        self.colors = colors;
        self.locations = locations;
        self.startPoint = startPoint;
        self.endPoint = endPoint;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSArray *colors = self.colors;
    CAGradientLayer *leftGradientLayer = [CAGradientLayer layer];
    leftGradientLayer.colors = colors;
    leftGradientLayer.frame = self.bounds;
    leftGradientLayer.position = CGPointMake(self.bounds.size.width / 2.0, self.bounds.size.height / 2.0);
    leftGradientLayer.locations = self.locations;
    leftGradientLayer.startPoint = self.startPoint;
    leftGradientLayer.endPoint = self.endPoint;
    [self.layer addSublayer:leftGradientLayer];
}

@end

@interface WLLabel : UILabel

@property (assign, nonatomic) UIEdgeInsets edgeInsets;

@end

@implementation WLLabel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _edgeInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _edgeInsets)];
}

@end

@interface WLSocialUIManager ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *platforms;

@property (nonatomic, copy) WLSocialSharePlatformSelectionBlock selectionBlock;

@property (nonatomic, strong) UIView *firstBgView;

@property (nonatomic, strong) UIView *secondBgView;

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation WLSocialUIManager

+ (instancetype)manager
{
    static WLSocialUIManager *_socialUIManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _socialUIManager = [[self alloc] init];
    });
    
    return _socialUIManager;
}

+ (void)setPlatforms:(NSArray *)platforms
{
    // ***传入的平台必须是合法并且是core模块已经检测到的已经存在的平台*** //
    [WLSocialUIManager manager].platforms = platforms;
    
}

+ (void)showShareMenuViewInWindowWithPlatformSelectionBlock:(WLSocialSharePlatformSelectionBlock)sharePlatformSelectionBlock
{
    [WLSocialUIManager manager].selectionBlock = sharePlatformSelectionBlock;
    
    WLSocialShareUIConfig *config = [WLSocialShareUIConfig shareInstance];
    [WLSocialUIManager initBgViewInWindowWithConfig:config];
}

+ (void)initBgViewInWindowWithConfig:(WLSocialShareUIConfig *)config
{
    CGFloat contentBgViewWidth = 0;
    
    UIWindow *keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
    [WLSocialUIManager manager].firstBgView = [[UIView alloc] init];
    [WLSocialUIManager manager].firstBgView.frame = keyWindow.frame;
    [WLSocialUIManager manager].firstBgView.backgroundColor = config.sharePageGroupViewConfig.sharePageGroupViewMaskColor;
    [WLSocialUIManager manager].firstBgView.alpha = config.sharePageGroupViewConfig.sharePageGroupViewMaskViewAlpha;
    [keyWindow addSubview:[WLSocialUIManager manager].firstBgView];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:[WLSocialUIManager manager] action:@selector(tapAct)];
    [[WLSocialUIManager manager].firstBgView addGestureRecognizer:tapGestureRecognizer];
    
    [WLSocialUIManager manager].secondBgView = [[UIView alloc] init];
    [keyWindow addSubview:[WLSocialUIManager manager].secondBgView];
    [WLSocialUIManager manager].secondBgView.backgroundColor = config.sharePageGroupViewConfig.sharePageGroupViewBackgroundColor;
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:[WLSocialUIManager manager].secondBgView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:[WLSocialUIManager manager].firstBgView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:[WLSocialUIManager manager].secondBgView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:[WLSocialUIManager manager].firstBgView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0];
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:[WLSocialUIManager manager].secondBgView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:[WLSocialUIManager manager].secondBgView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:[WLSocialUIManager manager].firstBgView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    [NSLayoutConstraint activateConstraints:@[leftConstraint, rightConstraint, topConstraint, heightConstraint]];
    [WLSocialUIManager manager].secondBgView.translatesAutoresizingMaskIntoConstraints = NO;
    
    contentBgViewWidth = keyWindow.frame.size.width;
    
    WLSocialShareContainerConfig *containerConfig = [WLSocialShareUIConfig shareInstance].shareContainerConfig;
    UIView *thirdBgView = [[UIView alloc] init];
    [[WLSocialUIManager manager].secondBgView addSubview:thirdBgView];
    thirdBgView.backgroundColor = containerConfig.shareContainerBackgroundColor;
    thirdBgView.layer.masksToBounds = YES;
    thirdBgView.layer.cornerRadius = containerConfig.shareContainerCornerRadius;
    
    NSInteger row = 0;
    NSInteger pageCount = 0;
    NSInteger maxX = 0;
    NSInteger maxY = 0;
    NSArray *platforms = [WLSocialUIManager manager].platforms;
    WLSocialSharePageScrollViewConfig *sharePageScrollViewConfig = config.sharePageScrollViewConfig;
    
    switch (config.sharePageGroupViewConfig.sharePageGroupViewPostionType) {
        case WLSocialSharePageGroupViewPositionType_Bottom:
        {
            [WLSocialUIManager addConstraintsWithView:thirdBgView
                                            superView:[WLSocialUIManager manager].secondBgView
                                                 left:containerConfig.shareContainerMarginLeft
                                                right:containerConfig.shareContainerMarginRight
                                                  top:containerConfig.shareContainerMarginTop
                                               bottom:containerConfig.shareContainerMarginBottom];
            
            NSUInteger num = platforms.count / sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom;
            row =  num <= sharePageScrollViewConfig.shareScrollViewPageMaxRowCountForPortraitAndBottom ? num : sharePageScrollViewConfig.shareScrollViewPageMaxRowCountForPortraitAndBottom;
            maxX = sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndBottom;
            maxY = sharePageScrollViewConfig.shareScrollViewPageMaxRowCountForPortraitAndBottom;
            pageCount = (platforms.count / (maxX * maxY)) + 1;
            
            contentBgViewWidth = (contentBgViewWidth - containerConfig.shareContainerMarginLeft - containerConfig.shareContainerMarginRight);
        }
            break;
        case WLSocialSharePageGroupViewPositionType_Middle:
        {
            [WLSocialUIManager addConstraintsWithView:thirdBgView
                                            superView:[WLSocialUIManager manager].secondBgView
                                                 left:containerConfig.shareContainerMarginLeftForMid
                                                right:containerConfig.shareContainerMarginRightForMid
                                                  top:containerConfig.shareContainerMarginTop
                                               bottom:containerConfig.shareContainerMarginBottom];
            
            NSUInteger num = platforms.count / sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndMid;
            row =  num <= sharePageScrollViewConfig.shareScrollViewPageMaxRowCountForPortraitAndMid ? : sharePageScrollViewConfig.shareScrollViewPageMaxRowCountForPortraitAndMid;
            maxX = sharePageScrollViewConfig.shareScrollViewPageMaxColumnCountForPortraitAndMid;
            maxY = sharePageScrollViewConfig.shareScrollViewPageMaxRowCountForPortraitAndMid;
            pageCount = (platforms.count / (maxX * maxY)) + 1;
            
            
            contentBgViewWidth = (contentBgViewWidth - containerConfig.shareContainerMarginLeftForMid - containerConfig.shareContainerMarginRightForMid);
        }
            break;
            
        default:
            break;
    }
    
    CGFloat nowY = 0;
    WLSocialShareTitleViewConfig *titleViewConfig = config.shareTitleViewConfig;
    WLLabel *titleLabel = [[WLLabel alloc] init];
    [thirdBgView addSubview:titleLabel];
    [WLSocialUIManager addConstraintsWithView:titleLabel superView:thirdBgView left:0 right:0 top:nowY height:config.shareTitleViewConfig.isShow ? 38 : 0];
    titleLabel.text = titleViewConfig.shareTitleViewTitleString;
    titleLabel.font = titleViewConfig.shareTitleViewFont;
    titleLabel.textColor = titleViewConfig.shareTitleViewTitleColor;
    titleLabel.backgroundColor = titleViewConfig.shareTitleViewBackgroundColor;
    titleLabel.edgeInsets = UIEdgeInsetsMake(titleViewConfig.shareTitleViewPaddingTop, 0, titleViewConfig.shareTitleViewPaddingBottom, 0);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    nowY += (config.shareTitleViewConfig.isShow ? 38 : 0);
    
    WLSocialSharePageScrollViewConfig *scrollViewConfig = [WLSocialShareUIConfig shareInstance].sharePageScrollViewConfig;
    CGFloat bgScrollViewHeight = scrollViewConfig.shareScrollViewPageMaxItemHeight * row + scrollViewConfig.shareScrollViewPageRowSpace * (row - 1) + scrollViewConfig.shareScrollViewPageMarginTop + scrollViewConfig.shareScrollViewPageMarginBottom;
    
    UIScrollView *bgScrollView = [[UIScrollView alloc] init];
    [thirdBgView addSubview:bgScrollView];
    [WLSocialUIManager addConstraintsWithView:bgScrollView superView:thirdBgView left:scrollViewConfig.shareScrollViewPadingLeft right:scrollViewConfig.shareScrollViewPadingRight top:nowY + scrollViewConfig.shareScrollViewPadingTop height:bgScrollViewHeight];
    bgScrollView.backgroundColor = scrollViewConfig.shareScrollViewBackgroundColor;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    bgScrollView.pagingEnabled = YES;
    bgScrollView.bounces = NO;
    bgScrollView.delegate = [WLSocialUIManager manager];
    
    contentBgViewWidth = (contentBgViewWidth - scrollViewConfig.shareScrollViewPadingLeft - scrollViewConfig.shareScrollViewPadingRight);
    
    if (config.sharePageGroupViewConfig.sharePageGroupViewPostionType == WLSocialSharePageGroupViewPositionType_Middle) {
        bgScrollView.contentSize = CGSizeMake(([WLSocialUIManager manager].firstBgView.frame.size.width - (containerConfig.shareContainerMarginLeftForMid + containerConfig.shareContainerMarginRightForMid) -(scrollViewConfig.shareScrollViewPadingLeft + scrollViewConfig.shareScrollViewPadingRight)) * pageCount, 0);
    } else {
        bgScrollView.contentSize = CGSizeMake(([WLSocialUIManager manager].firstBgView.frame.size.width - (containerConfig.shareContainerMarginLeft + containerConfig.shareContainerMarginRight) -(scrollViewConfig.shareScrollViewPadingLeft + scrollViewConfig.shareScrollViewPadingRight)) * pageCount, 0);
    }
    
    [WLSocialUIManager manager].bgScrollView = bgScrollView;

    if (containerConfig.isShareContainerHaveGradient) {
        CGFloat gradientLeftWidth = containerConfig.shareContainerGradientLeftWidth;
        CGFloat gradientRightWidth = containerConfig.shareContainerGradientRightWidth;
        
        {
            CGColorRef startColor = containerConfig.shareContainerGradientStartColor.CGColor;
            CGColorRef endColor = containerConfig.shareContainerGradientEndColor.CGColor;
            NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
            WLView *leftGradientView = [[WLView alloc] initWithColors:colors locations:@[[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0.4], [NSNumber numberWithFloat:1]] startPoint:CGPointMake(1, 0) endPoint:CGPointMake(0, 0)];
            [thirdBgView addSubview:leftGradientView];
            [WLSocialUIManager addConstraintsWithView:leftGradientView superView:thirdBgView left:0  width:gradientLeftWidth top:nowY + scrollViewConfig.shareScrollViewPadingTop height:bgScrollViewHeight];
        }
        
        
        {
            CGColorRef startColor = containerConfig.shareContainerGradientStartColor.CGColor;
            CGColorRef endColor = containerConfig.shareContainerGradientEndColor.CGColor;
            NSArray *colors = [NSArray arrayWithObjects:(__bridge id)startColor, (__bridge id)endColor, nil];
            WLView *rightGradientView = [[WLView alloc] initWithColors:colors locations:@[[NSNumber numberWithFloat:0], [NSNumber numberWithFloat:0.4], [NSNumber numberWithFloat:1]] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
            [thirdBgView addSubview:rightGradientView];
            [WLSocialUIManager addConstraintsWithView:rightGradientView superView:thirdBgView right:0  width:gradientRightWidth top:nowY + scrollViewConfig.shareScrollViewPadingTop height:bgScrollViewHeight];
        }
        
        contentBgViewWidth = (contentBgViewWidth - gradientLeftWidth - gradientRightWidth);
    }
    
    nowY += (scrollViewConfig.shareScrollViewPadingTop + scrollViewConfig.shareScrollViewPadingBottom + bgScrollViewHeight);
    
    UIView *lastView = nil;
    for (int i = 0; i < pageCount; i++) {
        UIView *pageView = [[UIView alloc] init];
        [bgScrollView addSubview:pageView];
        if (i > 0) {
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:scrollViewConfig.shareScrollViewPageMarginLeft + scrollViewConfig.shareScrollViewPageMarginRight];
            
            NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
            
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
            
            NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:lastView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
            
            [NSLayoutConstraint activateConstraints:@[leftConstraint, widthConstraint, topConstraint, bottomConstraint]];
            pageView.translatesAutoresizingMaskIntoConstraints = NO;
        } else {
            contentBgViewWidth = (contentBgViewWidth - scrollViewConfig.shareScrollViewPageMarginLeft - scrollViewConfig.shareScrollViewPageMarginRight);
            
            NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:bgScrollView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:scrollViewConfig.shareScrollViewPageMarginLeft];
            
            NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:bgScrollView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:-(scrollViewConfig.shareScrollViewPageMarginLeft + scrollViewConfig.shareScrollViewPageMarginRight)];
            
            NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bgScrollView attribute:NSLayoutAttributeTop multiplier:1.0f constant:scrollViewConfig.shareScrollViewPageMarginTop];
            
            NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:pageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:bgScrollView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:-(scrollViewConfig.shareScrollViewPageMarginTop + scrollViewConfig.shareScrollViewPageMarginBottom)];
            
            [NSLayoutConstraint activateConstraints:@[leftConstraint, widthConstraint, topConstraint, heightConstraint]];
            pageView.translatesAutoresizingMaskIntoConstraints = NO;
        }
        pageView.backgroundColor = scrollViewConfig.shareScrollViewPageBGColor;
        lastView = pageView;
        
        NSInteger remainderNum = platforms.count - (maxX * maxY) * i;
        if (remainderNum > 0) {
            UIView *lastItemView = nil;
            for (int j = 0; j < (remainderNum > (maxX * maxY) ? (maxX * maxY) : remainderNum); j++) {
                NSInteger nowX = j % maxX;
                NSInteger nowY = j / maxX;
                
                CGFloat shareScrollViewPageColumnSpace = MAX(0, (contentBgViewWidth  / maxX) - scrollViewConfig.shareScrollViewPageMaxItemWidth);
                UIView *itemView = [[UIView alloc] init];
                [pageView addSubview:itemView];
                if (!lastItemView || nowX == 0) {
                    CGFloat startX = containerConfig.isShareContainerHaveGradient ? (containerConfig.shareContainerGradientLeftWidth + shareScrollViewPageColumnSpace / 2.0) : shareScrollViewPageColumnSpace / 2.0;
                    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:pageView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:startX];
                    
                    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:scrollViewConfig.shareScrollViewPageMaxItemWidth];
                    
                    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:pageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:nowY * (scrollViewConfig.shareScrollViewPageMaxItemHeight + scrollViewConfig.shareScrollViewPageRowSpace)];
                    
                    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:scrollViewConfig.shareScrollViewPageMaxItemHeight];
                    
                    [NSLayoutConstraint activateConstraints:@[leftConstraint, widthConstraint, topConstraint, heightConstraint]];
                } else {
                    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:lastItemView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:shareScrollViewPageColumnSpace];
                    
                    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:lastItemView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:0];
                    
                    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:pageView attribute:NSLayoutAttributeTop multiplier:1.0f constant:nowY * (scrollViewConfig.shareScrollViewPageMaxItemHeight + scrollViewConfig.shareScrollViewPageRowSpace)];
                    
                    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:itemView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:lastItemView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
                    
                    [NSLayoutConstraint activateConstraints:@[leftConstraint, widthConstraint, topConstraint, heightConstraint]];
                }
                
                
                itemView.translatesAutoresizingMaskIntoConstraints = NO;
                lastItemView = itemView;
                
                UIButton *itemButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [itemView addSubview:itemButton];
                [WLSocialUIManager addConstraintsWithView:itemButton superView:itemView left:0 width:scrollViewConfig.shareScrollViewPageMaxItemBGWidth top:0 height:scrollViewConfig.shareScrollViewPageMaxItemBGHeight];
                
                NSString *iconImageName = [NSString string];
                UILabel *itemLabel = [[UILabel alloc] init];
                [itemView addSubview:itemLabel];
                [WLSocialUIManager addConstraintsWithView:itemLabel superView:itemView left:0 width:scrollViewConfig.shareScrollViewPageMaxItemNameWidth top:scrollViewConfig.shareScrollViewPageMaxItemBGHeight + scrollViewConfig.shareScrollViewPageMaxItemSpaceBetweenIconAndName height:scrollViewConfig.shareScrollViewPageMaxItemNameHeight];
                itemLabel.font = [UIFont systemFontOfSize:10];
                itemLabel.textColor = config.sharePlatformItemViewConfig.sharePlatformItemViewPlatformNameColor;
                itemLabel.textAlignment = NSTextAlignmentCenter;
                NSInteger nowArrayNum = j + (maxX * maxY) * i;
                WLSocialPlatformType platformType = [platforms[nowArrayNum] integerValue];
                switch (platformType) {
                    case WLSocialPlatformType_Sina:
                    {
                        itemLabel.text = @"新浪微博";
                        iconImageName = [NSString stringWithFormat:@"WLShare.bundle/%@", @"sina.png"];
                    }
                        break;
                    case WLSocialPlatformType_WechatSession:
                    {
                        itemLabel.text = @"微信";
                        iconImageName = [NSString stringWithFormat:@"WLShare.bundle/%@", @"wechat.png"];
                    }
                        break;
                    case WLSocialPlatformType_WechatTimeLine:
                    {
                        itemLabel.text = @"微信朋友圈";
                        iconImageName = [NSString stringWithFormat:@"WLShare.bundle/%@", @"wechat_timeline.png"];
                    }
                        break;
                    case WLSocialPlatformType_WechatFavorite:
                    {
                        itemLabel.text = @"微信收藏";
                        iconImageName = [NSString stringWithFormat:@"WLShare.bundle/%@", @"wechat_favorite.png"];
                    }
                        break;
                    case WLSocialPlatformType_QQ:
                    {
                        itemLabel.text = @"QQ";
                        iconImageName = [NSString stringWithFormat:@"WLShare.bundle/%@", @"qq.png"];
                    }
                        break;
                    case WLSocialPlatformType_Qzone:
                    {
                        itemLabel.text = @"QQ空间";
                        iconImageName = [NSString stringWithFormat:@"WLShare.bundle/%@", @"qzone.png"];
                    }
                        break;
                        
                        
                    default:
                        break;
                }
                UIImage *iconImage = [UIImage imageNamed:iconImageName];
                UIImage *bGRadiusColorImage = CIWC(config.sharePlatformItemViewConfig.sharePlatformItemViewBGRadiusColor);
                UIImage *bGRadiusColorPressedImage = CIWC(config.sharePlatformItemViewConfig.sharePlatformItemViewBGRadiusColorPressed);
                switch (scrollViewConfig.shareScrollViewPageItemStyleType) {
                    case WLSocialPlatformItemViewBackgroudType_None:
                    {
                        [itemButton setImage:iconImage forState:UIControlStateNormal];
                    }
                        break;
                    case WLSocialPlatformItemViewBackgroudType_IconAndBGRadius:
                    {
                        
                        CGFloat imagePadingH = (sharePageScrollViewConfig.shareScrollViewPageMaxItemBGWidth - sharePageScrollViewConfig.shareScrollViewPageMaxItemIconWidth) / 2.0;
                        CGFloat imagePadingV = (sharePageScrollViewConfig.shareScrollViewPageMaxItemBGHeight - sharePageScrollViewConfig.shareScrollViewPageMaxItemIconHeight) / 2.0;
                        [itemButton setImage:iconImage forState:UIControlStateNormal];
                        [itemButton setImageEdgeInsets:UIEdgeInsetsMake(imagePadingV, imagePadingH, imagePadingV, imagePadingH)];
                        [itemButton setBackgroundImage:bGRadiusColorImage forState:UIControlStateNormal];
                        [itemButton setBackgroundImage:bGRadiusColorPressedImage forState:UIControlStateHighlighted];
                        itemButton.layer.masksToBounds = YES;
                        itemButton.layer.cornerRadius = scrollViewConfig.shareScrollViewPageMaxItemBGWidth / 2.0;
                    }
                        break;
                    case WLSocialPlatformItemViewBackgroudType_IconAndBGRoundAndSuperRadius:
                    {
                        CGFloat imagePadingH = (sharePageScrollViewConfig.shareScrollViewPageMaxItemBGWidth - sharePageScrollViewConfig.shareScrollViewPageMaxItemIconWidth) / 2.0;
                        CGFloat imagePadingV = (sharePageScrollViewConfig.shareScrollViewPageMaxItemBGHeight - sharePageScrollViewConfig.shareScrollViewPageMaxItemIconHeight) / 2.0;
                        [itemButton setImage:iconImage forState:UIControlStateNormal];
                        [itemButton setImageEdgeInsets:UIEdgeInsetsMake(imagePadingV, imagePadingH, imagePadingV, imagePadingH)];
                        [itemButton setBackgroundImage:bGRadiusColorImage forState:UIControlStateNormal];
                        [itemButton setBackgroundImage:bGRadiusColorPressedImage forState:UIControlStateHighlighted];
                        itemButton.layer.masksToBounds = YES;
                        itemButton.layer.cornerRadius = config.sharePlatformItemViewConfig.sharePlatformItemViewBGRadius;
                    }
                        break;
                        
                    default:
                        break;
                }
                
                itemButton.tag = platformType;
                [itemButton addTarget:[WLSocialUIManager manager] action:@selector(itemButtonAct:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    
    //********* pageControl *********//
    
    WLSocialSharePageControlConfig *pageControlConfig = [WLSocialShareUIConfig shareInstance].sharePageControlConfig;
    CGFloat pageControlViewHeight = 0;
    if (pageControlConfig.isShow && (!pageControlConfig.sharePageControlHidesForSinglePage || pageCount > 1)) {
        pageControlViewHeight = 36;
    }
    UIView *pageControlView = [[UIView alloc] init];
    [thirdBgView addSubview:pageControlView];
    [WLSocialUIManager addConstraintsWithView:pageControlView superView:thirdBgView left:0 right:0 top:nowY height:pageControlViewHeight];
    pageControlView.backgroundColor = pageControlConfig.sharePageControlBackgroundColor;
    nowY += pageControlViewHeight;
    
    if (pageControlConfig.isShow && (!pageControlConfig.sharePageControlHidesForSinglePage || pageCount > 1)) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        [pageControlView addSubview:pageControl];
        [WLSocialUIManager addConstraintsWithView:pageControl superView:pageControlView left:0 right:0 top:0 bottom:0];
        pageControl.numberOfPages = pageCount;
        pageControl.pageIndicatorTintColor = pageControlConfig.sharePageControlPageIndicatorTintColor;
        pageControl.currentPageIndicatorTintColor = pageControlConfig.sharePageControlCurrentPageIndicatorTintColor;
        [pageControl addTarget:[WLSocialUIManager manager] action:@selector(pageControlAct:) forControlEvents:UIControlEventValueChanged];
        [WLSocialUIManager manager].pageControl = pageControl;
    }
    //********* pageControl *********//
    
    
    
    //********* cancelControl *********//
    
    WLSocialShareCancelControlConfig *cancelControlConfig = [WLSocialShareUIConfig shareInstance].shareCancelControlConfig;
    CGFloat cancelControlViewHeight = 0;
    if (cancelControlConfig.isShow) {
        cancelControlViewHeight = 38;
    }
    UIButton *cancelControlButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [thirdBgView addSubview:cancelControlButton];
    [WLSocialUIManager addConstraintsWithView:cancelControlButton superView:thirdBgView left:0 right:0 top:nowY height:cancelControlViewHeight];
    [cancelControlButton setBackgroundImage:CIWC(cancelControlConfig.shareCancelControlBackgroundColor) forState:UIControlStateNormal];
    [cancelControlButton setBackgroundImage:CIWC(cancelControlConfig.shareCancelControlBackgroundColorPressed) forState:UIControlStateHighlighted];
    [cancelControlButton setTitle:cancelControlConfig.shareCancelControlText forState:UIControlStateNormal];
    [cancelControlButton setTitleColor:cancelControlConfig.shareCancelControlTextColor forState:UIControlStateNormal];
    cancelControlButton.titleLabel.font = cancelControlConfig.shareCancelControlTextFont;
    [cancelControlButton addTarget:[WLSocialUIManager manager] action:@selector(cancelControlButtonAct) forControlEvents:UIControlEventTouchUpInside];
    nowY += cancelControlViewHeight;
    
    //********* cancelControl *********//
    
    heightConstraint.constant = nowY;
    
    if (config.sharePageGroupViewConfig.sharePageGroupViewPostionType == WLSocialSharePageGroupViewPositionType_Middle) {
        topConstraint.constant  = topConstraint.constant - ([WLSocialUIManager manager].firstBgView.frame.size.height - nowY) / 2.0;
    }
    
    
}

+ (void)addConstraintsWithView:(UIView *)view superView:(UIView *)superView left:(CGFloat)left right:(CGFloat)right top:(CGFloat)top height:(CGFloat)height
{
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:left];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-right];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0f constant:top];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height];
    
    [NSLayoutConstraint activateConstraints:@[leftConstraint, rightConstraint, topConstraint, heightConstraint]];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    //iOS 8.0以后设置active属性值
}

+ (void)addConstraintsWithView:(UIView *)view superView:(UIView *)superView left:(CGFloat)left width:(CGFloat)width top:(CGFloat)top height:(CGFloat)height
{
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:left];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:width];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0f constant:top];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height];
    
    [NSLayoutConstraint activateConstraints:@[leftConstraint, widthConstraint, topConstraint, heightConstraint]];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    //iOS 8.0以后设置active属性值
}

+ (void)addConstraintsWithView:(UIView *)view superView:(UIView *)superView right:(CGFloat)right width:(CGFloat)width top:(CGFloat)top height:(CGFloat)height
{
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:right];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:width];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0f constant:top];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height];
    
    [NSLayoutConstraint activateConstraints:@[rightConstraint, widthConstraint, topConstraint, heightConstraint]];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    //iOS 8.0以后设置active属性值
}

+ (void)addConstraintsWithView:(UIView *)view superView:(UIView *)superView left:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom height:(CGFloat)height
{
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:left];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-right];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-bottom];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height];
    
    [NSLayoutConstraint activateConstraints:@[leftConstraint, rightConstraint, bottomConstraint, heightConstraint]];
    view.translatesAutoresizingMaskIntoConstraints = NO;
}

+ (void)addConstraintsWithView:(UIView *)view superView:(UIView *)superView left:(CGFloat)left right:(CGFloat)right top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeLeading multiplier:1.0f constant:left];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-right];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeTop multiplier:1.0f constant:top];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-bottom];
    
    [NSLayoutConstraint activateConstraints:@[leftConstraint, rightConstraint, topConstraint, bottomConstraint]];
    view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)cancelControlButtonAct
{
    [self tapAct];
}

- (void)tapAct
{
    if ([WLSocialUIManager manager].firstBgView) {
        [[WLSocialUIManager manager].firstBgView removeFromSuperview];
        [WLSocialUIManager manager].firstBgView = nil;
        [[WLSocialUIManager manager].secondBgView removeFromSuperview];
        [WLSocialUIManager manager].secondBgView = nil;
    }
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat xOffset = targetContentOffset->x;
    
    NSLog(@"velocity===%f,%f, xOffset=%f",velocity.x, velocity.y, xOffset);
    
    NSInteger pageInt = xOffset / scrollView.frame.size.width;
    
    [WLSocialUIManager manager].pageControl.currentPage = pageInt;
    
    [WLSocialUIManager manager].pageControl.currentPageIndicatorTintColor = [UIColor blueColor];
    
}

- (void)pageControlAct:(UIPageControl *)sender
{
    NSInteger pageNum = sender.currentPage;
    CGSize viewSize = self.bgScrollView.frame.size;
    [self.bgScrollView setContentOffset:CGPointMake(pageNum * viewSize.width, 0)];
}

- (void)itemButtonAct:(UIButton *)sender
{
    WLSocialSharePlatformSelectionBlock block = [WLSocialUIManager manager].selectionBlock;
    if (block) {
        block(sender.tag, nil);
    }
    
    [self tapAct];
}


@end




