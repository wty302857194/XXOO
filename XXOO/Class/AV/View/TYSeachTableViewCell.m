//
//  TYSeachTableViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/21.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYSeachTableViewCell.h"

@implementation TYSeachTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.rankLab.text = @"";
    self.titleLab.text = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
