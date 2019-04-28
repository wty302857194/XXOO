//
//  TYTaskTableViewCell.m
//  XXOO
//
//  Created by wbb on 2019/4/12.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYTaskTableViewCell.h"
#import "TYTaskModel.h"

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

-(void)setTaskModel:(TYTaskModel *)taskModel {
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",IMAGE_URL_main,taskModel.icon?:@""];
    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:PLACEHOLEDERIMAGE];
    
    self.titleLab.text = taskModel.title?:@"";
    self.contentLab.text = taskModel.content?:@"";
    self.jiFenLab.text = [NSString stringWithFormat:@"+%@",taskModel.score?:@""];
    [self.planBtn setTitle:taskModel.btnContent?:@"" forState:UIControlStateNormal];
}

@end
