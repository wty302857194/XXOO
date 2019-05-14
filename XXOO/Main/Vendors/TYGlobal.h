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
// 是否打开手势密码开关
+ (BOOL )gestureIsOpen;
// 用户 邮箱
+ (NSString *)userEmail;

//判断邮箱格式是否正确的代码：
//利用正则表达式验证
+(BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)deptIdInputShouldAlphaNum:(NSString *)password ;

/** 银行卡号有效性问题Luhn算法
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
+ (BOOL)isBankCardNumber:(NSString *)cardNum;
@end

NS_ASSUME_NONNULL_END
