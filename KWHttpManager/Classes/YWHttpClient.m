//
//  YWHttpClient.m
//  WowoMerchant
//
//  Created by 许开伟 on 2018/5/29.
//  Copyright © 2018年 NanjingYunWo. All rights reserved.
//

#import "YWHttpClient.h"
#import <AFNetworking/AFNetworking.h>
#import <KWLogger/KWLogger.h>
#import <KWCategoriesLib/NSArray+Safe.h>
#import <KWCategoriesLib/UIImage+fixOrientation.h>
#import "UIImage+YWCompress.h"
#import "KWSafeNull.h"
#import <MJExtension/MJExtension.h>

@implementation YWResponse

@end

@interface YWHttpClient ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, assign) AFNetworkReachabilityStatus netStatus;
@property (nonatomic, assign) BOOL needJumpLogin;
@end

@implementation YWHttpClient

/**
 Singleon

 @return return value description
 */
+ (instancetype)sharedManager{
    static YWHttpClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YWHttpClient alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    if (self = [super init]) {
        //初始化manager
        self.manager = [AFHTTPSessionManager manager];
        //我们所有请求接口入参json形式
        self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //设置超时时间
        self.manager.requestSerializer.timeoutInterval = 20.f;
        //设置请求Json格式
        [self.manager.requestSerializer setValue:@"application/json;charset=UTF-8"
                              forHTTPHeaderField:@"Content-Type"];
        //设置可接受的返回数据类型
        AFJSONResponseSerializer *response = [AFJSONResponseSerializer serializer];
        self.manager.responseSerializer = response;
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        //注册网络状态变化的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkReachabilityStatusChanged:) name:kAFNetworkReachability object:nil];
        
        //默认网络初始化为连通的
        self.netStatus = AFNetworkReachabilityStatusReachableViaWWAN;
        
        [self registerNetworkReachability];
        
        self.needJumpLogin = YES;//默认token失效需要弹出登陆
    }
    return self;
}


+ (AFSecurityPolicy *)customSecurityPolicy
{
    // 先导入证书，在这加证书，一般情况适用于单项认证
    // 证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"wowoshenghuo.com_https" ofType:@"cer"];
    
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    
    if (cerData == nil) {
        return nil;
    }
    NSSet *setData = [NSSet setWithObject:cerData];
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书(也就是自建的证书)，默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    // validatesDomainName 是否需要验证域名，默认为YES;
    // 假如证书的域名与你请求的域名不一致，需要把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    // 设置为NO，主要用于这种情况：客户端请求的事子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com,那么mail.google.com是无法验证通过的；当然有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    // 如设置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    [securityPolicy setPinnedCertificates:setData];
    
    return securityPolicy;
}

/**
 请求头设置
 */
- (NSDictionary *)httpHeader{
    [self.manager.requestSerializer setValue:@"2" forHTTPHeaderField:@"source"];//2代表iOS
    NSString *versionStr = [[UIDevice currentDevice] systemVersion];//手机系统版本
    if (versionStr) {
        [self.manager.requestSerializer setValue:versionStr forHTTPHeaderField:@"sys_version"];
    }
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];//app版本
    if (appVersion) {
        [self.manager.requestSerializer setValue:appVersion forHTTPHeaderField:@"app_version"];
    }
    NSString *modelType = [KWIphoneModelType iphoneType];//设备型号
    if (modelType) {
        [self.manager.requestSerializer setValue:modelType forHTTPHeaderField:@"model"];
    }
    [self.manager.requestSerializer setValue:@"iPhone" forHTTPHeaderField:@"brand"];
    
    return self.manager.requestSerializer.HTTPRequestHeaders;
}


/**
 注册监听网络状态
 */
- (void)registerNetworkReachability{
    AFNetworkReachabilityManager *networkManager =  [AFNetworkReachabilityManager sharedManager];
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //发送网络状态变化的通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kAFNetworkReachability object:[NSNumber numberWithInteger:status]];
    }];
    [networkManager startMonitoring];
}

