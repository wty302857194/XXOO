//
//  TYAVDetailContentCollectionViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVDetailContentCollectionViewCell.h"

@implementation TYAVDetailContentCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLab.text = @"";
}
-(void)setItemModel:(TYHomeItemModel *)itemModel {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:itemModel.cover] placeholderImage:PLACEHOLEDERIMAGE];
    self.nameLab.text = itemModel.title;
}
@end
