//
//  TYAVCategoryCollectionViewCell.m
//  XXOO
//
//  Created by wbb on 2019/5/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVCategoryCollectionViewCell.h"

@implementation TYAVCategoryCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLab.text = @"";
}
-(void)setModel:(TYAVCategaryModel *)model {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:PLACEHOLEDERIMAGE];
    self.nameLab.text= [NSString stringWithFormat:@"%@", model.name];
}
@end
