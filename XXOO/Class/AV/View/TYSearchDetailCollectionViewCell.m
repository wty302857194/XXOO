//
//  TYSearchDetailCollectionViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/21.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYSearchDetailCollectionViewCell.h"

@implementation TYSearchDetailCollectionViewCell
- (IBAction)collectionClick:(UIButton *)sender {
    if (self.itemShouCangBlock) {
        self.itemShouCangBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.timeLab.text = @"";
    self.contentLab.text = @"";
}

- (void)setItemModel:(TYHomeItemModel *)itemModel {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:itemModel.cover] placeholderImage:PLACEHOLEDERIMAGE];
    self.timeLab.text = itemModel.timeLong;
    self.contentLab.text = itemModel.title;
    
}
@end
