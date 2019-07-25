//
//  YWHttpClient.h
//  WowoMerchant
//
//  Created by 许开伟 on 2018/5/29.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWPhotoResponse.h"
#import "KWIphoneModelType.h"

#define kAlertTipCode 222
//  网络状态通知
#define kAFNetworkReachability        @"AFNetworkReachabilityManager"

#define HttpErrorNoNet                 @"网络不可用，请稍后再试！"
#define HttpErrorSystemError           @"系统繁忙，请稍后再试！"
#define HttpErrorPhaseError            @"数据解析异常"
#define HttpErrorDataFormatError       @"数据返回格式异常"

//网络引擎
#define YWHttpEngine [YWHttpClient sharedManager]

@interface YWResponse : NSObject
@property (nonatomic, strong) id responseData;//返回报文Data部分
@property (nonatomic, assign) BOOL success;//是否成功[严格]
@property (nonatomic, assign) BOOL tokenInvalid;//token是否失效  Yes:失效
@property (nonatomic, copy) NSString *errorMsg;//错误提示文案
@property (nonatomic, assign) BOOL showToast;//此错误是否应弹框提示 Yes:弹框提示

@property (nonatomic, assign) NSInteger statusCode;//iOS客户端定义的错误状态码（不是服务端的）
//errorCode业务层不需要关心，这里只是把服务器这个字段保存下来
@property (nonatomic, copy) NSString *errorCode;
@end

typedef void (^FinishBlock)(YWResponse *response);

@interface YWHttpClient : NSObject

/**
 Singleon
 
 @return return value description
 */
+ (instancetype)sharedManager;

/**
 异步，发起网络请求
 
 @param url 请求地址
 @param parmaters 请求参数
 @param finishBlock 请求完成的回调
 */
- (void)requestUrl:(NSString *)url
         parmaters:(NSDictionary *)parmaters
       finishBlock:(FinishBlock)finishBlock;

/**
 异步，发起网络请求
 
 @param url 请求地址
 @param parmaters 请求参数
 @param needJump NO：不需要跳登陆
 @param finishBlock 请求完成的回调
 */
- (void)requestUrl:(NSString *)url
         parmaters:(NSDictionary *)parmaters
         needJumpLogin:(BOOL)needJump
       finishBlock:(FinishBlock)finishBlock;


/**
 同步请求
 
 @param url url
 @param parmaters parmaters description
 @param finishBlock finishBlock description
 */
- (void)synchRequestUrl:(NSString *)url
              parmaters:(NSDictionary *)parmaters
            finishBlock:(FinishBlock)finishBlock;

/**
 同步请求
 
 @param url url
 @param parmaters parmaters description
 @param needJump NO：不需要跳登陆
 @param finishBlock finishBlock description
 */
- (void)synchRequestUrl:(NSString *)url
              parmaters:(NSDictionary *)parmaters
          needJumpLogin:(BOOL)needJump
            finishBlock:(FinishBlock)finishBlock;


/**
 图片批量上传(并发,保证返回结果顺序与传入顺序一致)

 @param photos 图片数组（uiimage/nsdata）
 @param block block description
 */
- (void)uploadImages:(NSArray *)photos
          uploadPath:(NSString *)uploadPath
      completedBlock:(void(^)(BOOL succ, YWPhotoResponse *resp))block;

/**
 *  上传图片(单张)
 *
 *  @param path    路径
 *  @param image   图片
 *  @param finishBlock 回调
 */
- (void)uploadImageWithPath:(NSString *)path
                      image:(id)image
                finishBlock:(FinishBlock)finishBlock;

/**
 *  上传图片(多张,不保证返回结果顺序)
 *
 *  @param path    路径
 *  @param photos  图片数组
 *  @param finishBlock 回调
 */
- (void)uploadImageWithPath:(NSString *)path
                     photos:(NSArray *)photos
                finishBlock:(FinishBlock)finishBlock;

@end
