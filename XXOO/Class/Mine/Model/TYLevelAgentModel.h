//
//  TYLevelAgentModel.h
//  XXOO
//
//  Created by wbb on 2019/5/4.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 agentRatio: null,                        //返利比例
 createTime: "2019-04-19 17:33:03",      //加入时间
 id: 2,                                  //ID
 name: "246093",                        //名称
 spreadNum: 0                          //推广人数
 }
 */
@interface TYLevelAgentModel : TYBaseModel

@property (nonatomic, copy) NSString * agentRatio;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * spreadNum;
@end

NS_ASSUME_NONNULL_END
