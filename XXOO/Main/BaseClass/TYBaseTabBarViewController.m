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

    
    [self getUserRequestData];
}

- (void)addTabBarVC:(UIViewController *)viewController withTitle:(NSString *)title withNormalImage:(NSString *)normalImage withSelectImage:(NSString *)selectImage {
    
    viewController.tabBarItem.image = [UIImage imageNamed:normalImage];
    viewController.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    viewController.tabBarItem.title = title;
    TYBaseNavigationController *nav = [[TYBaseNavigationController alloc] initWithRootViewController:viewController];
    
    [self addChildViewController:nav];
}
/*
 {
 avatar: "1.png",               //用户头像
 gestureBtn: 2,                 //手势密码是否开启（1开启 2关闭）
 id: 1,                         //主键id
 level: 1,                      //用户等级（1普通用户 2会员）
 levelAgent: 3,                 //代理级别（1一级代理 2二级代理 3普通代理）
 name: "",                      //用户昵称
 playTimes: 3,                  //'播放次数',
 score: 0,                      // 积分
 spreadNum: 0,                  //推广数量
 viewTimes: 0                   //观看次数
 }
 */
- (void)getUserRequestData {
    NSDictionary * dic = @{
                           @"imei":[TYGlobal getDeviceIdentifier],
                           };
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [TYNetWorkTool postRequest:@"/user/api/login" parameters:dic successBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (success&&data) {
            NSDictionary *dic = [NSDictionary nullDic:data];
            [USER_DEFAULTS setObject:dic forKey:USERMESSAGE];
            [USER_DEFAULTS synchronize];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}
//- (void)firstRequestData {
//    //获取唯一设备标识
//    NSString *deviceIdentifier = [HDeviceIdentifier deviceIdentifier];
//    NSLog(@"唯一设备标识:%@",deviceIdentifier);
//
//    //判断应用是第一次在这台手机上安装
//    BOOL isFirstInstall = [HDeviceIdentifier isFirstInstall];
//    if (isFirstInstall) {
//        NSLog(@"本应用是第一次在这台手机上安装");
//    }else{
//        NSLog(@"本应用不是第一次在这台手机上安装");
//    }
//}

@end
