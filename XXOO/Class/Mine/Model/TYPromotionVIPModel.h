//
//  TYPromotionVIPModel.h
//  XXOO
//
//  Created by wbb on 2019/5/7.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 "btn": "1",                             //展示字样
 "createTime": "2019-04-23 21:46:34",    //创建时间
 "describe": "1",                        //描述
 "favorableDays": 1,                     //优惠天数
 "icon": "1",                            //图标
 "id": 1,                                //id
 "memberDays": 1,                        //会员天数
 "money": 1,                             //支付金额
 "state": "1",                           //状态（1上线 2下线）
 "title": "1",                           //标题
 "type": "1"                             //货币类型（1人民币 2台币）
 }
 */
@interface TYPromotionVIPModel : TYBaseModel

@property (nonatomic, copy) NSString * btn;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * describe;
@property (nonatomic, copy) NSString * favorableDays;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * memberDays;
@property (nonatomic, copy) NSString * money;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * type;

@end

NS_ASSUME_NONNULL_END
