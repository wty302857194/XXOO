//
//  TYUserHeaderView.m
//  XXOO
//
//  Created by wbb on 2019/5/25.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYUserHeaderView.h"

@implementation TYUserHeaderView
- (IBAction)settingClick:(UIButton *)sender {
    
    if (self.userSettingBlock) {
        self.userSettingBlock();
    }
    
}
- (IBAction)buyVIPClick:(UIButton *)sender {
    
    if (self.buyVIPBlock) {
        self.buyVIPBlock();
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.timeLab.text = @"";
    [self.contentView sendSubviewToBack:self.backImgView];
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_URL_main,self.dataDic[@"avatar"]]] placeholderImage:PLACEHOLEDERIMAGE];
    self.userNameLab.text = [NSString stringWithFormat:@"代理用户（%@）",self.dataDic[@"name"]];
    NSString *level = [NSString stringWithFormat:@"%@",self.dataDic[@"level"]];
    if ([level isEqualToString:@"1"]) {
        self.vipLogoImg.image = [UIImage imageNamed:@"ming_vip_img"];
        self.timeLab.text = @"";
    }else {
        self.vipLogoImg.image = [UIImage imageNamed:@"mineVIPImg"];
        self.timeLab.text = [NSString stringWithFormat:@"%@到期",self.dataDic[@"membershipEndTime"]?:@""];
    }
}
@end
