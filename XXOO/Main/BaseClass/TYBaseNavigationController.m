//
//  TYBaseNavigationController.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseNavigationController.h"

@interface TYBaseNavigationController ()

@end

@implementation TYBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationBar.translucent = NO;
//    self.navigationBar.tintColor = [UIColor whiteColor];
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, -kStatusBarHeight, KSCREEN_WIDTH, kLayoutViewMarginTop);
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.locations = @[@(0.5),@(1.0)];//渐变点
    [gradientLayer setColors:@[(id)[[UIColor redColor] CGColor],(id)[TYRGBColor(100, 100, 100) CGColor]]];//渐变数组
    [self.navigationBar.layer addSublayer:gradientLayer];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        self.navigationBar.barStyle = UIBarStyleDefault;
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    [super pushViewController:viewController animated:animated];
}



@end