- (void)networkReachabilityStatusChanged:(NSNotification *)noti{
    NSNumber *networkStatus = noti.object;
    self.netStatus = [networkStatus integerValue];
}

/**
 发起网络请求
 
 @param url 请求地址
 @param parmaters 请求参数
 @param finishBlock 请求完成的回调
 */
- (void)requestUrl:(NSString *)url
         parmaters:(NSDictionary *)parmaters
       finishBlock:(FinishBlock)finishBlock{
    //默认需要跳转登陆
    [self requestUrl:url
           parmaters:parmaters
           needJumpLogin:YES finishBlock:finishBlock];
}

/**
 发起网络请求

 @param url 请求地址
 @param parmaters 请求参数
 @param finishBlock 请求完成的回调
 */
- (void)requestUrl:(NSString *)url
         parmaters:(NSDictionary *)parmaters
     needJumpLogin:(BOOL)needJump
       finishBlock:(FinishBlock)finishBlock{
        self.needJumpLogin = needJump;
    YWResponse *ywResponse = [[YWResponse alloc] init];
    //首先检测网络是否通畅
    if (self.netStatus > 0) {
        //为请求添加请求头
        [self httpHeader];
        //开始请求
        [self.manager POST:url parameters:parmaters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
            if ([responses respondsToSelector:@selector(statusCode)]) {
                ywResponse.statusCode = [responses statusCode];//401、403、302
            }
            
            id object;
            if([responseObject isKindOfClass:[NSData class]]) {
                object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            }else{
                object = responseObject;
            }
            DDLogInfo(@"URL==>%@, \n 请求入参：%@ \n 响应状态码：%@ \n 返回结果：%@",url, parmaters, @(ywResponse.statusCode), object);
            //返回数据处理
            [self handleResponse:ywResponse object:object];
            
            if (finishBlock) {
                finishBlock(ywResponse);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSHTTPURLResponse *responses = (NSHTTPURLResponse *)task.response;
            if ([responses respondsToSelector:@selector(statusCode)]) {
                ywResponse.statusCode = [responses statusCode];
            }
            //系统错误
            ywResponse.success = NO;
            ywResponse.showToast = YES;
            ywResponse.errorMsg = HttpErrorSystemError;
            DDLogError(@"网络结果：失败！响应状态码：%@，失败原因：%@ \n URL==>%@, \n 请求入参：%@ \n",@(ywResponse.statusCode),error,url,parmaters);
            if (finishBlock) {
                finishBlock(ywResponse);
            }
        }];
    }else{
        //网络不通
        DDLogError(@"无网络，网络请求失败，netStatus=0,请检查网络链接\n URL==>%@, \n 请求入参：%@ \n",url,parmaters);
        ywResponse.success = NO;
        ywResponse.showToast = YES;
        ywResponse.errorMsg = HttpErrorNoNet;
        ywResponse.statusCode = 999;
        if (finishBlock) {
            finishBlock(ywResponse);
        }
    }
}



/**
 同步请求
 
 @param url url
 @param parmaters parmaters description
 @param finishBlock finishBlock description
 */
- (void)synchRequestUrl:(NSString *)url
              parmaters:(NSDictionary *)parmaters
            finishBlock:(FinishBlock)finishBlock{
    //默认需要跳转登陆
    [self synchRequestUrl:url
                parmaters:parmaters
                needJumpLogin:YES
              finishBlock:finishBlock];
}
/**
 同步请求

 @param url url
 @param parmaters parmaters description
 @param finishBlock finishBlock description
 */
