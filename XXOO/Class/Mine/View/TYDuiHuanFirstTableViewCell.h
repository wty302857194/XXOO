//
//  TYDuiHuanFirstTableViewCell.h
//  XXOO
//
//  Created by wbb on 2019/4/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^CellBackBlock)(NSInteger index);
@interface TYDuiHuanFirstTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (nonatomic, copy) CellBackBlock cellBackBlock;
@end

NS_ASSUME_NONNULL_END
