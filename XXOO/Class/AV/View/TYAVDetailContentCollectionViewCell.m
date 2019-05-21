//
//  TYAVDetailContentCollectionViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVDetailContentCollectionViewCell.h"

@implementation TYAVDetailContentCollectionViewCell
- (IBAction)saveClick:(UIButton *)sender {
    if (self.itemShouCangBlock) {
        self.itemShouCangBlock();
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLab.text = @"";
}
-(void)setItemModel:(TYHomeItemModel *)itemModel {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:itemModel.cover] placeholderImage:PLACEHOLEDERIMAGE];
    self.nameLab.text = itemModel.title;
    
    if ([itemModel.cstate isEqualToString:@"0"]) {
        [self.saveBtn setImage:[UIImage imageNamed:@"home_add"] forState:UIControlStateNormal];
    }else {
        [self.saveBtn setImage:[UIImage imageNamed:@"shoucang_image"] forState:UIControlStateNormal];
    }
    if (itemModel.icon&&itemModel.icon.length>0) {
        self.xianMianLogo.hidden = NO;
        [self.xianMianLogo sd_setImageWithURL:[NSURL URLWithString:itemModel.icon?:@""]];
    }else {
        self.xianMianLogo.hidden = YES;
    }
    
    if (itemModel.latest&&itemModel.latest.length>0) {
        self.xianMianLogo.hidden = NO;
        [self.xianMianLogo sd_setImageWithURL:[NSURL URLWithString:itemModel.latest?:@""]];
    }else {
        self.xianMianLogo.hidden = YES;
    }
}
@end
