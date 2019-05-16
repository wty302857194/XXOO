//
//  TYAVCategaryModel.h
//  XXOO
//
//  Created by wbb on 2019/5/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 cover: "1",                            //图标
 createTime: "2019-04-20 17:30:00",    //创建时间
 homePage: 1,                         //是否主页 1是 2不是
 id: 1,                              //ID
 modifyTime: null,                  //
 name: "1",                        //名称
 orderBy: 1                       //排序
 }
 */
@interface TYAVCategaryModel : TYBaseModel
@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * homePage;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * modifyTime;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * orderBy;
@end

NS_ASSUME_NONNULL_END
