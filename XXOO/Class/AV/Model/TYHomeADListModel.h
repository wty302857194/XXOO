//
//  TYHomeADListModel.h
//  XXOO
//
//  Created by wbb on 2019/5/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 { "createTime": "2019-04-22 21:02:48",    //上线时间
 "id": 2,                                //id
 "linkUrl": "https://www.baidu.com/",    //链接地址
 "picUrl": " ",                    //            图片
 "position": 2,                    //
 "positionName": "最新",            //
 "showTime": null,                //
 "state": 1,                        //        状态（1上线 2下线）
 "title": "棋牌游戏"                //        标题
 }
 */
@interface TYHomeADListModel : TYBaseModel
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * linkUrl;
@property (nonatomic, copy) NSString * picUrl;
@property (nonatomic, copy) NSString * position;
@property (nonatomic, copy) NSString * positionName;
@property (nonatomic, copy) NSString * showTime;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * title;

@end

NS_ASSUME_NONNULL_END
