//
//  TYBaseModel.m
//  XXOO
//
//  Created by wbb on 2019/4/20.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

@implementation TYBaseModel
+ (instancetype)objectWithStringValue:(NSString *)stringValue {
    
    return nil;
}
// oc中关键字id替换ID
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
@end
