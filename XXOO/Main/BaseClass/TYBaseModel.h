//
//  TYBaseModel.h
//  XXOO
//
//  Created by wbb on 2019/4/20.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYBaseModel : NSObject
// 传入字符串，用户ID
+ (instancetype)objectWithStringValue:(NSString *)stringValue;
@end

NS_ASSUME_NONNULL_END
