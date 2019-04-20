//
//  TYTaskTableViewCell.h
//  XXOO
//
//  Created by wbb on 2019/4/12.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TYTaskModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^GoPlanBlock)(void);
@interface TYTaskTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *planBtn;
@property (weak, nonatomic) IBOutlet UILabel *jiFenLab;

@property (nonatomic, copy) GoPlanBlock goPlanBlock;

@property (nonatomic, strong) TYTaskModel * taskModel;
@end

NS_ASSUME_NONNULL_END
