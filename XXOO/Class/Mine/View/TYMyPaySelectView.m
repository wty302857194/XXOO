//
//  TYMyPaySelectView.m
//  XXOO
//
//  Created by wbb on 2019/5/9.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYMyPaySelectView.h"

@implementation TYMyPaySelectView
- (IBAction)cancel:(UIButton *)sender {
    self.hidden = YES;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [_weiChaView addTarget:self action:@selector(weiXinSelect)];
    [_airPlayView addTarget:self action:@selector(airPlaySelect)];
}
- (void)weiXinSelect {
    _weiChaImg.image = [UIImage imageNamed:@"paySelectImage"];
    _selectImage.image = [UIImage imageNamed:@"selectNomalImage"];
    if (self.selectBlock) {
        self.selectBlock(2);
    }
}
- (void)airPlaySelect {
    _weiChaImg.image = [UIImage imageNamed:@"selectNomalImage"];
    _selectImage.image = [UIImage imageNamed:@"paySelectImage"];
    if (self.selectBlock) {
        self.selectBlock(1);
    }
}
@end
