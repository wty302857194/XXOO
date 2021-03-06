//
//  TYShengJiView.m
//  XXOO
//
//  Created by wbb on 2019/5/20.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYShengJiView.h"

@implementation TYShengJiView
- (IBAction)shengJi:(UIButton *)sender {
    [TYGlobal openScheme:self.dataDic[@"url"]?:@""];
    [self exitApplication];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

    self.contentLab.text = @"";
    self.titleLab.text = @"";
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    self.contentLab.text = [NSString stringWithFormat:@"%@",dataDic[@"content"]?:@""];
    self.titleLab.text = [NSString stringWithFormat:@"发现新版本！(最新版本V%@)",dataDic[@"deviceCode"]?:@""];
    
}

- (void)exitApplication {
    
    // 动画 1
    [UIView animateWithDuration:1.0f animations:^{
        kWindow.alpha = 0;
        kWindow.frame = CGRectMake(0, kWindow.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
    //exit(0);
    
}
@end
