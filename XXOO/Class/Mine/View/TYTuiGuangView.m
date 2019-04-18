//
//  TYTuiGuangView.m
//  XXOO
//
//  Created by wbb on 2019/4/18.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYTuiGuangView.h"

@implementation TYTuiGuangView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    self.topStackViewLayout.constant = 20 + kLayoutViewMarginTop;
    
    [self layoutIfNeeded];
}
@end
