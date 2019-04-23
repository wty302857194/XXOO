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

@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * linkUrl;
@property (nonatomic, copy) NSString  * picUrl;
@property (nonatomic, copy) NSString * position;
@property (nonatomic, copy) NSString * showTime;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * state;
@end

NS_ASSUME_NONNULL_END
