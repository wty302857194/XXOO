//
//  TYSaveCodeViewController.h
//  XXOO
//
//  Created by wbb on 2019/4/27.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^SaveSuccessBlock)(void);
@interface TYSaveCodeViewController : TYBaseViewController
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) SaveSuccessBlock saveSuccessBlock;
@end

NS_ASSUME_NONNULL_END
