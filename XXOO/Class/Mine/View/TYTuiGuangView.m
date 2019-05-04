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
 {
 todayRechargeMoney: null,             //今日充值金额
 spreadNum: 0,                         //累计推广人数
 todaySpreadMoney: null,               //今日推广金额
 todaySpreadNum: 0,                    //今日推广人数
 spreadMoney: 0,                       //累计推广佣金
 withdrawMoney: 0,                    //可提现金额
 rechargeMoney: 0                      //累计充值金额
 }
 */
- (void)setDataDic:(NSDictionary *)dataDic {
    self.allManeyLab.text = [NSString stringWithFormat:@"%@",dataDic[@"spreadMoney"]];
    self.cunnentMoneyLab.text = [NSString stringWithFormat:@"今日%@元",dataDic[@"todaySpreadMoney"]];
    
    self.allPeasonLab.text = [NSString stringWithFormat:@"%@",dataDic[@"spreadNum"]];
    self.currentPeasonLab.text = [NSString stringWithFormat:@"今日%@人",dataDic[@"todaySpreadNum"]];
    
    self.allPayMoneyLab.text = [NSString stringWithFormat:@"%@",dataDic[@"rechargeMoney"]];
    self.currentPayMoneyLab.text = [NSString stringWithFormat:@"今日%@元",dataDic[@"todayRechargeMoney"]];
    
    self.withdrawMoneyLab.text = [NSString stringWithFormat:@"可提现金额：%@元",dataDic[@"withdrawMoney"]];

}
- (void)awakeFromNib {
    [super awakeFromNib];
    _selectBtn = _userBtn;
    self.topStackViewLayout.constant = 20 + kLayoutViewMarginTop;
    
    [self layoutIfNeeded];
    
    [self.tiXianBackView addTarget:self action:@selector(tiXianClick)];
    
}
-(void)tiXianClick {
    if (self.tiXianBlock) {
        self.tiXianBlock();
    }
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
