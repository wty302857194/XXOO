//
//  TYGoddessCollectionViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/16.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYGoddessCollectionViewCell.h"

@implementation TYGoddessCollectionViewCell
- (IBAction)shouCang:(UIButton *)sender {
    if (self.shouCangBlock) {
        self.shouCangBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setListModel:(TYActorListModel *)listModel {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:listModel.avatar] placeholderImage:PLACEHOLEDERIMAGE];
    self.nameLab.text = listModel.name;
}

-(void)setGoddessModel:(TYAVHistoryModel *)goddessModel {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:goddessModel.cover] placeholderImage:PLACEHOLEDERIMAGE];
    self.nameLab.text = goddessModel.title;
}
@end
