//
//  TYAVHistoryModel.h
//  XXOO
//
//  Created by wbb on 2019/5/1.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 cover: "1",
 createTime: "2019-04-20 11:10:14",
 id: 1,
 longTimes: "1",
 tid: 1,
 title: "1",
 uid: 2
 }
 
 //我的收藏  //数据格式一样
 
 
 {                    //返回数据
 cover: "1",                           //封面、头像
 createTime: "2019-04-20 11:10:14",    //收藏时间
 id: 1,                                //ID
 longTimes: "1",                       //时长
 tid: 1,                               //视频、女优  id
 title: "1",                           //标题、名字
 type: 1,                              //类型（1AV 2女优）
 uid: 2                                //用户id
 }
 */
@interface TYAVHistoryModel : TYBaseModel
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * longTimes;
@property (nonatomic, copy) NSString * tid;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * uid;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * type;
@end

NS_ASSUME_NONNULL_END
