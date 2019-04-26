//
//  TYVideoTypeListModel.h
//  XXOO
//
//  Created by wbb on 2019/4/24.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 content: "无码",     //内容
 id: 10,             //ID
 title: "影片片种",   //说明
 type: 2             //类型
 }
 */
@interface TYVideoTypeListModel : TYBaseModel
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * ID;
@end

NS_ASSUME_NONNULL_END
