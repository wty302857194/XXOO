//
//  TYTaskTableViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/12.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYTaskTableViewCell.h"

@implementation TYTaskTableViewCell
- (IBAction)goPlanClick:(UIButton *)sender {
    if (self.goPlanBlock) {
        self.goPlanBlock();
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
