//
//  TYVideoLabelModel.h
//  XXOO
//
//  Created by wbb on 2019/4/26.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 createTime: "2019-04-20 17:35:35",  //创建时间
 id: 1,                             //ID
 label: "1",                       //标签名
 level: 2,                        //等级（1 1级  2 2级）
 tid: 1                          //上级id
 }
 */
@interface TYVideoLabelModel : TYBaseModel
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * label;
@property (nonatomic, copy) NSString * level;
@property (nonatomic, copy) NSString * tid;
@property (nonatomic, copy) NSString * ID;

@end

NS_ASSUME_NONNULL_END
