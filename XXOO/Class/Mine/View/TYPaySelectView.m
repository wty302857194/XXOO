//
//  TYPaySelectView.m
//  XXOO
//
//  Created by wbb on 2019/5/4.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYPaySelectView.h"
@interface TYPaySelectView()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;
@property (weak, nonatomic) IBOutlet UITextField *currentMoneyTF;
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UIView *bankNameView;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLab;
@property (weak, nonatomic) IBOutlet UITextField *kaHaoTF;
@property (weak, nonatomic) IBOutlet UILabel *allManeyLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *kaHaoTopLayout;

@property (nonatomic, strong) UIButton * selectBtn;
@end
@implementation TYPaySelectView
- (IBAction)payState:(UIButton *)sender {
    if (sender == _zhifubaoBtn) {
        self.bankNameView.hidden = YES;
        self.kaHaoTopLayout.constant = 10;
        self.leftTitleLab.text = @"支付宝账号";
        self.kaHaoTF.placeholder = @"请输入支付宝账号";
    }else {
        self.bankNameView.hidden = NO;
        self.kaHaoTopLayout.constant = 65;
        self.leftTitleLab.text = @"银行卡号";
        self.kaHaoTF.placeholder = @"请输入银行卡号";
    }
    
    _selectBtn = sender;
}
- (IBAction)allTiXian:(UIButton *)sender {
    
}
- (IBAction)sureTiXian:(UIButton *)sender {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _selectBtn = _bankBtn;
    [self.backView addTarget:self action:@selector(cancelView)];
}
- (void)cancelView {
    self.hidden = YES;
}
@end
