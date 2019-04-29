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
@end

NS_ASSUME_NONNULL_END