- (void)synchRequestUrl:(NSString *)url
              parmaters:(NSDictionary *)parmaters
          needJumpLogin:(BOOL)needJump
            finishBlock:(FinishBlock)finishBlock{
    
    self.needJumpLogin = needJump;
    YWResponse *ywResponse = [[YWResponse alloc] init];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20.f];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    //添加请求头
    request.allHTTPHeaderFields = [self httpHeader];
    NSError *error = nil;
    NSData *data = [[NSData alloc] init];
    if (parmaters) {
        data= [NSJSONSerialization dataWithJSONObject:parmaters
                                              options:NSJSONWritingPrettyPrinted error:&error];
    }
    if (data && !error) {
        [request setHTTPBody:data];
    }else{
        //入参有误
        ywResponse.success = NO;
        ywResponse.showToast = YES;
        ywResponse.errorMsg = HttpErrorSystemError;
        if (finishBlock) {
            finishBlock(ywResponse);
        }
        return;
    }
    
    //最后，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) {
        ywResponse.success = NO;
        ywResponse.showToast = YES;
        ywResponse.errorMsg = HttpErrorSystemError;
    }else{
        id object = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            ywResponse.success = NO;
            ywResponse.showToast = YES;
            ywResponse.errorMsg = HttpErrorPhaseError;
        }else{
            //返回数据处理
            [self handleResponse:ywResponse object:object];
        }
    }
    
    if (finishBlock) {
        finishBlock(ywResponse);
    }
    
}


/**
 返回数据处理

 @param ywResponse 返回实体
 @param object 服务器返回的结果
 */
- (void)handleResponse:(YWResponse *)ywResponse object:(id)object{
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSDictionary *responseDic = object;
        NSString *statusStr = [NSString stringWithFormat:@"%@",responseDic[@"status"]];
        NSString *message = [NSString stringWithFormat:@"%@",responseDic[@"message"]];
        ywResponse.errorMsg = message;
        ywResponse.errorCode = statusStr;
        ywResponse.statusCode = 777;
        if ([statusStr isEqualToString:@"000000"]) {
            //业务处理成功
            ywResponse.statusCode = 200;
            ywResponse.success = YES;
            ywResponse.responseData = [KWSafeNull safeNull:responseDic[@"data"]];
        }else if ([statusStr isEqualToString:@"000003"]){
            //token失效
            ywResponse.success = NO;
            ywResponse.statusCode = 666;
            ywResponse.tokenInvalid = YES;
            ywResponse.showToast = YES;
            ywResponse.errorMsg = @"您的会话超时，请重新登录！";
            if (self.needJumpLogin) {
                if (![NSThread isMainThread]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showLoginViewController];
                    });
                }else{
                    [self showLoginViewController];
                }
            }
        }else if ([statusStr isEqualToString:@"888888"]){
            //不需要toast提示的错误
            ywResponse.success = NO;
            ywResponse.statusCode = 555;
            ywResponse.showToast = NO;
        }else if ([statusStr isEqualToString:@"777777"]){
            //alert弹出框
            ywResponse.success = NO;
            ywResponse.statusCode = kAlertTipCode;
            ywResponse.showToast = NO;
        }else{
            //其他业务错误
            ywResponse.success = NO;
            ywResponse.statusCode = 444;
            ywResponse.showToast = YES;
            if ([statusStr isEqualToString:@"999999"] ||
                [statusStr isEqualToString:@"999998"] ||
                [statusStr isEqualToString:@"990001"]) {
                ywResponse.errorMsg = HttpErrorSystemError;
            }
        }
    }else{
        //数据返回格式异常
        ywResponse.success = NO;
        ywResponse.showToast = YES;
        ywResponse.errorMsg = HttpErrorDataFormatError;
        ywResponse.statusCode = 888;
    }
}

- (void)showLoginViewController{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        
    });
    
}


/**
 图片批量上传(并发)

 @param photos 图片数组（uiimage/nsdata）
 @param block block description
 */
