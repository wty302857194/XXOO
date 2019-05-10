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
/*
 {
 content = "\U52a0\U5165\U4e07\U4eba\U4ea4\U6d41\U7fa4\Uff0c\U53ef\U83b7\U5f97\U610f\U5916\U60ca\U559c\Uff0c\U5927\U91cf\U79ef\U5206\Uff0c\U514d\U8d39VIP\U7b49\U4f60\U6765\U62ff";
 createTime = "2019-04-22 13:47:36";
 icon = "joinGroup.png";
 id = 3;
 orderBy = 3;
 score = 200;
 state = 1;
 title = "\U52a0\U7fa4\U6709\U798f\U5229";
 adUrl:null    //下载链接
 }
 */
@interface TYTaskModel : TYBaseModel

@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * orderBy;
@property (nonatomic, copy) NSString * score;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * icon;
@property (nonatomic, copy) NSString * btnContent;
@property (nonatomic, copy) NSString * adUrl;

@end

NS_ASSUME_NONNULL_END
