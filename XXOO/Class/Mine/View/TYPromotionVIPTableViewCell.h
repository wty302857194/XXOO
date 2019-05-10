//
//  TYPromotionVIPTableViewCell.h
//  XXOO
//
//  Created by wbb on 2019/5/6.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYPromotionVIPModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^PaySelectBlock)(void);
@interface TYPromotionVIPTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *describeLab;
@property (weak, nonatomic) IBOutlet UILabel *favorableLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *shengjiBtn;
@property (nonatomic, copy) PaySelectBlock paySelectBlock;



@property (nonatomic, strong) TYPromotionVIPModel * model;

@end

NS_ASSUME_NONNULL_END
