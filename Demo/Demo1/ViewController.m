//
//  ViewController.m
//  Demo1
//
//  Created by 杭州卓健_黄 on 2016/12/19.
//  Copyright © 2016年 黄. All rights reserved.
//

#import "ViewController.h"
#import "WLShareUI.h"

static NSString* const UMS_Title = @"欢迎使用【友盟+】社会化组件U-Share";
static NSString* const UMS_Text = @"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！";

static NSString* const UMS_THUMB_IMAGE = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
static NSString* const UMS_IMAGE = @"https://mobile.umeng.com/images/pic/home/social/img-1.png";

static NSString* const UMS_WebLink = @"http://mobile.umeng.com/social";

@interface ViewController ()

@property (nonatomic, strong) UIView *leftGradientView;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    button.frame = CGRectMake(40, 100, 100, 45);
    [button addTarget:self action:@selector(buttonAct) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor greenColor];
    
    self.leftGradientView = [[UIView alloc] init];
    [self.view addSubview:self.leftGradientView];
    self.leftGradientView.backgroundColor = [UIColor whiteColor];
    self.leftGradientView.frame = CGRectMake(0, 200, 200, 100);
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button2];
    button2.frame = CGRectMake(180, 100, 100, 45);
    [button2 addTarget:self action:@selector(button2Act) forControlEvents:UIControlEventTouchUpInside];
    button2.backgroundColor = [UIColor blueColor];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button3];
    button3.frame = CGRectMake(110, 200, 100, 45);
    [button3 addTarget:self action:@selector(button3Act) forControlEvents:UIControlEventTouchUpInside];
    button3.backgroundColor = [UIColor orangeColor];
    
}

