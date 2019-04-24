//
//  TYHotSearchModel.h
//  XXOO
//
//  Created by wbb on 2019/4/24.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
/*
 {
 createTime: null,  //
 title: null,      // 标题
 hot: 2,            //
 id: 22691        //视频id
 }
 */
@interface TYHotSearchModel : TYBaseModel
@property (nonatomic, copy) NSString * createTime;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * hot;
@property (nonatomic, copy) NSString * ID;
@end

NS_ASSUME_NONNULL_END
