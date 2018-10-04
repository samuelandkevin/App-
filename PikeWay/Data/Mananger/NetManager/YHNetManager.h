//
//  YHNetManager.h
//  PikeWay
//
//  Created by kun on 14-3-24.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"


@interface YHNetManager : NSObject

@property (nonatomic,assign)YHNetworkStatus currentNetWorkStatus;
@property (nonatomic,strong)AFHTTPSessionManager *requestManager;


+ (YHNetManager*)sharedInstance;

/**
 *  取消所有请求
 */
- (void)cancelAllRequest;
/**
 *  取消当个请求
 *
 *  @param url URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
- (void)cancelRequestWithURL:(NSString *)url;


#pragma mark - 网络状态监听
- (void)startMonitoring;
- (void)netWorkStatusChange:(YHNetWorkStatusChange)netWorkStatusChange;

#pragma mark - Public

//get请求
- (void)getWithRequestUrl:(NSString *)requestUrl parameters:(NSDictionary*)parameters complete:(NetManagerCallback)complete progress:(void(^)(NSProgress *downloadProgress))progress;

//post请求
- (void)postWithRequestUrl:(NSString *)requestUrl parameters:(NSDictionary*)parameters complete:(NetManagerCallback)complete progress:(void(^)(NSProgress *uploadProgress))progress;

//delete请求
- (void)deleteWithRequestUrl:(NSString *)requestUrl parameters:(NSDictionary*)parameters complete:(NetManagerCallback)complete;

//put请求
- (void)putWithRequestUrl:(NSString *)requestUrl parameters:(NSDictionary*)parameters complete:(NetManagerCallback)complete;

//上传图片请求
- (void)uploadWithRequestUrl:(NSString *)url parameters:(NSDictionary *)parameters imageArray:(NSArray <UIImage *>*)imageArray fileNames:(NSArray< NSString *>*)fileNames name:(NSString *)name mimeType:(NSString *)mimeType  progress:(YHUploadProgress)progress complete:(NetManagerCallback)complete;

//上传文件请求
- (void)uploadWithRequestUrl:(NSString *)url parameters:(NSDictionary *)parameters filePath:(NSString *)filePath name:(NSString *)name mimeType:(NSString *)mimeType progress:(YHUploadProgress)progress complete:(NetManagerCallback)complete;

//下载请求(带有缓存)
- (void)downLoadWithRequestUrl:(NSString *)requestUrl saveInDir:(NSString *)saveInDir saveFileName:(NSString *)saveFileName complete:(NetManagerCallback)complete progress:(void(^)(NSProgress *downloadProgress))progress;

//是否可以解析服务器返回的数据
- (BOOL)canParseResponseObject:(NSData *)responseObject jsonObj:(NSDictionary **)jsonObj requestUrl:(NSString *)requestUrl;

//该协议请求是否成功
- (BOOL)isRequestSuccessWithJsonObj:(NSDictionary *)jsonObj;

//打印请求路径
- (NSString *)requestPathWithUrl:(NSString *)Url params:(NSDictionary *)params protocolName:(NSString *)protocolName;


@end
