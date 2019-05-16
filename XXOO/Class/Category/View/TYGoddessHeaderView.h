//
//  TYGoddessHeaderView.h
//  XXOO
//
//  Created by wbb on 2019/5/4.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TYGoddessHeaderView : TYBaseView

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *heightLab;
@property (weak, nonatomic) IBOutlet UILabel *xingQuLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *sanWeiLab;

@property (nonatomic, strong) NSDictionary * dataDic;
@end

NS_ASSUME_NONNULL_END
