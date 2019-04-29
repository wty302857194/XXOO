//
//  TYDuiHuanSecondTableViewCell.h
//  XXOO
//
//  Created by wbb on 2019/4/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYDuiHuanModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^DuiHuanBlock)(void);
@interface TYDuiHuanSecondTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *longTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *jiFenLAB;
@property (weak, nonatomic) IBOutlet UIButton *duiHuanBtn;

@property (nonatomic, copy) DuiHuanBlock duiHuanBlock;
@property (nonatomic, strong) TYDuiHuanModel * model;
@end

NS_ASSUME_NONNULL_END
