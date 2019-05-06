//
//  TYTuiGuangEmptyView.m
//  XXOO
//
//  Created by wbb on 2019/5/5.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYTuiGuangEmptyView.h"

@implementation TYTuiGuangEmptyView

- (IBAction)tuiGuangBtn:(UIButton *)sender {
    if (self.tuiGuangBlcok) {
        self.tuiGuangBlcok();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
