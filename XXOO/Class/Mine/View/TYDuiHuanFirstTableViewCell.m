//
//  TYDuiHuanFirstTableViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYDuiHuanFirstTableViewCell.h"

@implementation TYDuiHuanFirstTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.leftView addTarget:self action:@selector(buyVIP)];
    [self.rightView addTarget:self action:@selector(goTask)];
}
- (void)buyVIP {
    if (self.cellBackBlock) {
        self.cellBackBlock(0);
    }
}
- (void)goTask {
    if (self.cellBackBlock) {
        self.cellBackBlock(1);
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
