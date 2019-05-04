//
//  TYActorModel.h
//  XXOO
//
//  Created by wbb on 2019/4/25.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {code: 0,condition: null,count: 1,data: [{
 avatar: "1",                         //封面
 birthAdress: "1",                    //出生地址
 birthDay: "1",                        //出生日期
 click: 1,                            //点击量
 createTime: "2019-04-20 17:13:07",    //发布时间
 cup: "1",                            //罩杯
 cupId: "1",                            //分类id
 describe: "1",                        //描述
 height: "1",                        //身高
 id: 1,                                //ID
 interest: "1",                        //兴趣
 measurement: "1",                    //三围
 modifyTime: null,                    //
 name: "1",                            //名字
 worksNum: 1                            //作品数量
 }],from: 0,msg: "",nowpage: 1,order: null,pagesize: 10,size: 0,sort: "seq"
 }
 */
@interface TYActorModel : TYBaseModel
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * condition;
@property (nonatomic, copy) NSString * count;
@property (nonatomic, copy) NSArray  * data;
@property (nonatomic, copy) NSString * from;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSString * nowpage;
@property (nonatomic, copy) NSString * order;
@property (nonatomic, copy) NSString * pagesize;
@property (nonatomic, copy) NSString * size;
@property (nonatomic, copy) NSString * sort;
@end

@interface TYActorListModel : TYBaseModel

@property (nonatomic, copy) NSString * avatar;
@property (nonatomic, copy) NSString * birthAdress;
@property (nonatomic, copy) NSString * birthDay;
@property (nonatomic, copy) NSString  * click;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * cup;
@property (nonatomic, copy) NSString * cupId;
@property (nonatomic, copy) NSString * describe;
@property (nonatomic, copy) NSString * height;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * interest;
@property (nonatomic, copy) NSString * measurement;
@property (nonatomic, copy) NSString * modifyTime;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * worksNum;
@end
NS_ASSUME_NONNULL_END
