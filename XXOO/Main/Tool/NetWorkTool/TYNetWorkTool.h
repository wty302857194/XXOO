//
//  TYNetWorkTool.h
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYNetWorkTool : NSObject

//post请求
+(void)postRequest:(NSString*)url parameters:(NSDictionary *)parameters successBlock:(void (^)(BOOL success,id data,NSString* msg))successBlock failureBlock:(void (^)(NSString* description))failureBlock;

//get请求
+(void)getRequest:(NSString*)url parameters:(NSDictionary *)parameters successBlock:(void (^)(BOOL success,NSDictionary *data,NSString* msg))successBlock failureBlock:(void (^)(NSString* description))failureBlock;

/**
 *  上传文件
 *
 *  @param paramDic   传参
 *  @param requestURL 链接
 *  @param dataArray  图片date数组
 *  @param dataName   图片名字
 *  @param dataKey    图片key
 *  @param success    失败回调
 *  @param failure    失败回调
 *  @param progress   上传进度
 */
+ (void)uploadFileWithOption:(NSDictionary *)paramDic
              withRequestURL:(NSString*)requestURL
                   dataArray:(NSMutableArray *)dataArray
                    dataName:(NSMutableArray *)dataName
                     dataKey:(NSMutableArray *)dataKey
             downloadSuccess:(void (^)(id responseObject))success
             downloadFailure:(void (^)(NSError *error))failure
                    progress:(void (^)(float progress))progress;


+ (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(id responseObject))success
               downloadFailure:(void (^)(NSError *error))failure
                      progress:(void (^)(float progress))progress;

@end

NS_ASSUME_NONNULL_END
