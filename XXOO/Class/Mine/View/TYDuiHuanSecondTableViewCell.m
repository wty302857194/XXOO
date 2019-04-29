//
//  TYDuiHuanSecondTableViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYDuiHuanSecondTableViewCell.h"

@implementation TYDuiHuanSecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)duiHuan:(UIButton *)sender {
    if (self.duiHuanBlock) {
        self.duiHuanBlock();
    }
}

-(void)setModel:(TYDuiHuanModel *)model {
    _model = model;
    
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL_main,model.icon]] placeholderImage:PLACEHOLEDERIMAGE];
    self.longTimeLab.text = [NSString stringWithFormat:@"%@天VIP特权",model.membershipDuration];
    self.jiFenLAB.text = [NSString stringWithFormat:@"%@积分",model.score];
}

@end
