//
//  TYPaySelectView.h
//  XXOO
//
//  Created by wbb on 2019/5/4.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseView.h"

NS_ASSUME_NONNULL_BEGIN
//typedef void(^ALLTiXianBlock)(void);
@interface TYPaySelectView : TYBaseView
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

@property (nonatomic, copy) NSString * tixianMoney;
@property (nonatomic, copy) NSString * currentMoney;
@end

NS_ASSUME_NONNULL_END
