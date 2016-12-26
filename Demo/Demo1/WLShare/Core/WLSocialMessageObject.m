//
//  WLSocialMessageObject.m
//  GeneralHospital
//
//  Created by 杭州卓健_黄 on 2016/12/16.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import "WLSocialMessageObject.h"
#import <UIKit/UIKit.h>

@implementation WLSocialMessageObject

+ (WLSocialMessageObject *)messageObject
{
//    static WLSocialMessageObject *_ocialMessageObject = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _ocialMessageObject = [[WLSocialMessageObject alloc] init];
//    });
//    
//    return _ocialMessageObject;
    
    return [[WLSocialMessageObject alloc] init];
}

@end

@interface WLShareObject ()

@end

@implementation WLShareObject

+ (id)shareObjectWithTitle:(NSString *)title descr:(NSString *)descr thumbImage:(id)thumbImage
{
    WLShareObject *shareObject = [[WLShareObject alloc] init];
    shareObject.title = title;
    shareObject.descr = descr;
    [WLShareObject wl_imageDataWithImage:thumbImage withCompletion:^(NSData *imageData, NSError *error) {
        if (imageData.length > 0) {
            shareObject.thumbImage = [UIImage imageWithData:imageData];
        } else {
            NSLog(@"error=%i", (int)error.code);
        }
    }];
    
    return shareObject;
}

+ (void)wl_imageDataWithImage:(id)image withCompletion:(void (^)(NSData *, NSError *))completion
{
    NSData *data = [NSData data];
    if ([image isKindOfClass:[UIImage class]]) {
        data = UIImagePNGRepresentation(image);
    } else if ([image isKindOfClass:[NSData class]]) {
        data = image;
    } else if ([image isKindOfClass:[NSURL class]]) {
        data = [NSData dataWithContentsOfURL:image];
    } else {
        data = [NSData dataWithContentsOfURL:[NSURL URLWithString:image]];
    }
    
    NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:0 userInfo:nil];
    completion(data, error);
}

- (void)setThumbImage:(id)thumbImage
{
    [WLShareObject wl_imageDataWithImage:thumbImage withCompletion:^(NSData *imageData, NSError *error) {
        if (imageData.length > 0) {
            _thumbImage = [UIImage imageWithData:imageData];
        } else {
            NSLog(@"error = %i, ", (int)error.code);
        }
    }];
}

@end

@interface WLShareImageObject ()

@end

@implementation WLShareImageObject

- (void)setShareImage:(id)shareImage
{
    [WLShareObject wl_imageDataWithImage:shareImage withCompletion:^(NSData *imageData, NSError *error) {
        if (imageData.length > 0) {
            _shareImage = imageData;
        } else {
            NSLog(@"error=%i", (int)error.code);
        }
    }];
}

+ (WLShareImageObject *)shareObjectWithTitle:(NSString *)title descr:(NSString *)descr thumbImage:(id)thumbImage
{
    WLShareImageObject *webpageObject = [[WLShareImageObject alloc] init];
    webpageObject.title = title;
    webpageObject.descr = descr;
    [WLShareObject wl_imageDataWithImage:thumbImage withCompletion:^(NSData *imageData, NSError *error) {
        if (imageData.length > 0) {
            webpageObject.thumbImage = [UIImage imageWithData:imageData];
        } else {
            NSLog(@"error=%i", (int)error.code);
        }
    }];
    
    return webpageObject;
}

@end

@interface WLShareMusicObject ()

@end

@implementation WLShareMusicObject

+ (WLShareMusicObject *)shareObjectWithTitle:(NSString *)title descr:(NSString *)descr thumbImage:(id)thumbImage
{
    WLShareMusicObject *musicObject = [[WLShareMusicObject alloc] init];
    musicObject.title = title;
    musicObject.descr = descr;
    [WLShareObject wl_imageDataWithImage:thumbImage withCompletion:^(NSData *imageData, NSError *error) {
        if (imageData.length > 0) {
            musicObject.thumbImage = [UIImage imageWithData:imageData];
            
        } else {
            NSLog(@"error=%i", (int)error.code);
        }
    }];
    
    return musicObject;
}

@end

@interface WLShareVideoObject ()

@end

@implementation WLShareVideoObject

+ (WLShareVideoObject *)shareObjectWithTitle:(NSString *)title descr:(NSString *)descr thumbImage:(id)thumbImage
{
    WLShareVideoObject *videoObject = [[WLShareVideoObject alloc] init];
    videoObject.title = title;
    videoObject.descr = descr;
    [WLShareObject wl_imageDataWithImage:thumbImage withCompletion:^(NSData *imageData, NSError *error) {
        if (imageData.length > 0) {
            videoObject.thumbImage = [UIImage imageWithData:imageData];
        } else {
            NSLog(@"error=%i", (int)error.code);
        }
    }];
    
    return videoObject;
}

@end

@interface WLShareWebpageObject ()

@end

@implementation WLShareWebpageObject

+ (WLShareWebpageObject *)shareObjectWithTitle:(NSString *)title descr:(NSString *)descr thumbImage:(id)thumbImage
{
    WLShareWebpageObject *webpageObject = [[WLShareWebpageObject alloc] init];
    webpageObject.title = title;
    webpageObject.descr = descr;
    [WLShareObject wl_imageDataWithImage:thumbImage withCompletion:^(NSData *imageData, NSError *error) {
        if (imageData.length > 0) {
            webpageObject.thumbImage = [UIImage imageWithData:imageData];
        } else {
            NSLog(@"error=%i", (int)error.code);
        }
    }];
    
    return webpageObject;
}

@end
