//
//  TYEmailTableViewController.h
//  XXOO
//
//  Created by wbb on 2019/4/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseTableViewController.h"

typedef void(^EmailBlock)(NSString * _Nullable email);
NS_ASSUME_NONNULL_BEGIN

@interface TYEmailTableViewController : TYBaseTableViewController
@property (nonatomic, copy) EmailBlock emailBlock;
@end

NS_ASSUME_NONNULL_END