- (void)uploadImages:(NSArray *)photos
          uploadPath:(NSString *)uploadPath
      completedBlock:(void(^)(BOOL succ, YWPhotoResponse *resp))block{
    
    NSMutableArray* result = [NSMutableArray array];
    for (NSInteger i=0; i < photos.count; i++) {
        [result addObject:[NSNull null]];
    }
    BOOL __block success = YES;
    dispatch_group_t group = dispatch_group_create();
    for(NSInteger i =0; i< photos.count; i++){
        dispatch_group_enter(group);
        [YWHttpEngine uploadImageWithPath:uploadPath
                                    image:photos[i]
                              finishBlock:^(YWResponse *response) {
                                  if (response.success) {
                                      @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                                          result[i] = response;
                                      }
                                      dispatch_group_leave(group);
                                  }else{
                                      DDLogDebug(@"第 %d 张图片上传失败: %@", (int)i + 1, response.errorMsg);
                                      success = NO;
                                      dispatch_group_leave(group);
                                  }
                              }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        DDLogDebug(@"上传完成!");
        if (success) {
            //把result数组取出来
            NSMutableArray *urlList = [NSMutableArray array];
            NSString *domain = @"";
            for(YWResponse *resp in result){
                if ([resp isKindOfClass:[YWResponse class]] &&
                    [resp.responseData isKindOfClass:[NSDictionary class]]) {
                    YWPhotoResponse *photoRes = [YWPhotoResponse mj_objectWithKeyValues:resp.responseData];
                    [urlList safeAddObjectsFromArray:photoRes.list];
                    if (!domain.length) {
                        domain = photoRes.domain;
                    }
                }
            }
            YWPhotoResponse *newRes = [YWPhotoResponse new];
            newRes.domain = domain;
            newRes.list = urlList;
            if (block) {
                block(YES, newRes);
            }
        }else{
            if (block) {
                block(NO, nil);
            }
        }
    });
}



/**
 *  上传图片(单张)
 *
 *  @param path    路径
 *  @param image   图片
 *  @param finishBlock 回调
 */
- (void)uploadImageWithPath:(NSString *)path
                      image:(id)image
                finishBlock:(FinishBlock)finishBlock{
    
    NSMutableArray *array = [NSMutableArray array];
    [array safeAddObject:image];
    [self uploadImageWithPath:path
                       photos:array
                  finishBlock:finishBlock];
}

/**
 *  上传图片(多张,不保证返回结果顺序)
 *
 *  @param path    路径
 *  @param photos  图片数组
 *  @param finishBlock 回调
 */
- (void)uploadImageWithPath:(NSString *)path
                     photos:(NSArray *)photos
                finishBlock:(FinishBlock)finishBlock{
    self.needJumpLogin = NO;
    YWResponse *ywResponse = [[YWResponse alloc] init];
    path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self httpHeader];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //处理耗时操作，压缩图片
        NSMutableArray *compressedDatas = [NSMutableArray array];
        for (int i = 0; i < photos.count; i ++) {
            NSData *imageData = photos[i];
            UIImage *originImage = nil;
            if ([imageData isKindOfClass:[UIImage class]]) {
                originImage = (UIImage *)imageData;
            }else {
                originImage = [UIImage imageWithData:imageData];
            }
            if (originImage.compressedData) {
                [compressedDatas safeAddObject:originImage.compressedData];
            }else {
                //压缩至100k以内
                NSData *data = [originImage compressImageToSize:CGSizeMake(720, 1080)];
                [compressedDatas safeAddObject:data];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.manager POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                for (int i = 0; i < compressedDatas.count; i ++) {
                    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                    formatter.dateFormat=@"yyyyMMddHHmmss";
                    NSString *str=[formatter stringFromDate:[NSDate date]];
                    NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
                    NSData *imageData = compressedDatas[i];
                    [formData appendPartWithFileData:imageData
                                                name:@"pictureFiles"
                                            fileName:fileName
                                            mimeType:@"image/jpeg"];
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                DDLogDebug(@"uploadProgress is %lld,总字节 is %lld",uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self handleResponse:ywResponse object:responseObject];
                if (finishBlock) {
                    finishBlock(ywResponse);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //系统错误
                ywResponse.success = NO;
                ywResponse.showToast = YES;
                ywResponse.errorMsg = HttpErrorSystemError;
                if (finishBlock) {
                    finishBlock(ywResponse);
                }
            }];
        });
    });
}


@end
