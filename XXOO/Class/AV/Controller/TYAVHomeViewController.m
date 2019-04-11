//
//  TYAVHomeViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/11.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYAVHomeViewController.h"

@interface TYAVHomeViewController ()

@end

@implementation TYAVHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIButton *thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdBtn.frame = CGRectMake(10, 50, 200, 44);
    
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 200, 44);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.2),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor redColor] CGColor],(id)[TYRGBColor(100, 100, 100) CGColor]]];//渐变数组
    [thirdBtn.layer addSublayer:gradientLayer];
    
    [thirdBtn setTitle:@"代码创建的按钮，使用layer" forState:UIControlStateNormal];
    
    [self.view addSubview:thirdBtn];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
