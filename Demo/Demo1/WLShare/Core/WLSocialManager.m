//
//  WLSocialManager.m
//  GeneralHospital
//
//  Created by 杭州卓健_黄 on 2016/12/16.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import "WLSocialManager.h"
#import "WLSocialMessageObject.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface WLSocialManager ()<WXApiDelegate>

@property (nonatomic, copy) WLSocialRequestCompletionHandler completion;

@property (nonatomic, assign) WLSocialPlatformType platformType;

@property (nonatomic, strong) id currentViewController;

@end

@implementation WLSocialManager

+ (instancetype)socialManager
{
    static WLSocialManager *_socialManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _socialManager = [[self alloc] init];
    });
    
    return _socialManager;
}

- (void)shareToPlatform:(WLSocialPlatformType)platformType
          messageObject:(WLSocialMessageObject *)messageObject
  currentViewController:(id)currentViewController
             completion:(WLSocialRequestCompletionHandler)completion
{
    self.completion = completion;
    self.platformType = platformType;
    id shareObject = messageObject.shareObject;
    self.currentViewController = currentViewController;
    switch (platformType) {
        case WLSocialPlatformType_WechatSession :
        case WLSocialPlatformType_WechatTimeLine:
        case WLSocialPlatformType_WechatFavorite:
        {
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            if (shareObject) {
                WXMediaMessage *message = [WXMediaMessage message];
                if ([shareObject isKindOfClass:[WLShareImageObject class]]) {
                    
                    WLShareImageObject *object = messageObject.shareObject;
                    [message setThumbImage:object.thumbImage];
                    
                    WXImageObject *imageObject = [WXImageObject object];
                    imageObject.imageData = object.shareImage;
                    message.mediaObject = imageObject;
                    
                    
                } else if ([shareObject isKindOfClass:[WLShareMusicObject class]]) {
                    WLShareMusicObject *object = messageObject.shareObject;
                    message.title = object.title;
                    message.description = object.descr;
                    [message setThumbImage:object.thumbImage];
                    
                    WXMusicObject *musicObject = [WXMusicObject object];
                    musicObject.musicUrl = object.musicUrl;
                    musicObject.musicLowBandUrl = object.musicLowBandUrl;
                    musicObject.musicDataUrl = object.musicDataUrl;
                    musicObject.musicLowBandDataUrl = object.musicLowBandDataUrl;
                    message.mediaObject = musicObject;
                } else if ([shareObject isKindOfClass:[WLShareVideoObject class]]) {
                    WLShareVideoObject *object = messageObject.shareObject;
                    message.title = object.title;
                    message.description = object.descr;
                    [message setThumbImage:object.thumbImage];
                    
                    WXVideoObject *videoObjec = [WXVideoObject object];
                    videoObjec.videoUrl = object.videoUrl;
                    videoObjec.videoLowBandUrl = object.videoLowBandUrl;
                    message.mediaObject = videoObjec;
                } else if ([shareObject isKindOfClass:[WLShareWebpageObject class]]) {
                    WLShareWebpageObject *object = messageObject.shareObject;
                    message.title = object.title;
                    message.description = object.descr;
                    [message setThumbImage:object.thumbImage];
                    
                    WXWebpageObject *webpageObject = [WXWebpageObject object];
                    webpageObject.webpageUrl = object.webpageUrl;
                    message.mediaObject = webpageObject;
                }
                
                req.bText = NO;
                req.message = message;
            } else {
                req.bText = YES;
                req.text = messageObject.text;
            }
            
            if (platformType == WLSocialPlatformType_WechatSession) {
                req.scene = WXSceneSession;
            } else if (platformType == WLSocialPlatformType_WechatTimeLine) {
                req.scene = WXSceneTimeline;
            } else if (platformType == WLSocialPlatformType_WechatFavorite) {
                req.scene = WXSceneFavorite;
            }
            
            [WXApi sendReq:req];
        }
            break;
        case WLSocialPlatformType_QQ:
        case WLSocialPlatformType_Qzone:
        {
            SendMessageToQQReq *req = [SendMessageToQQReq new];
            if (shareObject) {
                if ([shareObject isKindOfClass:[WLShareImageObject class]]) {
                    WLShareImageObject *object = messageObject.shareObject;
                    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:object.shareImage
                                                               previewImageData:UIImagePNGRepresentation(object.thumbImage)
                                                                          title:object.title
                                                                    description:object.description];
                    req = [SendMessageToQQReq reqWithContent:imgObj];
                } else if ([shareObject isKindOfClass:[WLShareMusicObject class]]) {
                    WLShareMusicObject *object = messageObject.shareObject;
                    QQApiAudioObject *audioObj = [QQApiAudioObject
                                                  objectWithURL:[NSURL URLWithString:object.musicUrl]
                                                  title:object.title
                                                  description:object.descr
                                                  previewImageData:UIImagePNGRepresentation(object.thumbImage)];
                    //设置播放流媒体地址
                    [audioObj setFlashURL:[NSURL URLWithString:object.musicDataUrl]];
                    req = [SendMessageToQQReq reqWithContent:audioObj];
                } else if ([shareObject isKindOfClass:[WLShareVideoObject class]]) {
                    WLShareVideoObject *object = messageObject.shareObject;
                    QQApiNewsObject *newsObj = [QQApiNewsObject
                                                objectWithURL:[NSURL URLWithString:object.videoUrl]
                                                title:object.title
                                                description:object.descr
                                                previewImageData:UIImagePNGRepresentation(object.thumbImage)];
                    req = [SendMessageToQQReq reqWithContent:newsObj];
                } else if ([shareObject isKindOfClass:[WLShareWebpageObject class]]) {
                    WLShareWebpageObject *object = messageObject.shareObject;
                    QQApiNewsObject *newsObj = [QQApiNewsObject
                                                objectWithURL:[NSURL URLWithString:object.webpageUrl]
                                                title:object.title
                                                description:object.descr
                                                previewImageData:UIImagePNGRepresentation(object.thumbImage)];
                    req = [SendMessageToQQReq reqWithContent:newsObj];
                    //将内容分享到qzone
                }
            } else {
                //开发者分享的文本内容
                QQApiTextObject *txtObj = [QQApiTextObject objectWithText:messageObject.text];
                req = [SendMessageToQQReq reqWithContent:txtObj];
            }

            if (platformType == WLSocialPlatformType_QQ) {
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
                [self handleSendResult:sent];
            } else if (platformType == WLSocialPlatformType_Qzone) {
                QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
                [self handleSendResult:sent];
            }
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    WLSocialRequestCompletionHandler completion = self.completion;
    if (completion) {
        switch (self.platformType) {
            case WLSocialPlatformType_WechatSession:
            case WLSocialPlatformType_WechatTimeLine:
            case WLSocialPlatformType_WechatFavorite:
            {
                [WXApi handleOpenURL:url delegate:self];
            }
                break;
            case WLSocialPlatformType_QQ:
            case WLSocialPlatformType_Qzone:
            {
                [self handleOpenURLWithQQ:url];
                return [TencentOAuth HandleOpenURL:url];
            }
                break;
                
            default:
                break;
        }
    }
    
    
    return YES;
}

- (void)handleOpenURLWithQQ:(NSURL *)url
{
    NSString *str = @"QQ";
    if([url.absoluteString hasPrefix:str]){
        NSString *strHost = @"response_from_qq";
        
        if([url.host isEqualToString:strHost]) {
            NSString *URL = @"?";
            NSRange range = [url.absoluteString rangeOfString:URL];
            NSString *getStr = [[self decodeFromPercentEscapeString:url.absoluteString] substringFromIndex:range.location+URL.length];
            NSArray *array = [getStr componentsSeparatedByString:@"&"];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            for (NSString *str in array) {
                NSArray *itemArray = [str componentsSeparatedByString:@"="];
                if (itemArray.count >= 2) {
                    [dict setObject:itemArray[1] forKey:itemArray[0]];
                }
            }
            NSLog(@"GetDict === %@",dict);
            WLSocialRequestCompletionHandler completion = self.completion;
            if (completion) {
                if ([dict[@"error"] integerValue] == 0) {
                    completion(nil, nil);
                } else {
                    NSError *newRrror = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:[dict[@"error"] integerValue] userInfo:nil];
                    completion(nil, newRrror);
                }
                
            }
        }
        
    }
}

- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (void)onResp:(BaseResp *)resp
{
    NSLog(@"微信支付通知：%d----%@",resp.errCode,resp.errStr);
    WLSocialRequestCompletionHandler completion = self.completion;
    if (completion) {
        if (resp.errCode == 0) {
            completion(nil, nil);
        } else {
            NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:resp.errStr, @"errStr", nil];
            NSError *newRrror = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:resp.errCode userInfo:userInfo];
            completion(resp.errStr, newRrror);
        }
        
    }
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTTEXT:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持QQApiTextObject，请使用QQApiImageArrayForQZoneObject分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIQZONENOTSUPPORTIMAGE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"空间分享不支持QQApiImageObject，请使用QQApiImageArrayForQZoneObject分享" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIVERSIONNEEDUPDATE:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"当前QQ版本太低，需要更新" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        default:
        {
            break;
        }
    }
}

@end
