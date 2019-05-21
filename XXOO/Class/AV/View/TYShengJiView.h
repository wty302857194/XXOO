//
//  TYShengJiView.h
//  XXOO
//
//  Created by wbb on 2019/5/20.
//  Copyright © 2019 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYShengJiView : TYBaseView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic, strong) NSDictionary * dataDic;
@end

NS_ASSUME_NONNULL_END
