//
//  TYAVHomeViewController.h
//  XXOO
//
//  Created by wbb on 2019/4/11.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYAVHomeViewController : TYBaseViewController

@property (nonatomic, copy) NSString * vClass;

//首页初始化
- (void)headerRefreshRequest;

@end

NS_ASSUME_NONNULL_END
