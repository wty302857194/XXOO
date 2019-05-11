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
- (IBAction)sureClick:(UIButton *)sender {
    if (self.type == 0) {
        [MBProgressHUD promptMessage:@" 请选择支付方式" inView:self];
        return;
    }
    if (self.selectBlock) {
        self.selectBlock(self.type);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [_weiChaView addTarget:self action:@selector(weiXinSelect)];
    [_airPlayView addTarget:self action:@selector(airPlaySelect)];
    self.type = 0;
}
- (void)weiXinSelect {
    _weiChaImg.image = [UIImage imageNamed:@"paySelectImage"];
    _selectImage.image = [UIImage imageNamed:@"selectNomalImage"];
    self.type = 2;

}
- (void)airPlaySelect {
    _weiChaImg.image = [UIImage imageNamed:@"selectNomalImage"];
    _selectImage.image = [UIImage imageNamed:@"paySelectImage"];
    self.type = 1;
    
}
@end
