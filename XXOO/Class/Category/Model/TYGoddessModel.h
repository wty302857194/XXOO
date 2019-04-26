//
//  TYGoddessModel.h
//  XXOO
//
//  Created by wbb on 2019/4/25.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 content: "A",        //内容
 id: 12,             //ID
 title: "女优分类",  //说明
 type: 3           //女优类型
 }
 */
@interface TYGoddessModel : TYBaseModel

@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * ID;

@end

NS_ASSUME_NONNULL_END
