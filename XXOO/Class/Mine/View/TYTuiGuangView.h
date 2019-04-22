//
//  TYTuiGuangView.h
//  XXOO
//
//  Created by wbb on 2019/4/18.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYTuiGuangView : TYBaseView

@property (weak, nonatomic) IBOutlet UIImageView *tuiGuangBackImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topStackViewLayout;
@property (weak, nonatomic) IBOutlet UIView *tiXianBackView;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiaJiBtn;
@property (strong, nonatomic) UILabel *lineLab;

@property (nonatomic, strong) UIButton * selectBtn;
@end

NS_ASSUME_NONNULL_END
