//
//  TYGradientButton.m
//  XXOO
//
//  Created by wbb on 2019/4/11.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYGradientButton.h"

@implementation TYGradientButton

-(void)awakeFromNib {
    [super awakeFromNib];
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor redColor] CGColor],(id)[TYRGBColor(100, 100, 100) CGColor]]];//渐变数组
    [self.layer addSublayer:gradientLayer];
    
}

@end
