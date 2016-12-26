//
//  WLSocialMessageObject.h
//  GeneralHospital
//
//  Created by 杭州卓健_黄 on 2016/12/16.
//  Copyright © 2016年 卓健科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WLSocialMessageObject : NSObject

/**
 * text 文本内容
 * @note 非纯文本分享文本
 */
@property (nonatomic, copy) NSString  *text;

/**
 * 分享的所媒体内容对象
 */
@property (nonatomic, strong) id shareObject;

/**
 * 其他相关参数，见相应平台说明
 */
@property (nonatomic, strong) NSDictionary *moreInfo;

+ (WLSocialMessageObject *)messageObject;

@end

@interface WLShareObject : NSObject

/**
 * 标题
 * @note 标题的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *title;

/**
 * 描述
 * @note 描述内容的长度依各个平台的要求而定
 */
@property (nonatomic, copy) NSString *descr;

/**
 * 缩略图 UIImage或者NSData类型或者NSString类型（图片url）
 */
@property (nonatomic, strong) id thumbImage;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumbImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (id)shareObjectWithTitle:(NSString *)title
                     descr:(NSString *)descr
                 thumbImage:(id)thumbImage;

+ (void)wl_imageDataWithImage:(id)image withCompletion:(void (^)(NSData *imageData,NSError* error))completion;

@end

@interface WLShareImageObject : WLShareObject

/** 图片内容 （可以是UIImage类对象，也可以是NSdata类对象，也可以是图片链接imageUrl NSString类对象）
 * @note 图片大小根据各个平台限制而定
 */
@property (nonatomic, retain) id shareImage;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumbImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (WLShareImageObject *)shareObjectWithTitle:(NSString *)title
                                       descr:(NSString *)descr
                                   thumbImage:(id)thumbImage;

@end

@interface WLShareMusicObject : WLShareObject

/** 音乐网页的url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicUrl;
/** 音乐lowband网页的url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicLowBandUrl;
/** 音乐数据url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicDataUrl;

/**音乐lowband数据url地址
 * @note 长度不能超过10K
 */
@property (nonatomic, retain) NSString *musicLowBandDataUrl;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumbImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (WLShareMusicObject *)shareObjectWithTitle:(NSString *)title
                                       descr:(NSString *)descr
                                   thumbImage:(id)thumbImage;

@end


@interface WLShareVideoObject : WLShareObject

/**
 视频网页的url
 
 @warning 不能为空且长度不能超过255
 */
@property (nonatomic, strong) NSString *videoUrl;

/**
 视频lowband网页的url
 
 @warning 长度不能超过255
 */
@property (nonatomic, strong) NSString *videoLowBandUrl;

/**
 视频数据流url
 
 @warning 长度不能超过255
 */
@property (nonatomic, strong) NSString *videoStreamUrl;

/**
 视频lowband数据流url
 
 @warning 长度不能超过255
 */
@property (nonatomic, strong) NSString *videoLowBandStreamUrl;


/**
 * @param title 标题
 * @param descr 描述
 * @param thumbImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (WLShareVideoObject *)shareObjectWithTitle:(NSString *)title
                                       descr:(NSString *)descr
                                   thumbImage:(id)thumbImage;

@end

@interface WLShareWebpageObject : WLShareObject

/** 网页的url地址
 * @note 不能为空且长度不能超过10K
 */
@property (nonatomic, retain) NSString *webpageUrl;

/**
 * @param title 标题
 * @param descr 描述
 * @param thumbImage 缩略图（UIImage或者NSData类型，或者image_url）
 *
 */
+ (WLShareWebpageObject *)shareObjectWithTitle:(NSString *)title
                                         descr:(NSString *)descr
                                     thumbImage:(id)thumbImage;

@end


