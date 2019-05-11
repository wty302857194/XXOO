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

@end
