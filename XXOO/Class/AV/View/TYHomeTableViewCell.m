//
//  TYHomeTableViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/12.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYHomeTableViewCell.h"

@implementation TYHomeTableViewCell

- (IBAction)saveClick:(UIButton *)sender {
    if (self.itemShouCangBlock) {
        self.itemShouCangBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setItemModel:(TYHomeItemModel *)itemModel {
    [self.contentImg sendSubviewToBack:self.contentView];
    [self.contentImg sd_setImageWithURL:[NSURL URLWithString:itemModel.cover?:@""] placeholderImage:PLACEHOLEDERIMAGE];
    self.nameLab.text = itemModel.title;
    self.timeLab.text = itemModel.createTime;
    if ([itemModel.cstate isEqualToString:@"0"]) {
        [self.saveBtn setImage:[UIImage imageNamed:@"home_add"] forState:UIControlStateNormal];
    }else {
        [self.saveBtn setImage:[UIImage imageNamed:@"shoucang_image"] forState:UIControlStateNormal];
    }
    if (itemModel.icon&&itemModel.icon.length>0) {
        self.xianMianLogo.hidden = NO;
        [self.xianMianLogo sd_setImageWithURL:[NSURL URLWithString:itemModel.icon?:@""]];
    }else {        
        if (itemModel.latest&&itemModel.latest.length>0) {
            self.xianMianLogo.hidden = NO;
            [self.xianMianLogo sd_setImageWithURL:[NSURL URLWithString:itemModel.latest?:@""]];
        }else {
            self.xianMianLogo.hidden = YES;
        }
    }
    
    
}

@end
