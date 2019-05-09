//
//  TYPromotionVIPView.m
//  XXOO
//
//  Created by wbb on 2019/5/6.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYPromotionVIPView.h"


@implementation TYPromotionVIPView
- (IBAction)changeMoney:(UIButton *)sender {
    if (_selectBtn == sender) return;
    if(_taiBiBtn == sender) {
        [MBProgressHUD promptMessage:@"该功能暂未开发，尽请期待" inView:self.superview];
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.topBackImg.center = CGPointMake(sender.center.x, self.topBackImg.centerY);
    }];

    if (self.promotionVIPBlock) {
        self.promotionVIPBlock(sender == _renMinBIBnt?@"1":@"2");
    }
    
    _selectBtn = sender;
}

-(void)awakeFromNib {
    [super awakeFromNib];
//    _selectBtn = _renMinBIBnt;
}

@end
