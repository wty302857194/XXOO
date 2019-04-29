//
//  UINavigationController+TYExtension.m
//  XXOO
//
//  Created by wbb on 2019/4/29.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "UINavigationController+TYExtension.h"

@implementation UINavigationController (TYExtension)
- (void)pushVC:(UIViewController *)viewController animated:(BOOL)animated {
    [self pushViewController:viewController animated:animated];
//    if (self.viewControllers.count > 0) {
//        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19],NSForegroundColorAttributeName:main_text_color}];
//        
//        //        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mineGoBickImg"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//        //        self.navigationItem.leftBarButtonItem = backItem;
//        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"mineGoBickImg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//        backItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        viewController.navigationItem.leftBarButtonItem = backItem;
//    }
}
@end
