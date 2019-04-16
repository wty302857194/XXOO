//
//  TYBaseView.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseView.h"

@implementation TYBaseView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    [super awakeFromNib];
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.locations = @[@(0.1),@(0.6),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[hexColor(d87ff7) CGColor],(id)[hexColor(c97df9) CGColor],(id)[hexColor(fa84f2) CGColor]]];//渐变数组
    [self.layer addSublayer:gradientLayer];
    
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

@end
