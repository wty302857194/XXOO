//
//  TYTuiGuangView.h
//  XXOO
//
//  Created by wbb on 2019/4/18.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TiXianBlock)(void);
typedef void(^LevelAgentBlock)(NSInteger index);
@interface TYTuiGuangView : TYBaseView

@property (weak, nonatomic) IBOutlet UIImageView *tuiGuangBackImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topStackViewLayout;
@property (weak, nonatomic) IBOutlet UIView *tiXianBackView;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiaJiBtn;
@property (weak, nonatomic) IBOutlet UILabel *allManeyLab;
@property (weak, nonatomic) IBOutlet UILabel *cunnentMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *allPeasonLab;
@property (weak, nonatomic) IBOutlet UILabel *currentPeasonLab;
@property (weak, nonatomic) IBOutlet UILabel *allPayMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *currentPayMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *withdrawMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *lineLab;

@property (nonatomic, strong) UIButton * selectBtn;

@property (nonatomic, copy) TiXianBlock tiXianBlock;
@property (nonatomic, copy) LevelAgentBlock levelAgentBlock;

@property (nonatomic, strong) NSDictionary * dataDic;
@end

NS_ASSUME_NONNULL_END
