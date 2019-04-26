//
//  AppDelegate.m
//  XXOO
//
//  Created by wbb on 2019/4/10.
//  Copyright © 2019 wbb. All rights reserved.
//

#import "AppDelegate.h"
#import "TYBaseTabBarViewController.h"
#import "OpenInstallSDK.h"

@interface AppDelegate ()<OpenInstallDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [OpenInstallSDK initWithDelegate:self];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREENH_HEIGHT)];
    TYBaseTabBarViewController *tabBarVC = [[TYBaseTabBarViewController alloc] init];
    self.window.rootViewController = tabBarVC;

    
    [self getInstallParms];

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)getInstallParms {
    
//    [[OpenInstallSDK defaultManager] getInstallParmsCompleted:^(OpeninstallData*_Nullable appData) {
//        //在主线程中回调
//        if (appData.data) {//(动态安装参数)
//            //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
//        }
//        if (appData.channelCode) {//(通过渠道链接或二维码安装会返回渠道编号)
//            //e.g.可自己统计渠道相关数据等
//        }
//
//        //弹出提示框(便于调试，调试完成后删除此代码)
//        NSString *parameter = [NSString stringWithFormat:@"如果没有任何参数返回，请确认：\n1、新应用是否上传安装包(是否集成完毕)  2、是否正确配置appKey  3、是否通过含有动态参数的分享链接(或二维码)安装的app\n\n动态参数：\n%@\n渠道编号：%@",appData.data,appData.channelCode];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"安装参数" message:parameter delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }];
    
    
    //做一个延时处理
    [[OpenInstallSDK defaultManager] getInstallParmsWithTimeoutInterval:10 completed:^(OpeninstallData * _Nullable appData) {
        //在主线程中回调
        if (appData.data) {//(动态安装参数)
            //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
        }
        if (appData.channelCode) {//(通过渠道链接或二维码安装会返回渠道编号)
            //e.g.可自己统计渠道相关数据等
        }
        
        //弹出提示框(便于调试，调试完成后删除此代码)
        NSString *parameter = [NSString stringWithFormat:@"如果没有任何参数返回，请确认：\n1、新应用是否上传安装包(是否集成完毕)  2、是否正确配置appKey  3、是否通过含有动态参数的分享链接(或二维码)安装的app\n\n动态参数：\n%@\n渠道编号：%@",appData.data,appData.channelCode];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"安装参数" message:parameter delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }];
}
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray<id<UIUserActivityRestoring>> * __nullable restorableObjects))restorationHandler NS_AVAILABLE_IOS(8_0) {
    //判断是否通过OpenInstall Universal Link 唤起App
    if ([OpenInstallSDK continueUserActivity:userActivity]){//如果使用了Universal link ，此方法必写
        return YES;
    }
    //其他第三方回调；
    return YES;
}
//iOS9以上，会优先走这个方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(nonnull NSDictionary *)options{
    //判断是否通过OpenInstall URL Scheme 唤起App
    if  ([OpenInstallSDK handLinkURL:url]){//必写
        return YES;
    }
    //其他第三方回调；
    return YES;
    
}
//通过OpenInstall获取已经安装App被唤醒时的参数（如果是通过渠道页面唤醒App时，会返回渠道编号）
-(void)getWakeUpParams:(OpeninstallData *)appData {
    if (appData.data) {//(动态唤醒参数)
        //e.g.如免填邀请码建立邀请关系、自动加好友、自动进入某个群组或房间等
    }
    if (appData.channelCode) {//(通过渠道链接或二维码唤醒会返回渠道编号)
        //e.g.可自己统计渠道相关数据等
    }
    //弹出提示框(便于调试，调试完成后删除此代码)
    NSLog(@"OpenInstallSDK:\n动态参数：%@;\n渠道编号：%@",appData.data,appData.channelCode);
    NSString *parameter = [NSString stringWithFormat:@"如果没有任何参数返回，请确认：\n是否通过含有动态参数的分享链接(或二维码)唤醒的app\n\n动态参数：\n%@\n渠道编号：%@",appData.data,appData.channelCode];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"唤醒参数" message:parameter delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
