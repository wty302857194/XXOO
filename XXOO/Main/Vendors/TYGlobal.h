//
//  TYGlobal.h
//  XXOO
//
//  Created by wbb on 2019/4/28.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYGlobal : NSObject
//手机id
+ (NSString *)getDeviceIdentifier;
// 用户信息
+ (NSDictionary *)userMessage;
// 用户id
+ (NSString *)userId;
// 打开URL
+ (void)openScheme:(NSString *)scheme;
// 用户 手势密码
+ (NSString *)gesturePassword;
// 用户 手势密码
+ (NSString *)userEmail;

//判断邮箱格式是否正确的代码：
//利用正则表达式验证
+(BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)deptIdInputShouldAlphaNum:(NSString *)password ;
@end

NS_ASSUME_NONNULL_END
