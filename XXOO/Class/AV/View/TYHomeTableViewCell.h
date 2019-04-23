//
//  TYHomeTableViewCell.h
//  XXOO
//
//  Created by wbb on 2019/4/12.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYHomeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic, strong) TYHomeItemModel * itemModel;
@end

NS_ASSUME_NONNULL_END
