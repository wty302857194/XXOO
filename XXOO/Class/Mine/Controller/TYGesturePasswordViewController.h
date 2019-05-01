//
//  TYGesturePasswordViewController.h
//  XXOO
//
//  Created by wbb on 2019/5/1.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^PasswordBlock)(void);
@interface TYGesturePasswordViewController : TYBaseViewController
@property (nonatomic, copy) PasswordBlock passwordBlock;
@end

NS_ASSUME_NONNULL_END
