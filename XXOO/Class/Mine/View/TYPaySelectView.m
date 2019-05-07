//
//  TYPaySelectView.m
//  XXOO
//
//  Created by wbb on 2019/5/4.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYPaySelectView.h"
@interface TYPaySelectView()


@property (nonatomic, strong) UIButton * selectBtn;
@property (nonatomic, copy) NSString * type;

//@property (nonatomic, copy) NSString * payoutMoney;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * bankName;
@property (nonatomic, copy) NSString * kaHao;
@end
@implementation TYPaySelectView
- (IBAction)payState:(UIButton *)sender {
    if(_selectBtn == sender) return;
    [sender setBackgroundColor:hexColor(FFF4F5)];
    [_selectBtn setBackgroundColor:[UIColor whiteColor]];
    if (sender == _zhifubaoBtn) {
        self.bankNameView.hidden = YES;
        self.kaHaoTopLayout.constant = 10;
        self.leftTitleLab.text = @"支付宝账号";
        self.kaHaoTF.placeholder = @"请输入支付宝账号";
        self.type = @"1";
    }else {
        self.bankNameView.hidden = NO;
        self.kaHaoTopLayout.constant = 65;
        self.leftTitleLab.text = @"银行卡号";
        self.kaHaoTF.placeholder = @"请输入银行卡号";
         self.type = @"2";
    }
    
    _selectBtn = sender;
}
- (IBAction)allTiXian:(UIButton *)sender {
    self.currentMoneyTF.text = [NSString stringWithFormat:@"%@",self.tixianMoney];
}
- (IBAction)sureTiXian:(UIButton *)sender {
    [self userWithdrawRequestData];
}
- (IBAction)editingChange:(UITextField *)sender {
    if (sender == _currentMoneyTF) {
        self.tixianMoney = sender.text;
    }else if(sender == _userNameTF) {
        _userName = sender.text;
    }else if(sender == _bankNameTF) {
        _bankName = sender.text;
    }else if(sender == _kaHaoTF) {
        if ([self.type isEqualToString:@"1"]) {
            _kaHao = sender.text;
        }else {
            _kaHao = sender.text;
        }
        
    }
}

//- (IBAction)changeTF:(UITextField *)sender {
//    if (sender == _currentMoneyTF) {
//        self.tixianMoney = sender.text;
//    }else if(sender == _userNameTF) {
//        _userName = sender.text;
//    }else if(sender == _bankNameTF) {
//        _bankName = sender.text;
//    }else if(sender == _kaHaoTF) {
//        if ([self.type isEqualToString:@"1"]) {
//            _kaHao = sender.text;
//        }else {
//            _kaHao = sender.text;
//        }
//        
//    }
//    
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    _selectBtn = _bankBtn;
    self.type = @"2";
    if (self.tixianMoney.length>0) {
        self.allManeyLab.text = [NSString stringWithFormat:@"可提现金额：%@",self.tixianMoney];
    }
    [self.backView addTarget:self action:@selector(cancelView)];
}
- (void)cancelView {
    self.hidden = YES;
}

//  /userWithdraw/api/userWithdraw
- (void)userWithdrawRequestData {
    if (self.tixianMoney.length==0) {
        [MBProgressHUD promptMessage:@"请填写提现金额" inView:self];
        return;
    }
    if (self.userName.length==0) {
        [MBProgressHUD promptMessage:@"请填写收款人姓名" inView:self];
        return;
    }
    if (self.bankName.length==0) {
        [MBProgressHUD promptMessage:@"请填写银行名称" inView:self];
        return;
    }
    if (self.kaHao.length==0) {
        [MBProgressHUD promptMessage:[self.type isEqualToString:@"1"]?@"请填写支付宝账号":@"请填写银行卡号" inView:self];
        return;
    }
    
    NSDictionary * dic = @{
                           @"id":[TYGlobal userId],
                           @"type":self.type?:@"",
                           @"account":self.kaHao?:@"",
                           @"payee":self.userName?:@"",
                           @"bankName":self.bankName?:@"",
                           @"money":self.tixianMoney?:@""
                           };
    [MBProgressHUD showHUDAddedTo:self animated:YES];

    [TYNetWorkTool postRequest:@"/userWithdraw/api/userWithdraw" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self animated:YES];
    
        [MBProgressHUD promptMessage:msg inView:self];

    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        
    }];
}
@end
