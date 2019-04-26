//
//  TYCategroyListModel.h
//  XXOO
//
//  Created by wbb on 2019/4/24.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 cover = "";
 createTime = "";
 homePage = "";
 id = "";
 modifyTime = "";
 name = "\U5168\U90e8";
 orderBy = "";
 state = "";
 }
 */
@interface TYCategroyListModel : TYBaseModel

@property (nonatomic, copy) NSString * cover;
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * homePage;
@property (nonatomic, copy) NSString * modifyTime;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * orderBy;
@property (nonatomic, copy) NSString * state;
@property (nonatomic, copy) NSString * ID;

@end

NS_ASSUME_NONNULL_END
