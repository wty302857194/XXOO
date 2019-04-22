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
    _selectBtn = _userBtn;
    self.topStackViewLayout.constant = 20 + kLayoutViewMarginTop;
    
    [self layoutIfNeeded];
    
    [self.tiXianBackView addTarget:self action:@selector(tiXianClick)];
    
}
-(void)tiXianClick {
    
}
- (IBAction)btnClick:(UIButton *)sender {
    if (sender == _selectBtn) return;

    [sender setTitleColor:main_select_text_color forState:UIControlStateNormal];
    [_selectBtn setTitleColor:main_light_text_color forState:UIControlStateNormal];
    if (sender == _userBtn) {

    }else {

    }
    self.lineLab.center = CGPointMake(sender.center.x, self.lineLab.centerY);

    _selectBtn = sender;
}
@end
