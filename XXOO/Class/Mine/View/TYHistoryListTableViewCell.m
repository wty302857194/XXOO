//
//  TYHistoryListTableViewCell.m
//  XXOO
//
//  Created by wbb on 2019/5/1.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYHistoryListTableViewCell.h"

@implementation TYHistoryListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameLab.text = @"";
    self.longTimeLab.text = @"";
    self.dateLab.text = @"";
}
-(void)setModel:(TYAVHistoryModel *)model {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:PLACEHOLEDERIMAGE];
    self.nameLab.text = model.title;
    self.longTimeLab.text = model.longTimes;
    self.dateLab.text = model.createTime;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
