//
//  TYAVDetailModel.h
//  XXOO
//
//  Created by wbb on 2019/4/23.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 "limitTime": "true",        //是否限制时长（true 是   false 否）
 "times": "3",                //限时时长 时间/分钟
 "responseCode": "0000",
 "responseMsg": "success",
 "info": {
 click: "45933",                             //点击量
 content: "第一季里邀请大学同学的李",           //描述
 cover: "http://pic.you3559813.png",         //封面
 createTime: null,                           //添加时间
 hot: "1",                                   //是否热搜
 id: 21933,                                  //ID
 modifyTime: null,                               //
 timeLong: "150"    ,                         //时长（分钟）
 title: "加油吧威基基2",                       //标题
 vActor: "李伊庚,金善浩,申譞洙,文佳煐",         //演员列表
 vClass: "动作片",                            //视频分类
 vCode: "有码",                               //视频片种
 vLabel: "标签1,标签2,标签3,标签4",            //标签
 vNumber: "FAT-150",                         //番号
 vUrl: "https://ddppnew1.13vdab/index.m3u8"  //播放地址
 }
 }
 
 */
@interface TYAVDetailModel : TYBaseModel

@property (nonatomic, assign) BOOL  limitTime;
@property (nonatomic, copy) NSString * times;
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
@property (nonatomic, copy) NSString * free;
@property (nonatomic, copy) NSString * level;

@end

NS_ASSUME_NONNULL_END