- (void)buttonAct
{
    [WLSocialUIManager setPlatforms:@[@(WLSocialPlatformType_WechatSession),
                                      @(WLSocialPlatformType_WechatTimeLine),
                                      @(WLSocialPlatformType_WechatFavorite),
                                      @(WLSocialPlatformType_QQ),
                                      @(WLSocialPlatformType_Qzone),
                                      @(WLSocialPlatformType_WechatFavorite),
                                      @(WLSocialPlatformType_QQ),
                                      @(WLSocialPlatformType_Qzone),
                                      @(WLSocialPlatformType_WechatFavorite),
                                      @(WLSocialPlatformType_QQ),
                                      @(WLSocialPlatformType_Qzone),
                                      ]];
    [WLSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = WLSocialSharePageGroupViewPositionType_Bottom;
    [WLSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = WLSocialPlatformItemViewBackgroudType_None;
    
    [WLSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(WLSocialPlatformType platformType, NSDictionary *userInfo) {
//        [self shareTextToPlatformType:platformType];
        [self shareImageToPlatformType:platformType];
//        [self shareWebPageToPlatformType:platformType];
    }];
}

- (void)button2Act
{
    [WLSocialUIManager setPlatforms:@[@(WLSocialPlatformType_WechatSession),
                                      @(WLSocialPlatformType_WechatTimeLine),
                                      @(WLSocialPlatformType_WechatFavorite),
                                      @(WLSocialPlatformType_QQ),
                                      @(WLSocialPlatformType_Qzone),
                                      @(WLSocialPlatformType_WechatFavorite),
                                      @(WLSocialPlatformType_QQ),
                                      @(WLSocialPlatformType_Qzone),
                                      @(WLSocialPlatformType_WechatFavorite),
                                      @(WLSocialPlatformType_QQ),
                                      @(WLSocialPlatformType_Qzone),
                                      ]];
    [WLSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = WLSocialSharePageGroupViewPositionType_Middle;
    [WLSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = WLSocialPlatformItemViewBackgroudType_IconAndBGRadius;
    [WLSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(WLSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareMusicToPlatformType:platformType];
    }];
}

- (void)button3Act
{
    [WLSocialUIManager setPlatforms:@[@(WLSocialPlatformType_WechatSession),
                                      @(WLSocialPlatformType_WechatTimeLine),
                                      @(WLSocialPlatformType_WechatFavorite),
                                      @(WLSocialPlatformType_QQ),
                                      @(WLSocialPlatformType_Qzone),
                                      @(WLSocialPlatformType_WechatFavorite),
                                      @(WLSocialPlatformType_QQ),
                                      @(WLSocialPlatformType_Qzone),
                                      @(WLSocialPlatformType_WechatFavorite),
                                      @(WLSocialPlatformType_QQ),
                                      @(WLSocialPlatformType_Qzone),
                                      ]];
    [WLSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = WLSocialSharePageGroupViewPositionType_Middle;
    [WLSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = WLSocialPlatformItemViewBackgroudType_IconAndBGRoundAndSuperRadius;
    [WLSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(WLSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareVedioToPlatformType:platformType];
    }];
}

#pragma mark - share type
//分享文本
- (void)shareTextToPlatformType:(WLSocialPlatformType)platformType
{
    //创建分享消息对象
    WLSocialMessageObject *messageObject = [WLSocialMessageObject messageObject];
    //设置文本
    messageObject.text = @"🐵";
    //调用分享接口
    [[WLSocialManager socialManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        [self alertWithError:error];
    }];
}

//分享图片
- (void)shareImageToPlatformType:(WLSocialPlatformType)platformType
{
    //创建分享消息对象
    WLSocialMessageObject *messageObject = [WLSocialMessageObject messageObject];
    
    //创建图片内容对象
    WLShareImageObject *shareObject = [[WLShareImageObject alloc] init];
    //如果有缩略图，则设置缩略图本地
    shareObject.thumbImage = [UIImage imageNamed:@"1.jpg"];
    
    [shareObject setShareImage:@"https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=214931719,1608091472&fm=116&gp=0.jpg"];
    
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[WLSocialManager socialManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        [self alertWithError:error];
    }];
}

//音乐分享
- (void)shareMusicToPlatformType:(WLSocialPlatformType)platformType
{
    //创建分享消息对象
    WLSocialMessageObject *messageObject = [WLSocialMessageObject messageObject];
    
    //创建音乐内容对象
    NSString* thumbURL =  UMS_THUMB_IMAGE;
    WLShareMusicObject *shareObject = [WLShareMusicObject shareObjectWithTitle:UMS_Title descr:UMS_Text thumbImage:thumbURL];
    //设置音乐网页播放地址
    shareObject.musicUrl = @"http://c.y.qq.com/v8/playsong.html?songid=108782194&source=yqq#wechat_redirect";
    shareObject.musicDataUrl = @"http://music.huoxing.com/upload/20130330/1364651263157_1085.mp3";
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[WLSocialManager socialManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        [self alertWithError:error];
    }];
    
}

//视频分享
- (void)shareVedioToPlatformType:(WLSocialPlatformType)platformType
{
    //创建分享消息对象
    WLSocialMessageObject *messageObject = [WLSocialMessageObject messageObject];
    
    NSString* thumbURL =  UMS_THUMB_IMAGE;
    WLShareVideoObject *shareObject = [WLShareVideoObject shareObjectWithTitle:UMS_Title descr:UMS_Text thumbImage:thumbURL];
    //设置视频网页播放地址
    shareObject.videoUrl = @"http://video.sina.com.cn/p/sports/cba/v/2013-10-22/144463050817.html";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[WLSocialManager socialManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        [self alertWithError:error];
    }];
}


- (void)shareWebPageToPlatformType:(WLSocialPlatformType)platformType
{
    //创建分享消息对象
    WLSocialMessageObject *messageObject = [WLSocialMessageObject messageObject];
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    WLShareWebpageObject *shareObject = [WLShareWebpageObject shareObjectWithTitle:@"你好猴子" descr:@"🐵🐵🐵🐵" thumbImage:image];
    //设置网页地址
    shareObject.webpageUrl = @"https://www.baidu.com";
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[WLSocialManager socialManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        [self alertWithError:error];
        
    }];
}

- (void)alertWithError:(NSError *)error
{
    NSString *result = nil;
    if (!error) {
        result = [NSString stringWithFormat:@"Share succeed"];
    }
    else{
        NSMutableString *str = [NSMutableString string];
        if (error.userInfo) {
            for (NSString *key in error.userInfo) {
                [str appendFormat:@"%@ = %@\n", key, error.userInfo[key]];
            }
        }
        if (error) {
            result = [NSString stringWithFormat:@"Share fail with error code: %d\n%@",(int)error.code, str];
        }
        else{
            result = [NSString stringWithFormat:@"Share fail"];
        }
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"share"
                                                    message:result
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"sure", @"确定")
                                          otherButtonTitles:nil];
    [alert show];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
