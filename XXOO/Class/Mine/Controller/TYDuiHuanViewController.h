//
//  TYDuiHuanViewController.h
//  XXOO
//
//  Created by wbb on 2019/4/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^RefreshBlock)(void);
@interface TYDuiHuanViewController : TYBaseViewController
@property (nonatomic, copy) RefreshBlock refreshBlock;
@end

NS_ASSUME_NONNULL_END
