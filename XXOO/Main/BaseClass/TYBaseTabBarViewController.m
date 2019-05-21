//
//  TYBaseTabBarViewController.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "TYBaseTabBarViewController.h"
#import "TYBaseNavigationController.h"
#import "TYTaskViewController.h"
#import "TYCategoryViewController.h"
#import "TYEntertainmentViewController.h"
#import "TYAVViewController.h"
#import "TYUserTableViewController.h"
#import "HDeviceIdentifier.h"

@interface TYBaseTabBarViewController ()

@end

@implementation TYBaseTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = main_select_text_color;
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
    
    [self addTabBarVC:[[TYAVViewController alloc] init] withTitle:@"av" withNormalImage:@"av_tabbar_normal" withSelectImage:@"av_tabbar_select"];
    [self addTabBarVC:[[TYEntertainmentViewController alloc] init] withTitle:@"娱乐" withNormalImage:@"Entertainment_table_normal" withSelectImage:@"Entertainment_table_select"];
    [self addTabBarVC:[[TYCategoryViewController alloc] init] withTitle:@"分类" withNormalImage:@"category_tabbar_normal" withSelectImage:@"category_tabbar_select"];
    [self addTabBarVC:[[TYTaskViewController alloc] init] withTitle:@"任务" withNormalImage:@"task_tabbar_normal" withSelectImage:@"task_tabbar_select"];
    
    TYUserTableViewController *testVC =  [[UIStoryboard storyboardWithName:@"mine" bundle:nil] instantiateViewControllerWithIdentifier:@"TYUserTableViewController"];;
    [self addTabBarVC:testVC withTitle:@"我的" withNormalImage:@"mine_tabbar_normal" withSelectImage:@"mine_tabbar_select"];

    
    
}

- (void)addTabBarVC:(UIViewController *)viewController withTitle:(NSString *)title withNormalImage:(NSString *)normalImage withSelectImage:(NSString *)selectImage {
    
    viewController.tabBarItem.image = [UIImage imageNamed:normalImage];
    viewController.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    viewController.tabBarItem.title = title;
    TYBaseNavigationController *nav = [[TYBaseNavigationController alloc] initWithRootViewController:viewController];
    
    [self addChildViewController:nav];
}

@end
