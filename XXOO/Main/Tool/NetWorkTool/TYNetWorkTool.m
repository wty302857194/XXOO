//
//  TYNetWorkTool.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYNetWorkTool.h"
@interface AFNetworkClient : AFHTTPSessionManager
//@property (nonatomic, assign) BOOL isURL;
//@property (nonatomic, copy) NSString * urlString;
+ (instancetype)sharedClient;

@end
@implementation AFNetworkClient

+ (instancetype)sharedClient
{
    static AFNetworkClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [AFNetworkClient manager];
        // 设置请求接口回来的时候支持什么类型的数据
        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html",nil];
        
        [_sharedClient.requestSerializer setValue:@"5" forHTTPHeaderField:@"Client-Type"];
        
    });
    
    return _sharedClient;
}

@end

@implementation TYNetWorkTool
//判断此路径是否能够请求成功,直接进行HTTP请求
//+ (void)urliSAvailable:(NSString *)urlStr{
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
//    [request setHTTPMethod:@"HEAD"];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (error) {
//            NSLog(@"不可用");
//            [AFNetworkClient sharedClient].isURL = NO;
//        }else{
//            NSLog(@"可用");
//            [AFNetworkClient sharedClient].isURL = YES;
//        }
//    }];
//    [task resume];
//
//    NSLog(@"底部");
//}
//+ (NSString *)verificationUrl:(NSString *)URLStr {
//    do {
//        [self urliSAvailable:URLStr];
//    } while ([AFNetworkClient sharedClient].isURL);
//    return URLStr;
//}
/**
 *  post请求
 *
 *  @param url          链接
 *  @param parameters   参数
 *  @param successBlock 成功block
 *  @param failureBlock 失败block
 */
+(void)postRequest:(NSString*)url parameters:(NSDictionary *)parameters successBlock:(void (^)(BOOL success,id data,NSString* msg))successBlock failureBlock:(void (^)(NSString* description))failureBlock{
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",URL_main,url];
    
    
    
    NSMutableDictionary *mutableParams = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary nullDic:parameters?:@{}]];

    [[AFNetworkClient sharedClient] POST:URLStr parameters:mutableParams progress:^(NSProgress * _Nonnull uploadProgress) {
        //进度
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            // 开始验签
            NSDictionary *dict = [NSDictionary nullDic:responseObject];
            if (dict[@"responseCode"]&&[dict[@"responseCode"] isEqualToString:@"0000"]) {
                
                successBlock(YES, dict[@"info"]?:@{}, dict[@"responseMsg"]);
            }else {
                successBlock(NO,nil,responseObject[@"responseMsg"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(error.localizedDescription);
        
    }];
    
}

/**
 *  get请求
 *
 *  @param url          链接
 *  @param parameters   参数
 *  @param successBlock 成功block
 *  @param failureBlock 失败block
 */
+ (void)getRequest:(NSString*)url parameters:(NSDictionary *)parameters successBlock:(void (^)(BOOL success,NSDictionary *data,NSString* msg))successBlock failureBlock:(void (^)(NSString* description))failureBlock
{
    
    [[AFNetworkClient sharedClient] GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        //进度
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            // 开始验签
            NSDictionary *dict = [NSDictionary nullDic:responseObject];
            if ([dict[@"responseCode"] isEqualToString:@"0000"]) {
                successBlock(YES, dict[@"info"], dict[@"responseMsg"]);
            }else {
                successBlock(NO,nil,responseObject[@"msg"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(error.localizedDescription);
        
    }];
    
}

+ (void)uploadFileWithOption:(NSDictionary *)paramDic
              withRequestURL:(NSString*)requestURL
                   dataArray:(NSMutableArray *)dataArray
                    dataName:(NSMutableArray *)dataName
                     dataKey:(NSMutableArray *)dataKey
             downloadSuccess:(void (^)(id responseObject))success
             downloadFailure:(void (^)(NSError *error))failure
                    progress:(void (^)(float progress))progress

{
    
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSMutableDictionary *mulParameters = [NSMutableDictionary dictionaryWithDictionary:paramDic];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",URL_main,requestURL];

    [manager POST:URLStr parameters:mulParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //上传文件参数
        
        if (dataArray.count > 0) {
            
            [dataArray enumerateObjectsUsingBlock:^(NSData *imageData, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                formatter.dateFormat=@"yyyyMMddHHmmss";
                NSString *str=[formatter stringFromDate:[NSDate date]];
                NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
                
                [formData appendPartWithFileData:imageData name:dataKey[idx] fileName:fileName mimeType:@"image/png"];
                
            }];
            
            
        }
        
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(1.0*uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *weatherDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([[weatherDic objectForKey:@"code"] integerValue] == 0) {
            
            //请求成功
            success(weatherDic);
            
        }else{
            
            NSError *error = nil;
            
            failure(error);
            //            [ZJPublicClass textBouncedWithMessage:[weatherDic objectForKey:@"msg"]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //请求失败
        failure(error);
        
    }];
    
}

+ (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(id responseObject))success
               downloadFailure:(void (^)(NSError *error))failure
                      progress:(void (^)(float progress))progress

{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    requestURL = [requestURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];;
    
    //savedPath = [NSString stringWithFormat:@"file://%@",[NSHomeDirectory() stringByAppendingString:@"/Documents/test.xlsx"]];
    
    //2.确定请求的URL地址
    NSURL *url = [NSURL URLWithString:requestURL];
    
    //3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //加载进度
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载存放地址，要返回存放地址(存放地址前面加file://)
        
        return [NSURL URLWithString:savedPath];
        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        success(response);
        // 下载完成之后，解压缩文件
        
    }];
    [task resume];
    
}


@end
