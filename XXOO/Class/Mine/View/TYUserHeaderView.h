//
//  TYUserHeaderView.h
//  XXOO
//
//  Created by wbb on 2019/5/25.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^UserSettingBlock)(void);
typedef void(^BuyVIPBlock)(void);

@interface TYUserHeaderView : TYBaseView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLayout;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UIImageView *vipLogoImg;
@property (weak, nonatomic) IBOutlet UIButton *buyVIPBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backImgLayout;

@property (nonatomic, strong) NSDictionary * dataDic;
@property (nonatomic, copy) UserSettingBlock userSettingBlock;
@property (nonatomic, copy) BuyVIPBlock buyVIPBlock;

@end

NS_ASSUME_NONNULL_END
