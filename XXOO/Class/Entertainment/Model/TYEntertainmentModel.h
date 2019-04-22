//
//  TYEntertainmentModel.h
//  XXOO
//
//  Created by wbb on 2019/4/22.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYEntertainmentModel : TYBaseModel

@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * condition;
@property (nonatomic, copy) NSString * count;
@property (nonatomic, copy) NSArray  * data;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSString * nowpage;
@property (nonatomic, copy) NSString * order;
@property (nonatomic, copy) NSString * pagesize;
@property (nonatomic, copy) NSString * size;
@property (nonatomic, copy) NSString * sort;
@end


@interface TYEntertainmentItemModel : TYBaseModel

@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * condition;
@property (nonatomic, copy) NSString * count;
@property (nonatomic, copy) NSArray  * data;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSString * nowpage;
@property (nonatomic, copy) NSString * order;
@property (nonatomic, copy) NSString * pagesize;
@property (nonatomic, copy) NSString * size;
@property (nonatomic, copy) NSString * sort;
@end

NS_ASSUME_NONNULL_END
