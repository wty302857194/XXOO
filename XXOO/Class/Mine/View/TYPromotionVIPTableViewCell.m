//
//  TYPromotionVIPTableViewCell.m
//  XXOO
//
//  Created by wbb on 2019/5/6.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYPromotionVIPTableViewCell.h"
#import "TYPromotionVIPModel.h"

@implementation TYPromotionVIPTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (IBAction)shengJi:(UIButton *)sender {
    if (self.paySelectBlock) {
        self.paySelectBlock();
    }
}

-(void)setModel:(TYPromotionVIPModel *)model {
    _model = model;
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:model.icon]];
    self.describeLab.text = model.title?:@"";
    self.favorableLab.text = [NSString stringWithFormat:@"首购优惠加码送%@天",model.favorableDays];
    self.moneyLab.text = model.money;
    [self.shengjiBtn setTitle:model.btn forState:UIControlStateNormal];
    
}

@end
