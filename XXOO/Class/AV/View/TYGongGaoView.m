//
//  TYGongGaoView.m
//  XXOO
//
//  Created by wbb on 2019/5/17.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYGongGaoView.h"

@implementation TYGongGaoView
-(void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.contentLab.text = @"";
}
- (IBAction)cancel:(UIButton *)sender {
    self.hidden = YES;
}

@end
