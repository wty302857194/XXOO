//
//  TYGlobal.m
//  XXOO
//
//  Created by wbb on 2019/4/28.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYGlobal.h"
#import "HDeviceIdentifier.h"

@implementation TYGlobal
+ (NSString *)getDeviceIdentifier {
    NSString *deviceIdentifier = [USER_DEFAULTS objectForKey:@"deviceIdentifier"];
    if (!deviceIdentifier) {
        NSString *identifier = [HDeviceIdentifier deviceIdentifier];
        [USER_DEFAULTS setObject:identifier forKey:@"deviceIdentifier"];
        [USER_DEFAULTS synchronize];
    }
    return deviceIdentifier?:@"";
}
+ (NSDictionary *)userMessage {
    NSDictionary *dic = [USER_DEFAULTS objectForKey:USERMESSAGE];
    if (dic) {
        return dic;
    }else {
        return nil;
    }
    
}
+ (NSString *)userId {
    NSDictionary *dic = [self userMessage];
    if (dic) {
        return dic[@"id"];
    }else {
        return @"";
    }
}
+ (NSString *)gesturePassword {
    NSString *str = [USER_DEFAULTS objectForKey:GESTURE_PASSWORD];
    if (str&&str.length>0) {
        return str;
    }else {
        return @"";
    }
}
+ (BOOL )gestureIsOpen {
    BOOL isOpen = [USER_DEFAULTS boolForKey:GESTURE_OPIN];
    return isOpen;
}
// 用户 手势密码
+ (NSString *)userEmail {
    NSString *str = [USER_DEFAULTS objectForKey:USER_EMAIL];
    if (str&&str.length>0) {
        return str;
    }else {
        return @"";
    }
}
+ (void)openScheme:(NSString *)scheme {
    scheme = [self convertToURLFormatWithString:scheme];
    scheme = [self removeSpaceAndNewline:scheme];
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:scheme];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:URL options:@{}
           completionHandler:^(BOOL success) {
               NSLog(@"Open %@: %d",scheme,success);
           }];
    } else {
        BOOL success = [application openURL:URL];
        NSLog(@"Open %@: %d",scheme,success);
    }
}
/**
 * 把string转换成可以URL跳转的类型（指的是带HTTP或者HTTPS）
 */
+ (NSString *)convertToURLFormatWithString:(NSString *)str {
    if ([str containsString:@"http"] || [str containsString:@"https"]) {
        return str;
    }else {
        NSMutableString *strM = [NSMutableString stringWithString:str];
        [strM insertString:@"http://" atIndex:0];
        return strM.copy;
    }
}
// 1.去除字符串首尾的空格和换行符
+ (NSString *)removeSpaceAndNewline:(NSString *)str {
    NSString *temp = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *text = [temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    return text;
    
}

//判断邮箱格式是否正确的代码：
//利用正则表达式验证
+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:email];
}
+ (BOOL)deptIdInputShouldAlphaNum:(NSString *)password {
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:password]) {
        return YES;
    }
    return NO;
    
}
/** 银行卡号有效性问题Luhn算法
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
+ (BOOL)isBankCardNumber:(NSString *)cardNum {
    
    NSString * lastNum = [[cardNum substringFromIndex:(cardNum.length-1)] copy];//取出最后一位
    NSString * forwardNum = [[cardNum substringToIndex:(cardNum.length -1)] copy];//前15或18位
    
    NSMutableArray * forwardArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i=0; i<forwardNum.length; i++) {
        NSString * subStr = [forwardNum substringWithRange:NSMakeRange(i, 1)];
        [forwardArr addObject:subStr];
    }
    
    NSMutableArray * forwardDescArr = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = (int)(forwardArr.count-1); i> -1; i--) {//前15位或者前18位倒序存进数组
        [forwardDescArr addObject:forwardArr[i]];
    }
    
    NSMutableArray * arrOddNum = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 < 9
    NSMutableArray * arrOddNum2 = [[NSMutableArray alloc] initWithCapacity:0];//奇数位*2的积 > 9
    NSMutableArray * arrEvenNum = [[NSMutableArray alloc] initWithCapacity:0];//偶数位数组
    
    for (int i=0; i< forwardDescArr.count; i++) {
        NSInteger num = [forwardDescArr[i] intValue];
        if (i%2) {//偶数位
            [arrEvenNum addObject:[NSNumber numberWithInteger:num]];
        }else{//奇数位
            if (num * 2 < 9) {
                [arrOddNum addObject:[NSNumber numberWithInteger:num * 2]];
            }else{
                NSInteger decadeNum = (num * 2) / 10;
                NSInteger unitNum = (num * 2) % 10;
                [arrOddNum2 addObject:[NSNumber numberWithInteger:unitNum]];
                [arrOddNum2 addObject:[NSNumber numberWithInteger:decadeNum]];
            }
        }
    }
    
    __block  NSInteger sumOddNumTotal = 0;
    [arrOddNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNumTotal += [obj integerValue];
    }];
    
    __block NSInteger sumOddNum2Total = 0;
    [arrOddNum2 enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumOddNum2Total += [obj integerValue];
    }];
    
    __block NSInteger sumEvenNumTotal =0 ;
    [arrEvenNum enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL *stop) {
        sumEvenNumTotal += [obj integerValue];
    }];
    
    NSInteger lastNumber = [lastNum integerValue];
    
    NSInteger luhmTotal = lastNumber + sumEvenNumTotal + sumOddNum2Total + sumOddNumTotal;
    
    return (luhmTotal%10 ==0)?YES:NO;
}
@end
