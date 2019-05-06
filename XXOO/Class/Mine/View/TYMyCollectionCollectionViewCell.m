//
//  TYMyCollectionCollectionViewCell.m
//  XXOO
//
//  Created by wbb on 2019/5/1.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYMyCollectionCollectionViewCell.h"

@implementation TYMyCollectionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLab.text = @"";
}
- (void)setCollectionModel:(TYAVHistoryModel *)collectionModel {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:collectionModel.cover] placeholderImage:PLACEHOLEDERIMAGE];
    self.nameLab.text = collectionModel.title;
}
@end
