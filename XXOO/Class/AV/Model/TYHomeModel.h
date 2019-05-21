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

/*
 {
 "content": "皇子彻夜啼哭，",                                                        //视频内容
 "cover": "http://pic.youku778.com/upload/vod/2019-04-16/201904161555394820.png",  //封面
 "createTime": "2019-04-22 14:22:44",                                              //上传时间
 "id": 22673,                                                                      //id
 "timeLong": "150",                                                                //时长
 "title": "隐天子之大话江湖"                                                         //标题
 }
 
 
 
 {
 "click":2,                        //点击量
 "createTime": "2019-05-19 05:05:23",    //更新时间
 "cover": " ",                    //封面
 "cstate": 0,                    //是否收藏（0否1是）
 "id": 21934,                    //视频id
 "icon": "限免",                 //是否限免（ 图标  是    null 不是）
 "latest": "最新",                    //是否最新（ 图标 是 " "不是）
 "timeLong": "150",                //视频时长
 "title": " ",                    //标题
 "vUrl": " "                        //播放地址
 }
 */
@interface TYHomeItemModel : TYBaseModel
@property (nonatomic, copy) NSString * latest;

@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * cstate; //是否收藏（0否1是）
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
