//
//  TYTuiGuangView.m
//  XXOO
//
//  Created by wbb on 2019/4/18.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYTuiGuangView.h"

@implementation TYTuiGuangView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topStackViewLayout.constant = 20 + kLayoutViewMarginTop;
    
    [self layoutIfNeeded];
    
    [self.tiXianBackView addTarget:self action:@selector(tiXianClick)];
}
-(void)tiXianClick {
    
}
- (IBAction)btnClick:(UIButton *)sender {
    if (sender == _selectBtn) return;
    
    if (sender == _userBtn) {
        
    }else {
        
    }
    
    [self.lineLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(sender.mas_centerX);
    }];
    _selectBtn = sender;
}
@end
