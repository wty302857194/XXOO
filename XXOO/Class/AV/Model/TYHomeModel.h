//
//  TYHomeModel.h
//  XXOO
//
//  Created by wbb on 2019/4/22.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYHomeModel : TYBaseModel

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


@interface TYHomeItemModel : TYBaseModel

@property (nonatomic, copy) NSString * click;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * hot;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * modifyTime;
@property (nonatomic, copy) NSString * timeLong;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * vActor;
@property (nonatomic, copy) NSString * vClass;
@property (nonatomic, copy) NSString * vCode;
@property (nonatomic, copy) NSString * vLabel;
@property (nonatomic, copy) NSString * vNumber;
@property (nonatomic, copy) NSString * vUrl;
@end

NS_ASSUME_NONNULL_END
