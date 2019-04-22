//
//  TYEntertainmentModel.m
//  XXOO
//
//  Created by wbb on 2019/4/22.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYEntertainmentModel.h"

@implementation TYEntertainmentModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [TYEntertainmentItemModel class]};
}
@end

@implementation TYEntertainmentItemModel
@end
