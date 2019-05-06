//
//  TYTuiGuangEmptyView.h
//  XXOO
//
//  Created by wbb on 2019/5/5.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TuiGuangBlcok)(void);
@interface TYTuiGuangEmptyView : TYBaseView
@property (nonatomic, copy) TuiGuangBlcok tuiGuangBlcok;
@end

NS_ASSUME_NONNULL_END
