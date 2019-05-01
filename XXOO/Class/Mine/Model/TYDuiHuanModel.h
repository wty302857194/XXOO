//
//  TYDuiHuanModel.h
//  XXOO
//
//  Created by wbb on 2019/4/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 createTime: "2019-04-03 10:29:49",    //创建时间
 describe: "1",                        //描述
 id: 1,                                //兑换id
 icon:"sign.png",                      //图标
 membershipDuration: 1,                //会员期限时长
 orderBy: 1,                           //排序
 score: 133                            //所需积分
 }
 */
@interface TYDuiHuanModel : TYBaseModel
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * describe;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * membershipDuration;
@property (nonatomic, copy) NSString * orderBy;
@property (nonatomic, copy) NSString * score;
@property (nonatomic, copy) NSString * ID;
@end

NS_ASSUME_NONNULL_END
