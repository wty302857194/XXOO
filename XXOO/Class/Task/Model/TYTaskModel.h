//
//  TYTaskModel.h
//  XXOO
//
//  Created by wbb on 2019/4/20.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TYBaseModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface TYTaskModel : TYBaseModel

@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * orderBy;
@property (nonatomic, copy) NSString * score;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * title;

@end

NS_ASSUME_NONNULL_END
